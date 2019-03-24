//
//  Post.m
//  DZ-45
//
//  Created by mbp on 05/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "Post.h"

@implementation Post

- (instancetype)initWithDictionary: (NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        self.text = [dictionary objectForKey:@"text"];
        self.postID=[dictionary objectForKey:@"id"];
        self.fromID = [dictionary objectForKey:@"from_id"];
        
         NSNumber* date =[dictionary objectForKey:@"date"];
        self.postDate= [NSDate dateWithTimeIntervalSince1970: [date doubleValue]];
        self.countLike = [dictionary valueForKeyPath:@"likes.count"];
        self.countComment = [dictionary valueForKeyPath:@"comments.count"];

        
        
    }
    return self;
}

@end
