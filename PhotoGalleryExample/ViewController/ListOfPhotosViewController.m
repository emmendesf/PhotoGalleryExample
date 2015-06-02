//
//  ListOfPhotosViewController.m
//  PhotoGalleryExample
//
//  Created by Emerson Mendes Filho on 02/06/15.
//  Copyright (c) 2015 Emerson Mendes Filho. All rights reserved.
//

#import "ListOfPhotosViewController.h"
#import "RMGalleryTransition.h"
#import "PhotoGalleryViewController.h"
#import "PhotoEngine.h"
#import "MidiaModel.h"
#import "PhotoCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <CHTCollectionViewWaterfallLayout.h>
#import "FlipAnimationInteractor.h"

@interface ListOfPhotosViewController()<UIViewControllerTransitioningDelegate, InteractiveTransitionViewControllerDelegate, RMGalleryTransitionDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) FlipAnimationInteractor *animationInteractor;

@end

@implementation ListOfPhotosViewController

static NSString * const cellIdentifier = @"PhotoCollectionViewCell";

#pragma mark - actions

- (void)presentGalleryWithImageAtIndex:(NSUInteger)index
{
    PhotoGalleryViewController *galleryViewController = [PhotoGalleryViewController new];
    galleryViewController.list = self.list;
    galleryViewController.galleryIndex = index;
    galleryViewController.animationInteractor = self.animationInteractor;
    
    // The gallery is designed to be presented in a navigation controller or on its own.
    UIViewController *viewControllerToPresent;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:galleryViewController];
    navigationController.toolbarHidden = NO;
    navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    navigationController.navigationBar.shadowImage = [UIImage new];
    navigationController.navigationBar.translucent = YES;
    [navigationController.toolbar setTintColor:[UIColor whiteColor]];
    [navigationController.toolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navigationController.toolbar setShadowImage:[UIImage new] forToolbarPosition:UIToolbarPositionAny];
    
    // When using a navigation controller the tap gesture toggles the navigation bar and toolbar. A way to dismiss the gallery must be provided.
    galleryViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissGallery:)];
    
    viewControllerToPresent = navigationController;
    
    // Set the transitioning delegate. This is only necessary if you want to use RMGalleryTransition.
    viewControllerToPresent.transitioningDelegate = self;
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    viewControllerToPresent.transitioningDelegate = self;
    
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

- (void)dismissGallery:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImageView *)getImageViewForIndex:(NSInteger)index {
    
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    return cell.imageView;
}

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.list count];
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MidiaModel *model = [self.list objectAtIndex:indexPath.row];
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.urlThumbMidia] placeholderImage:[UIImage imageNamed:@"placeholder_loader"]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self presentGalleryWithImageAtIndex:indexPath.row];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(60, 60);
}

#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    RMGalleryTransition *transition = [RMGalleryTransition new];
    transition.delegate = self;
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    RMGalleryTransition *transition = [RMGalleryTransition new];
    transition.delegate = self;
    return transition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.animationInteractor.interactionInProgress ? self.animationInteractor : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.animationInteractor.interactionInProgress ? self.animationInteractor : nil;
}

#pragma mark RMGalleryTransitionDelegate

- (UIImageView*)galleryTransition:(RMGalleryTransition*)transition transitionImageViewForIndex:(NSUInteger)index {
    
    return [self getImageViewForIndex:index];
}

- (CGSize)galleryTransition:(RMGalleryTransition*)transition estimatedSizeForIndex:(NSUInteger)index {
    
    // If the transition image is different than the one displayed in the gallery we need to provide its size
    UIImageView *imageView = [self getImageViewForIndex:index];
    const CGSize thumbnailSize = imageView.image.size;
    
    // In this example the final images are about 25 times bigger than the thumbnail
    const CGSize estimatedSize = CGSizeMake(thumbnailSize.width * 25, thumbnailSize.height * 25);
    return estimatedSize;
}

#pragma mark - InteractiveTransitionViewControllerDelegate methods

- (void)proceedToNextViewController {
    
}

#pragma mark - view lifecycle

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.list = [PhotoEngine getPhotos];
    
    CHTCollectionViewWaterfallLayout* layout = (id)[self.collectionView collectionViewLayout];
    layout.sectionInset = UIEdgeInsetsMake(2,2,2,2);
    layout.columnCount = 4;
    layout.minimumColumnSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    
    self.animationInteractor = [FlipAnimationInteractor new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Set the recipeint of the interactor
    self.animationInteractor.presentingVC = self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

@end
