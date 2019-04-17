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
#import "Post.h"
#import "PostComments.h"
#import "ShortProfile.h"
#import "WallData.h"
#import "NewsViewController.h"
#import "NewsFeedItem.h"
#import "PostOwnerPhoto.h"
#import "VideoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject

@property (strong, nonatomic) AccessToken* accessToken;

+ (instancetype)sharedInstance;

-(NSURLRequest*) getAuthorizeRequest;

-(void) getLogoutRequest;


- (void) getAllFriendsOnSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getUserInfo:(NSString*) userId
           onSuccess:(void(^)(UserExtendedInfo* userInfo)) success
           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

-(void) getGroupWall:(NSString*) groupID
          withOffset:(NSInteger) offset
               count:(NSInteger) count
           onSuccess:(void(^)(WallData* data)) success
           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

-(void) getCommentsWall:(NSString*) groupID
             withOffset:(NSNumber*) postID
              onSuccess:(void(^)(NSArray* posts)) success
              onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

-(void) getSearchWallGroupID:(NSString*) groupID
                   withQuery:(NSString*) querySearch
                   onSuccess:(void(^)(NSArray* posts)) success
                   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getUserNewsFeedOnSuccess:(void(^)(NSArray* news)) success
                        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

-(void) getOwnerPhotoUploadServer:(NSString*) userID
                        onSuccess:(void(^)(NSString* uploadUrl)) success
                        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

-(void) getMyVideoOnSuccess:(void(^)(NSArray* videoArray)) success
                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


-(AccessToken*) getTokenFromResponce:(NSString*) query;

@end

NS_ASSUME_NONNULL_END
