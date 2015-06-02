//
//  PhotoGalleryViewController.h
//  PhotoGalleryExample
//
//  Created by Emerson Mendes Filho on 02/06/15.
//  Copyright (c) 2015 Emerson Mendes Filho. All rights reserved.
//

#import "RMGalleryViewController.h"
#import "InteractiveTransitionViewControllerDelegate.h"
#import "FlipAnimationInteractor.h"

@interface PhotoGalleryViewController : RMGalleryViewController <InteractiveTransitionViewControllerDelegate>

@property (nonatomic,strong) NSArray *list;
@property (nonatomic, weak) FlipAnimationInteractor *animationInteractor;

@end
