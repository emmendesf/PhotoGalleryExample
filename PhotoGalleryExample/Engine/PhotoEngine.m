//
//  PhotoEngine.m
//  PhotoGalleryExample
//
//  Created by Emerson Mendes Filho on 02/06/15.
//  Copyright (c) 2015 Emerson Mendes Filho. All rights reserved.
//

#import "PhotoEngine.h"
#import "MidiaModel.h"

@implementation PhotoEngine

+ (NSArray *) getPhotos {
    
    NSError *err = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"PhotosAlbum1" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
    
    if (err) {
        NSLog(@"ERROR: %@",err.localizedDescription);
    }
    
    NSArray *array = [PhotoEngine randomizeAndIncreaseItens:[MidiaModel parseListOfMidiasWithArray:[json objectForKey:@"albumPhotos"]]];
    return array;
}

+ (NSArray *) randomizeAndIncreaseItens:(NSArray *)array {
    
    NSMutableArray *mutableArray = [NSMutableArray new];
    [mutableArray addObjectsFromArray:array];
    [mutableArray addObjectsFromArray:array];
    [mutableArray addObjectsFromArray:array];
    [mutableArray addObjectsFromArray:array];
    [mutableArray addObjectsFromArray:array];
    
    NSUInteger count = [mutableArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSUInteger nElements = count - i;
        NSUInteger n = (arc4random() % nElements) + i;
        [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    return mutableArray;
}

@end
