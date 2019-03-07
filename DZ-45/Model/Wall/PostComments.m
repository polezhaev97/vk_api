//
//  PostComments.m
//  DZ-45
//
//  Created by mbp on 05/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "PostComments.h"

@implementation PostComments


- (instancetype)initWithDictionary: (NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        self.text = [dictionary objectForKey:@"text"];
        
    }
    return self;
}

@end
