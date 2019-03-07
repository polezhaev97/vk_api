//
//  ShortProfile.m
//  DZ-45
//
//  Created by mbp on 06/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "ShortProfile.h"

@implementation ShortProfile

- (instancetype)initWithDictionary: (NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:@"first_name"];
        self.surname = [dictionary objectForKey:@"last_name"];
        self.userID = [dictionary objectForKey:@"uid"];
        
        
        NSString* stringURL = [dictionary objectForKey:@"photo"];
        self.imageURL = [[NSURL alloc] initWithString:stringURL];
        
    }
    return self;
}
@end
