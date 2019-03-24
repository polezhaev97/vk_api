//
//  NewsFeedItem.h
//  DZ-45
//
//  Created by mbp on 11/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsFeedItem : NSObject

@property(strong,nonatomic) NSString* text;
@property(strong,nonatomic) NSNumber* comments;
@property(strong,nonatomic) NSNumber* like;
@property(strong,nonatomic) NSDate* postDate;

- (instancetype)initWithDictionary: (NSDictionary*) dictionary;

@end

NS_ASSUME_NONNULL_END
