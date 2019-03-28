//
//  NewsFeedItem.m
//  DZ-45
//
//  Created by mbp on 11/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "NewsFeedItem.h"

@implementation NewsFeedItem

- (instancetype)initWithDictionary: (NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        self.text = [dictionary objectForKey:@"text"];
        self.name = [dictionary objectForKey:@"text"];
        self.comments = [dictionary valueForKeyPath:@"comments.count"];
        self.like = [dictionary valueForKeyPath:@"likes.count"];
        NSNumber* date =[dictionary objectForKey:@"date"];
        self.postDate= [NSDate dateWithTimeIntervalSince1970: [date doubleValue]];
        
    }
    return self;
}


@end
