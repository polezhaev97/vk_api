//
//  VideoModel.h
//  DZ-45
//
//  Created by mbp on 27/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoModel : NSObject

@property(strong, nonatomic) NSString* nameTitle;
@property(strong, nonatomic) NSString* player;
@property(strong, nonatomic) NSURL* imageURL;


- (instancetype)initWithDictionary: (NSDictionary*) dictionary;


@end

NS_ASSUME_NONNULL_END
