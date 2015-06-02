//
//  PhotoCollectionViewCell.m
//  PhotoGalleryExample
//
//  Created by Emerson Mendes Filho on 02/06/15.
//  Copyright (c) 2015 Emerson Mendes Filho. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        NSString *cellNibName = @"PhotoCollectionViewCellLayout";
        NSArray *resultantNibs = [[NSBundle mainBundle] loadNibNamed:cellNibName owner:nil options:nil];
        
        if ([resultantNibs count] < 1) {
            return nil;
        }
        
        if (![[resultantNibs objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        self = [resultantNibs objectAtIndex:0];
    }
    
    return self;    
}

@end
