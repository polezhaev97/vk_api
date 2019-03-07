//
//  PostComments.h
//  DZ-45
//
//  Created by mbp on 05/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostComments : NSObject

@property(strong, nonatomic) NSString* text;


- (instancetype)initWithDictionary: (NSDictionary*) dictionary;

@end

NS_ASSUME_NONNULL_END
