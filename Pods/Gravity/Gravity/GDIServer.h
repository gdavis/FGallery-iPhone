//
//  GDIServer.h
//  Gravity
//
//  This class is adopted from the TCPServer provided in Apple's WiTap app.
//
//  Created by Grant Davis on 3/19/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GDIServerDelegate;

NSString * const GDIServerErrorDomain;

typedef enum {
    kGDIServerCouldNotBindToIPv4Address = 1,
    kGDIServerCouldNotBindToIPv6Address = 2,
    kGDIServerNoSocketsAvailable = 3,
} GDIServerErrorCode;

@interface GDIServer : NSObject <NSNetServiceDelegate> {
}

@property(assign) id<GDIServerDelegate> delegate;

// set internally after successfully publishing a Bonjour service
@property(nonatomic, strong, readonly) NSString *name;

- (BOOL)start:(NSError **)error;
- (BOOL)stop;
- (BOOL)enableBonjourWithDomain:(NSString*)domain applicationProtocol:(NSString*)protocol name:(NSString*)name; //Pass "nil" for the default local domain - Pass only the application protocol for "protocol" e.g. "myApp"
- (void)disableBonjour;

- (id)initWithDelegate:(NSObject <GDIServerDelegate> *)delegate;

+ (NSString*) bonjourTypeFromIdentifier:(NSString*)identifier;

@end


@protocol GDIServerDelegate <NSObject>
@optional
- (void)serverDidEnableBonjour:(GDIServer*)server withName:(NSString*)name;
- (void)server:(GDIServer*)server didNotEnableBonjour:(NSDictionary *)errorDict;
- (void)didAcceptConnectionForServer:(GDIServer*)server inputStream:(NSInputStream *)istr outputStream:(NSOutputStream *)ostr;
@end
