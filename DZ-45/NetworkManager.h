//
//  NetworkManager.h
//  DZ-45
//
//  Created by mbp on 23/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "LoginViewController.h"
#import "UserExtendedInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject


+ (instancetype)sharedInstance;

- (void) getFriendsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getUserInfo:(NSString*) userId
           onSuccess:(void(^)(UserExtendedInfo* userInfo)) success
           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

-(void) authorizeUser: (void(^)(BOOL isSuccess)) completion;

@end

NS_ASSUME_NONNULL_END
