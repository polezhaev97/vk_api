//
//  User.m
//  DZ-45
//
//  Created by mbp on 23/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary: (NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:@"first_name"];
        self.surname = [dictionary objectForKey:@"last_name"];
        self.userID = [dictionary objectForKey:@"user_id"];
        
        
      NSString* stringURL = [dictionary objectForKey:@"photo_50"];
        self.imageURL = [[NSURL alloc] initWithString:stringURL];

    }
    return self;
}

@end
