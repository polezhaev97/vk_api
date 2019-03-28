//
//  VideoModel.m
//  DZ-45
//
//  Created by mbp on 27/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

- (instancetype)initWithDictionary: (NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        self.nameTitle = [dictionary objectForKey:@"title"];
        self.player = [dictionary objectForKey:@"player"];
        NSString* stringURL = [dictionary objectForKey:@"image"];
        self.imageURL = [[NSURL alloc] initWithString:stringURL];
    }
    return self;
}


@end
