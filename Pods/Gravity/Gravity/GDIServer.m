//
//  GDIServer.m
//  Gravity
//
//  Created by Grant Davis on 3/19/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import "GDIServer.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <CFNetwork/CFSocketStream.h>


NSString * const GDIServerErrorDomain = @"GDIServerErrorDomain";

@interface GDIServer () {
	uint32_t protocolFamily;
	CFSocketRef witap_socket;
}

@property(nonatomic,retain) NSNetService* netService;
@property(assign) uint16_t port;

@end

@implementation GDIServer


- (id)initWithDelegate:(NSObject <GDIServerDelegate> *)delegate
{
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    [self stop];
}

#pragma mark - Public Interface


- (BOOL)start:(NSError **)error {
    
    CFSocketContext socketCtxt = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
	// Start by trying to do everything with IPv6.  This will work for both IPv4 and IPv6 clients
    // via the miracle of mapped IPv4 addresses.
    
    witap_socket = CFSocketCreate(kCFAllocatorDefault, PF_INET6, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)&TCPServerAcceptCallBack, &socketCtxt);
	
	if (witap_socket != NULL)	// the socket was created successfully
	{
		protocolFamily = PF_INET6;
	} else // there was an error creating the IPv6 socket - could be running under iOS 3.x
	{
		witap_socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, (CFSocketCallBack)&TCPServerAcceptCallBack, &socketCtxt);
		if (witap_socket != NULL)
		{
			protocolFamily = PF_INET;
		}
	}
    
    if (NULL == witap_socket) {
        if (error) *error = [[NSError alloc] initWithDomain:GDIServerErrorDomain code:kGDIServerNoSocketsAvailable userInfo:nil];
        if (witap_socket) CFRelease(witap_socket);
        witap_socket = NULL;
        return NO;
    }
	
	
    int yes = 1;
    setsockopt(CFSocketGetNative(witap_socket), SOL_SOCKET, SO_REUSEADDR, (void *)&yes, sizeof(yes));
	
	// set up the IP endpoint; use port 0, so the kernel will choose an arbitrary port for us, which will be advertised using Bonjour
	if (protocolFamily == PF_INET6)
	{
		struct sockaddr_in6 addr6;
		memset(&addr6, 0, sizeof(addr6));
		addr6.sin6_len = sizeof(addr6);
		addr6.sin6_family = AF_INET6;
		addr6.sin6_port = 0;
		addr6.sin6_flowinfo = 0;
		addr6.sin6_addr = in6addr_any;
		NSData *address6 = [NSData dataWithBytes:&addr6 length:sizeof(addr6)];
		
		if (kCFSocketSuccess != CFSocketSetAddress(witap_socket, (__bridge CFDataRef)address6)) {
			if (error) *error = [[NSError alloc] initWithDomain:GDIServerErrorDomain code:kGDIServerCouldNotBindToIPv6Address userInfo:nil];
			if (witap_socket) CFRelease(witap_socket);
			witap_socket = NULL;
			return NO;
		}
		
		// now that the binding was successful, we get the port number
		// -- we will need it for the NSNetService
		NSData *addr = (__bridge NSData *)CFSocketCopyAddress(witap_socket);
		memcpy(&addr6, [addr bytes], [addr length]);
		self.port = ntohs(addr6.sin6_port);
		
	} else {
		struct sockaddr_in addr4;
		memset(&addr4, 0, sizeof(addr4));
		addr4.sin_len = sizeof(addr4);
		addr4.sin_family = AF_INET;
		addr4.sin_port = 0;
		addr4.sin_addr.s_addr = htonl(INADDR_ANY);
		NSData *address4 = [NSData dataWithBytes:&addr4 length:sizeof(addr4)];
		
		if (kCFSocketSuccess != CFSocketSetAddress(witap_socket, (__bridge CFDataRef)address4)) {
			if (error) *error = [[NSError alloc] initWithDomain:GDIServerErrorDomain code:kGDIServerCouldNotBindToIPv4Address userInfo:nil];
			if (witap_socket) CFRelease(witap_socket);
			witap_socket = NULL;
			return NO;
		}
		
		// now that the binding was successful, we get the port number
		// -- we will need it for the NSNetService
		NSData *addr = (__bridge NSData *)CFSocketCopyAddress(witap_socket);
		memcpy(&addr4, [addr bytes], [addr length]);
		self.port = ntohs(addr4.sin_port);
	}
	
    // set up the run loop sources for the sockets
    CFRunLoopRef cfrl = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, witap_socket, 0);
    CFRunLoopAddSource(cfrl, source, kCFRunLoopCommonModes);
    CFRelease(source);
	
    return YES;
}


- (BOOL)stop {
    [self disableBonjour];
    
	if (witap_socket) {
		CFSocketInvalidate(witap_socket);
		CFRelease(witap_socket);
		witap_socket = NULL;
	}
	
	
    return YES;
}


- (BOOL) enableBonjourWithDomain:(NSString*)domain applicationProtocol:(NSString*)protocol name:(NSString*)name
{
	if(![domain length])
		domain = @""; //Will use default Bonjour registration doamins, typically just ".local"
	if(![name length])
		name = @""; //Will use default Bonjour name, e.g. the name assigned to the device in iTunes
	
	if(!protocol || ![protocol length] || witap_socket == NULL)
		return NO;
	
    
	self.netService = [[NSNetService alloc] initWithDomain:domain type:protocol name:name port:self.port];
	if(self.netService == nil)
		return NO;
	
	[self.netService scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
	[self.netService publish];
	[self.netService setDelegate:self];
	
	return YES;
}


- (void) disableBonjour
{
	if (self.netService) {
		NSLog(@"about to call NetService:stop");
		[self.netService stop];
		[self.netService removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
		self.netService = nil;
	}
}



#pragma mark - 

- (void)handleNewConnectionFromAddress:(NSData *)addr inputStream:(NSInputStream *)istr outputStream:(NSOutputStream *)ostr {
    // if the delegate implements the delegate method, call it
    if (self.delegate && [self.delegate respondsToSelector:@selector(didAcceptConnectionForServer:inputStream:outputStream:)]) {
        [self.delegate didAcceptConnectionForServer:self inputStream:istr outputStream:ostr];
    }
}

// This function is called by CFSocket when a new connection comes in.
// We gather some data here, and convert the function call to a method
// invocation on TCPServer.
static void TCPServerAcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    GDIServer *server = (__bridge GDIServer *)info;
    if (kCFSocketAcceptCallBack == type) {
        // for an AcceptCallBack, the data parameter is a pointer to a CFSocketNativeHandle
        CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
        uint8_t name[SOCK_MAXADDRLEN];
        socklen_t namelen = sizeof(name);
        NSData *peer = nil;
        if (0 == getpeername(nativeSocketHandle, (struct sockaddr *)name, &namelen)) {
            peer = [NSData dataWithBytes:name length:namelen];
        }
        CFReadStreamRef readStream = NULL;
		CFWriteStreamRef writeStream = NULL;
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocketHandle, &readStream, &writeStream);
        if (readStream && writeStream) {
            CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
            [server handleNewConnectionFromAddress:peer inputStream:(__bridge NSInputStream *)readStream outputStream:(__bridge NSOutputStream *)writeStream];
        } else {
            // on any failure, need to destroy the CFSocketNativeHandle
            // since we are not going to use it any more
            close(nativeSocketHandle);
        }
        if (readStream) CFRelease(readStream);
        if (writeStream) CFRelease(writeStream);
    }
}


#pragma mark - NSNetServiceDelegate Methods

/*
 Bonjour will not allow conflicting service instance names (in the same domain), and may have automatically renamed
 the service if there was a conflict.  We pass the name back to the delegate so that the name can be displayed to
 the user.
 See http://developer.apple.com/networking/bonjour/faq.html for more information.
 */
- (void)netServiceDidPublish:(NSNetService *)sender
{
    _name = sender.name;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(serverDidEnableBonjour:withName:)])
		[self.delegate serverDidEnableBonjour:self withName:sender.name];
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    _name = nil;
    
	if (self.delegate && [self.delegate respondsToSelector:@selector(server:didNotEnableBonjour:)])
		[self.delegate server:self didNotEnableBonjour:errorDict];
}


- (NSString *) description
{
	return [NSString stringWithFormat:@"<%@ = 0x%08lX | port %d | netService = %@>", [self class], (long)self, self.port, self.netService];
}

+ (NSString*) bonjourTypeFromIdentifier:(NSString*)identifier
{
	if (![identifier length])
		return nil;
    
    return [NSString stringWithFormat:@"_%@._tcp.", identifier];
}

@end
