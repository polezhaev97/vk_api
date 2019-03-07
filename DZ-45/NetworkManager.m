//
//  NetworkManager.m
//  DZ-45
//
//  Created by mbp on 23/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"
#import "AccessToken.h"

@interface NetworkManager ()

@property (strong, nonatomic) AFHTTPSessionManager* requestOperationManager;
@property (strong, nonatomic) AccessToken* accessToken;

@end

@implementation NetworkManager

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.requestOperationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

-(void) authorizeUser: (void(^)(BOOL isSuccess)) completion{
    
    LoginViewController* vc = [[LoginViewController alloc] initWithCompletionBlock:^(AccessToken* token){
        self.accessToken = token;
        completion(token !=nil);
    }];
    
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:vc];
    UIViewController* mainVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    [mainVC presentViewController: navController
                         animated:YES
                       completion:nil];
}

- (void) getFriendsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"92246877",   @"user_id",
     @"name",       @"order",
     @(count),      @"count",
     @(offset),     @"offset",
     @"photo_50",   @"fields",
     self.accessToken.token, @"access_token",
     @"nom",        @"name_case",
     @"5.92", @"version",
     nil];
    
    [self.requestOperationManager GET:@"friends.get"
                           parameters:params
                             progress:^(NSProgress * _Nonnull downloadProgress) {
                                 //
                             }
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                
                                  NSMutableArray* usersArray = [[NSMutableArray alloc] init];
                                  NSArray* jsonUsers = [responseObject objectForKey:@"response"];
                                  for (NSDictionary* dictionary in jsonUsers) {
                                      User* user = [[User alloc] initWithDictionary:dictionary];
                                      [usersArray addObject:user];
                                  }
                                    NSLog(@"JSON %@ ", jsonUsers);
                                  success(usersArray);
                                  
                              }
                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  
                              }];
}

- (void) getUserInfo:(NSString*) userId
                    onSuccess:(void(^)(UserExtendedInfo* userInfo)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSMutableDictionary* params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
      @"5.92", @"version",
     userId,   @"user_ids",
     @"city, photo_400_orig, sex, online, education",       @"fields",
     @"Nom", @"name_case",
    
     nil];
    
    if (self.accessToken ) {
        [params setObject:self.accessToken.token forKey:@"access_token"];
    }
    
    [self.requestOperationManager GET:@"users.get"
                           parameters:params
                             progress:^(NSProgress * _Nonnull downloadProgress) {
                                 //
                             }
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                NSLog(@"JSON %@ ", responseObject);
                                  
                                  NSDictionary* jsonUser = [[responseObject objectForKey:@"response"] firstObject];
                                 
                                  UserExtendedInfo* info = [[UserExtendedInfo alloc] initWith:jsonUser];
                               
                                  success(info);
                                  
                              }
                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  
                              }];
    
}

-(void) getGroupWall:(NSString*) groupID
          withOffset:(NSInteger) offset
               count:(NSInteger) count
           onSuccess:(void(^)(WallData* data)) success
           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     groupID,   @"owner_id",
     @(count),      @"count",
     @(offset),     @"offset",
     self.accessToken.token, @"access_token",
     
    @"1",@"extended",
     @"crop_photo",@"fields",
     
     @"all",        @"filter",
     @"5.92", @"version",
     nil];
    
    [self.requestOperationManager GET:@"wall.get"
                           parameters:params
                             progress:^(NSProgress * _Nonnull downloadProgress) {
                                 //
                             }
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  
                                  NSDictionary* data = [responseObject objectForKey:@"response"];
                                     NSLog(@"JSON %@ ", data);
                                  
                                  WallData* wallData = [[WallData alloc] init];
                                  
                                  NSArray* wall = [data objectForKey:@"wall"];
                                  NSArray* profiles = [data objectForKey:@"profiles"];

                                  if ([wall count] > 1) {
                                      wall = [wall subarrayWithRange:NSMakeRange(1, (int)[wall count] - 1)];
                                  } else {
                                      wall = nil;
                                  }

                                  NSMutableArray* postsArray = [[NSMutableArray alloc] init];
                                  
                                  for (NSDictionary* dictionary in wall) {
                                      Post* posts = [[Post alloc] initWithDictionary:dictionary];
                                      [postsArray addObject:posts];
                                  }
                                  
                                  wallData.posts = postsArray;
                                  
                                  
                                  
                                  NSMutableDictionary* profilesDict = [[NSMutableDictionary alloc] init];

                                  for (NSDictionary* dictionary in profiles) {
                                      ShortProfile* profile = [[ShortProfile alloc] initWithDictionary:dictionary];
                                      [profilesDict setObject:profile forKey:profile.userID];
                                  }
                                   wallData.profiles = profilesDict;
                                  
                                  
                                  
                                  
                                  
                                  success(wallData);
                                  
                              }
                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  
                              }];

    
}


-(void) getCommentsWall:(NSString*) groupID
          withOffset:(NSNumber*) postID
           onSuccess:(void(^)(NSArray* posts)) success
           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     groupID,   @"owner_id",
     postID,        @"post_id",
     self.accessToken.token, @"access_token",
     @"5.92", @"version",
     nil];
    
    [self.requestOperationManager GET:@"wall.getComments"
                           parameters:params
                             progress:^(NSProgress * _Nonnull downloadProgress) {
                                 //
                             }
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    NSLog(@"JSON %@ ", responseObject);
                                  NSArray* jsonPost = [responseObject objectForKey:@"response"];
                                  
                                  if ([jsonPost count] > 1) {
                                      jsonPost = [jsonPost subarrayWithRange:NSMakeRange(1, (int)[jsonPost count] - 1)];
                                  } else {
                                      jsonPost = nil;
                                  }
                                  
                                  
                                  NSMutableArray* usersArray = [[NSMutableArray alloc] init];
                                  
                                  for (NSDictionary* dictionary in jsonPost) {
                                      PostComments* posts = [[PostComments alloc] initWithDictionary:dictionary];
                                      [usersArray addObject:posts];
                                  }
                                
                                  success(usersArray);
                                  
                              }
                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  
                              }];
    
    
}

@end
