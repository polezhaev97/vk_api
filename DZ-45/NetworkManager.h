//
//  NetworkManager.h
//  DZ-45
//
//  Created by mbp on 23/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject


+ (instancetype)sharedInstance;

- (void) getFriendsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end

NS_ASSUME_NONNULL_END
