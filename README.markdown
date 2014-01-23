# FGallery - A Photo Gallery for iOS
## Overview
FGallery is a photo gallery viewer developed for iPhone applications. FGallery implements a delegate style design pattern similar to how UITableViewDelegates work. You may load images from either the local application bundle, or from the network.

## Features
* Single-tap fullscreen mode
* Double-tap image zooming
* Pinch zooming
* Captions
* Thumbnail grid
* Rotation support
* Load images locally or from a web URL
* Custom UITabBarItems

## Usage
### Basic Instantiation
FGallery requires an object to implement the FGalleryViewControllerDelegate protocol in order to act as the photo source for the gallery. Then just push it into the navigation controller stack as you would with any UIViewController.

	FGalleryViewController *galleryVC = [[FGalleryViewController alloc] initWithPhotoSource:self];
	[self.navigationController pushViewController:galleryVC animated:YES];
	[galleryVC release];
	
### Instantiation with Custom Bar Items
FGallery allows you add additional UIBarButtonItems to the UIToolbar that exists within the gallery to perform additional functionality.

	UIImage *trashIcon = [UIImage imageNamed:@"photo-gallery-trashcan.png"];
	UIImage *captionIcon = [UIImage imageNamed:@"photo-gallery-edit-caption.png"];
	UIBarButtonItem *trashButton = [[[UIBarButtonItem alloc] initWithImage:trashIcon style:UIBarButtonItemStylePlain target:self action:@selector(handleTrashButtonTouch:)] autorelease];
	UIBarButtonItem *editCaptionButton = [[[UIBarButtonItem alloc] initWithImage:captionIcon style:UIBarButtonItemStylePlain target:self action:@selector(handleEditCaptionButtonTouch:)] autorelease];
	NSArray *barItems = [NSArray arrayWithObjects:editCaptionButton, trashButton, nil];

	FGalleryViewController *galleryVC = [[FGalleryViewController alloc] initWithPhotoSource:self barItems:barItems];
	[self.navigationController pushViewController:galleryVC animated:YES];
	[galleryVC release];


## Current Project Status

The 1.x version of FGallery is no longer supported. Since I need to make a living, I've been busy contracting and haven't had time to fully support the 1.x versions. However, I am in the midst of slowly rewriting FGallery for a 2.0 version that will modernize the project and also convert it into a Cocoapod that I do plan on supporting. The new version will also use a UICollectionView to display the thumbnail gallery, will allow for custom layouts, and a few more nice updates. Sorry for being busy and not updating as much as I should, but I never thought this project would get as much attention as it has! Thanks for all the contributions and support for the project! -Grant

## Changes
### 1.3
* Various fixes and merged pull requests.

### 1.2
* Adds new 'startingIndex' property. As you might guess, it allows a developer to specify what the starting index should be for the gallery. This must be set before the view is built in the ViewController. Defaults to 0.
* Adds new 'beginsInThumbnailView' property. Allows the developer to indicate that the view should initialize and show the thumbnail view when first displaying instead of starting on the first image. This must be set before the view is presented. Defaults to 'NO'.
* FGallery classes are now contained in an FGallery group, separate from other code classes that are part of the demo. 


### 1.1
* Added support for translucent navigation bars
* Added support to hide the right navigation button and therefore disable thumbnails through a new useThumbnailView property.
* Added better memory management for building and destroying view objects.
* Fixed a crash in the network images demo.

### 1.0
* First release!

## License
(The MIT License)

Copyright © 2010 Grant Davis Interactive, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
