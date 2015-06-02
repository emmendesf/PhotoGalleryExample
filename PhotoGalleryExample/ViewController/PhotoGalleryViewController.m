//
//  PhotoGalleryViewController.m
//  PhotoGalleryExample
//
//  Created by Emerson Mendes Filho on 02/06/15.
//  Copyright (c) 2015 Emerson Mendes Filho. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import <SDWebImage/SDWebImageManager.h>
#import "MidiaModel.h"

@interface PhotoGalleryViewController()<RMGalleryViewDataSource, RMGalleryViewDelegate>

@end

@implementation PhotoGalleryViewController

#pragma mark RMGalleryViewDataSource

- (void)galleryView:(RMGalleryView*)galleryView imageForIndex:(NSUInteger)index completion:(void (^)(UIImage *))completionBlock {
    
    MidiaModel *model = [self.list objectAtIndex:index];

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:model.urlMidiaFull] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        completionBlock(image);
    }];
}

- (NSUInteger)numberOfImagesInGalleryView:(RMGalleryView*)galleryView {
    return [self.list count];
}

#pragma mark RMGalleryViewDelegate

- (void)galleryView:(RMGalleryView*)galleryView didChangeIndex:(NSUInteger)index {
    [self setTitleForIndex:index];
}

#pragma mark Toolbar

- (void)barButtonAction:(UIBarButtonItem*)barButtonItem {
    
    RMGalleryView *galleryView = self.galleryView;
    const NSUInteger index = galleryView.galleryIndex;
    RMGalleryCell *galleryCell = [galleryView galleryCellAtIndex:index];
    UIImage *image = galleryCell.image;
    if (!image) return;
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

#pragma mark Utils

- (void)setTitleForIndex:(NSUInteger)index {
    
    const NSUInteger count = [self numberOfImagesInGalleryView:self.galleryView];
    self.title = [NSString stringWithFormat:@"%ld of %ld", (long)index + 1, (long)count];
}

#pragma mark - InteractiveTransitionViewControllerDelegate methods

- (void)proceedToNextViewController {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - view lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Set the gallery data source and delegate. Only the data source is required.
    self.galleryView.galleryDataSource = self;
    self.galleryView.galleryDelegate = self;
    
    // Configure the toolbar to show an action bar button item. RMGalleryViewController does not provide any bar buttons but is designed to support a navigation bar and a toolbar.
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(barButtonAction:)];
    self.toolbarItems = @[barButton];
    
    // Set the view controller title. Note that the gallery index does not necessarilly have to be zero at this point.
    [self setTitleForIndex:self.galleryIndex];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidAppear:(BOOL)animated {
    
    // Add the gesture recogniser to the window first render time
    if (![self.view.window.gestureRecognizers containsObject:self.animationInteractor.gestureRecognizer]) {
        [self.view.window addGestureRecognizer:self.animationInteractor.gestureRecognizer];
    }
    // Reset which view controller should be the receipient of the
    // interactor's transition
    self.animationInteractor.presentingVC = self;
}

@end
