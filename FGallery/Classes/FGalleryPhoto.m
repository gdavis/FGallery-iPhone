//
//  FGalleryPhoto.m
//  FGallery
//
//  Created by Grant Davis on 5/20/10.
//  Copyright 2011 Grant Davis Interactive, LLC. All rights reserved.
//

#import "FGalleryPhoto.h"
#import "UIImageView+AFNetworking.h"

@interface FGalleryPhoto (Private)

// delegate notifying methods
- (void)willLoadThumbFromUrl;
- (void)willLoadFullsizeFromUrl;
- (void)willLoadThumbFromPath;
- (void)willLoadFullsizeFromPath;
- (void)didLoadThumbnail;
- (void)didLoadFullsize;

// loading local images with threading
- (void)loadFullsizeInThread;
- (void)loadThumbnailInThread;

// cleanup
- (void)killThumbnailLoadObjects;
- (void)killFullsizeLoadObjects;
@end


@implementation FGalleryPhoto
@synthesize tag;
@synthesize thumbnail = _thumbnail;
@synthesize fullsize = _fullsize;
@synthesize delegate = _delegate;
@synthesize isFullsizeLoading = _isFullsizeLoading;
@synthesize hasFullsizeLoaded = _hasFullsizeLoaded;
@synthesize isThumbLoading = _isThumbLoading;
@synthesize hasThumbLoaded = _hasThumbLoaded;


- (id)initWithThumbnailUrl:(NSString*)thumb fullsizeUrl:(NSString*)fullsize delegate:(NSObject<FGalleryPhotoDelegate>*)delegate
{
	self = [super init];
	_useNetwork = YES;
	_thumbUrl = thumb;
	_fullsizeUrl = fullsize;
	_delegate = delegate;
	return self;
}

- (id)initWithThumbnailPath:(NSString*)thumb fullsizePath:(NSString*)fullsize delegate:(NSObject<FGalleryPhotoDelegate>*)delegate
{
	self = [super init];
	
	_useNetwork = NO;
	_thumbUrl = thumb;
	_fullsizeUrl = fullsize;
	_delegate = delegate;
	return self;
}


- (void)loadThumbnail
{
	if( _isThumbLoading || _hasThumbLoaded ) return;
	
	// load from network
	if( _useNetwork )
	{
		// notify delegate
		[self willLoadThumbFromUrl];
		
		_isThumbLoading = YES;
		
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_thumbUrl]];
        UIImageView *tempImage = [[UIImageView alloc] init];
        
        [tempImage setImageWithURLRequest:request
                         placeholderImage:[UIImage imageNamed:@"resim.png"]
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                      
                                      _isThumbLoading = NO;
                                      _hasThumbLoaded = YES;
                                      
                                      // create new image with data
                                      _thumbnail = image;
                                      
                                      
                                      // notify delegate
                                      if( _delegate )
                                          [self didLoadThumbnail];
                                  }
                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                      
                                  }];
	}
	
	// load from disk
	else {
		
		// notify delegate
		[self willLoadThumbFromPath];
		
		_isThumbLoading = YES;
		
		// spawn a new thread to load from disk
		[NSThread detachNewThreadSelector:@selector(loadThumbnailInThread) toTarget:self withObject:nil];
	}
}


- (void)loadFullsize
{
	if( _isFullsizeLoading || _hasFullsizeLoaded ) return;
	
	if( _useNetwork )
	{
		// notify delegate
		[self willLoadFullsizeFromUrl];
		
		_isFullsizeLoading = YES;
		
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_thumbUrl]];
        
        UIImageView *tempImage = [[UIImageView alloc] init];
        
        [tempImage setImageWithURLRequest:request
                         placeholderImage:[UIImage imageNamed:@"resim.png"]
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                      
                                      _isThumbLoading = NO;
                                      _hasThumbLoaded = YES;
                                      
                                      // create new image with data
                                      _thumbnail = image;
                                      
                                      
                                      // notify delegate
                                      if( _delegate )
                                          [self didLoadThumbnail];
                                  }
                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                      
                                  }];
	
	}
	else
	{
		[self willLoadFullsizeFromPath];
		
		_isFullsizeLoading = YES;
		
		// spawn a new thread to load from disk
		[NSThread detachNewThreadSelector:@selector(loadFullsizeInThread) toTarget:self withObject:nil];
	}
}


- (void)loadFullsizeInThread
{
	@autoreleasepool {
	
		NSString *path;
        
        if([[NSFileManager defaultManager] fileExistsAtPath:_fullsizeUrl])
        {
            path = _fullsizeUrl;
        }
        else {
            path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], _fullsizeUrl];
        }
				
		_fullsize = [UIImage imageWithContentsOfFile:path];
		
		_hasFullsizeLoaded = YES;
		_isFullsizeLoading = NO;

		[self performSelectorOnMainThread:@selector(didLoadFullsize) withObject:nil waitUntilDone:YES];
	
	}
}


- (void)loadThumbnailInThread
{
	@autoreleasepool {
	
		NSString *path;
        
        if([[NSFileManager defaultManager] fileExistsAtPath:_thumbUrl])
        {
            path = _thumbUrl;
        }
        else {
            path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], _thumbUrl];
        }
			
		_thumbnail = [UIImage imageWithContentsOfFile:path];
		
		_hasThumbLoaded = YES;
		_isThumbLoading = NO;
		
		[self performSelectorOnMainThread:@selector(didLoadThumbnail) withObject:nil waitUntilDone:YES];
	
	}
}


- (void)unloadFullsize
{
	[_fullsizeConnection cancel];
	[self killFullsizeLoadObjects];
	
	_isFullsizeLoading = NO;
	_hasFullsizeLoaded = NO;
	
	_fullsize = nil;
}

- (void)unloadThumbnail
{
	[_thumbConnection cancel];
	[self killThumbnailLoadObjects];
	
	_isThumbLoading = NO;
	_hasThumbLoaded = NO;
	
	_thumbnail = nil;
}

#pragma mark -
#pragma mark Delegate Notification Methods


- (void)willLoadThumbFromUrl
{
	if([_delegate respondsToSelector:@selector(galleryPhoto:willLoadThumbnailFromUrl:)])
		[_delegate galleryPhoto:self willLoadThumbnailFromUrl:_thumbUrl];
}


- (void)willLoadFullsizeFromUrl
{
	if([_delegate respondsToSelector:@selector(galleryPhoto:willLoadFullsizeFromUrl:)])
		[_delegate galleryPhoto:self willLoadFullsizeFromUrl:_fullsizeUrl];
}


- (void)willLoadThumbFromPath
{
	if([_delegate respondsToSelector:@selector(galleryPhoto:willLoadThumbnailFromPath:)])
		[_delegate galleryPhoto:self willLoadThumbnailFromPath:_thumbUrl];
}


- (void)willLoadFullsizeFromPath
{
	if([_delegate respondsToSelector:@selector(galleryPhoto:willLoadFullsizeFromPath:)])
		[_delegate galleryPhoto:self willLoadFullsizeFromPath:_fullsizeUrl];
}


- (void)didLoadThumbnail
{
//	FLog(@"gallery phooto did load thumbnail!");
	if([_delegate respondsToSelector:@selector(galleryPhoto:didLoadThumbnail:)])
		[_delegate galleryPhoto:self didLoadThumbnail:_thumbnail];
}


- (void)didLoadFullsize
{
//	FLog(@"gallery phooto did load fullsize!");
	if([_delegate respondsToSelector:@selector(galleryPhoto:didLoadFullsize:)])
		[_delegate galleryPhoto:self didLoadFullsize:_fullsize];
}


#pragma mark -
#pragma mark Memory Management


- (void)killThumbnailLoadObjects
{
	
	_thumbConnection = nil;
	_thumbData = nil;
}



- (void)killFullsizeLoadObjects
{
	
	_fullsizeConnection = nil;
	_fullsizeData = nil;
}



- (void)dealloc
{
//	NSLog(@"FGalleryPhoto dealloc");
	
//	[_delegate release];
	_delegate = nil;
	
	[_fullsizeConnection cancel];
	[_thumbConnection cancel];
	[self killFullsizeLoadObjects];
	[self killThumbnailLoadObjects];
	
	_thumbUrl = nil;
	
	_fullsizeUrl = nil;
	
	
	
}


@end
