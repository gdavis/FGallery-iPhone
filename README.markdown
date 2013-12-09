# GDIImageGallery - A Photo Gallery for iOS
## Overview
GDIImageGallery is a photo gallery viewer developed for iPhone applications. GDIImageGallery implements a delegate style design pattern similar to how UITableViewDelegates work. You may load images from either the local application bundle, or from the network.

## Features
* Single-tap fullscreen mode
* Double-tap image zooming
* Pinch zooming
* Captions
* Thumbnail grid
* Rotation support
* Load images locally or from a web URL
* Custom UITabBarItems
* ARC Support

## Installation

GDIImageGallery is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "GDIImageGallery"

## Usage

To run the example project; clone the repo, and run `pod install` from the Project directory first.

### Basic Instantiation
GDIImageGallery requires an object to implement the GDIImageGalleryViewControllerDelegate protocol in order to act as the photo source for the gallery. Then just push it into the navigation controller stack as you would with any UIViewController.

	GDIImageGalleryViewController *galleryVC = [[GDIImageGalleryViewController alloc] initWithPhotoSource:self];
	[self.navigationController pushViewController:galleryVC animated:YES];
	
### Instantiation with Custom Bar Items
GDIImageGallery allows you add additional UIBarButtonItems to the UIToolbar that exists within the gallery to perform additional functionality.

	UIImage *trashIcon = [UIImage imageNamed:@"photo-gallery-trashcan.png"];
	UIImage *captionIcon = [UIImage imageNamed:@"photo-gallery-edit-caption.png"];
	UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithImage:trashIcon style:UIBarButtonItemStylePlain target:self action:@selector(handleTrashButtonTouch:)];
	UIBarButtonItem *editCaptionButton = [[UIBarButtonItem alloc] initWithImage:captionIcon style:UIBarButtonItemStylePlain target:self action:@selector(handleEditCaptionButtonTouch:)];
	NSArray *barItems = [NSArray arrayWithObjects:editCaptionButton, trashButton, nil];

	GDIImageGalleryViewController *galleryVC = [[GDIImageGalleryViewController alloc] initWithPhotoSource:self barItems:barItems];
	[self.navigationController pushViewController:galleryVC animated:YES];

## Author

Grant Davis, grant.davis@gmail.com

## License

GDIImageGallery is available under the MIT license. See the LICENSE file for more info.