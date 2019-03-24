//
//  Post.h
//  DZ-45
//
//  Created by mbp on 05/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Post : NSObject

@property(strong, nonatomic) NSString* text;
@property(strong,nonatomic) NSNumber* postID;
@property(strong,nonatomic) NSNumber* fromID;
@property (strong, nonatomic) NSDate* postDate;
@property(strong,nonatomic) NSNumber* countLike;
@property(strong,nonatomic) NSNumber* countComment;




//@property(strong, nonatomic) NSURL* avatar;



- (instancetype)initWithDictionary: (NSDictionary*) dictionary;


@end

NS_ASSUME_NONNULL_END
