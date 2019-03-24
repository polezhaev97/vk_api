//
//  PostOwnerPhoto.m
//  DZ-45
//
//  Created by mbp on 24/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "PostOwnerPhoto.h"

@implementation PostOwnerPhoto

- (instancetype)initWith:(NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        self.hashValue = [dictionary objectForKey:@"hash"];
        self.serverValue = [dictionary objectForKey:@"server"];
        self.photoValue = [dictionary objectForKey:@"photo"];


        
    }
    return self;
}

@end
