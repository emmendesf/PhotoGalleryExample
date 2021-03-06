/*
 Copyright 2013 Scott Logic Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */


#import "FlipAnimationInteractor.h"

@interface FlipAnimationInteractor ()

@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic, assign, readwrite) BOOL interactionInProgress;

@end


@implementation FlipAnimationInteractor

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    }
    return self;
}

#pragma mark - Gesture recognition
- (void)handlePan:(UIPanGestureRecognizer *)pgr
{
    CGPoint translation = [pgr translationInView:pgr.view];
    CGFloat percentage  = fabs(translation.y / CGRectGetHeight(pgr.view.bounds));
    switch (pgr.state) {
        case UIGestureRecognizerStateBegan:
            self.interactionInProgress = YES;
            [self.presentingVC proceedToNextViewController];
            break;
            
        case UIGestureRecognizerStateChanged: {
            [self updateInteractiveTransition:percentage];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
            
            [self finishInteractiveTransition];
            self.interactionInProgress = NO;
            break;
            
        case UIGestureRecognizerStateCancelled:
            
            [self finishInteractiveTransition];
            self.interactionInProgress = NO;
            
        default:
            break;
    }
}

@end
