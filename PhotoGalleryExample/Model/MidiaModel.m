//
//  MidiaModel.m
//  PhotoGalleryExample
//
//  Created by Emerson Mendes Filho on 01/06/15.
//  Copyright (c) 2015 Emerson Mendes Filho. All rights reserved.
//

#import "MidiaModel.h"

@implementation MidiaModel

+ (MidiaModel *) parseMidiaWithJSON:(NSDictionary *)json {
    
    MidiaModel *model = [MidiaModel new];
    
    model.idMidia = [json objectForKey:@"idMidia"];
    model.idAlbum = [json objectForKey:@"idAlbum"];
    model.urlThumbMidia = [json objectForKey:@"urlThumbMidia"];
    model.urlMidiaFull = [json objectForKey:@"urlMidiaFull"];
    
    return model;
}

+ (NSArray *) parseListOfMidiasWithArray:(NSArray *)array {
    
    NSMutableArray *photoList = [NSMutableArray new];
    
    for ( NSDictionary *dict in array ) {
        [photoList addObject:[self parseMidiaWithJSON:dict]];
    }
    
    return photoList;
}

@end
