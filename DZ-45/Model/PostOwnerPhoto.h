//
//  PostOwnerPhoto.h
//  DZ-45
//
//  Created by mbp on 24/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostOwnerPhoto : NSObject

@property(strong, nonatomic) NSString* hashValue;
@property(strong, nonatomic) NSNumber* serverValue;
@property(strong, nonatomic) NSString* photoValue;

- (instancetype)initWith:(NSDictionary*) dictionary;

@end

NS_ASSUME_NONNULL_END
