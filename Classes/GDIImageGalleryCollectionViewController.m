//
//  GDIThumbnailCollectionViewController.m
//  GDIImageGallery
//
//  Created by Grant Davis on 12/9/13.
//  Copyright (c) 2013 Grant Davis Interactive, LLC. All rights reserved.
//
#import "GDIImageGalleryCollectionViewController.h"
#import "GDIImageGalleryViewController.h"

@interface GDIImageGalleryCollectionViewController ()

@end

@implementation GDIImageGalleryCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.thumbnailSize = CGSizeMake(100.f, 100.f);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.borderColor = [UIColor yellowColor].CGColor;
    self.view.layer.borderWidth = 1.f;
    
    self.collectionView.backgroundColor =
    self.view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.5];
    NSLog(@"top layout guide length %.2f", self.topLayoutGuide.length);
    
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:@"thumb"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionView.contentInset = UIEdgeInsetsMake(self.imageGalleryVC.topLayoutGuide.length,
                                                        0,
                                                        self.imageGalleryVC.bottomLayoutGuide.length,
                                                        0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setThumbnailSize:(CGSize)thumbnailSize
{
    _thumbnailSize = thumbnailSize;
    
    if ([self.collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
        flowLayout.itemSize = thumbnailSize;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(imageGalleryCollectionViewController:didSelectIndex:)]) {
        [self.delegate imageGalleryCollectionViewController:self didSelectIndex:indexPath.row];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photoSource numberOfPhotosForPhotoGallery:self.imageGalleryVC];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"thumb"
                                                                           forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    return cell;
}

@end
