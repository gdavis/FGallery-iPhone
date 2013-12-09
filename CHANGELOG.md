# GDIImageGallery CHANGELOG

## 2.0
* iOS7 Support
* Cocoapod support
* Major project restructuring (for cocoapds)

In Development:
* Rebuild thumbnail view with UICollectionView
* Add support for thumbnail view subclasses to customize the UICollectionView

## 1.3
* Various fixes and merged pull requests.

## 1.2
* Adds new 'startingIndex' property. As you might guess, it allows a developer to specify what the starting index should be for the gallery. This must be set before the view is built in the ViewController. Defaults to 0.
* Adds new 'beginsInThumbnailView' property. Allows the developer to indicate that the view should initialize and show the thumbnail view when first displaying instead of starting on the first image. This must be set before the view is presented. Defaults to 'NO'.
* FGallery classes are now contained in an FGallery group, separate from other code classes that are part of the demo. 


## 1.1
* Added support for translucent navigation bars
* Added support to hide the right navigation button and therefore disable thumbnails through a new useThumbnailView property.
* Added better memory management for building and destroying view objects.
* Fixed a crash in the network images demo.

## 1.0
* First release!