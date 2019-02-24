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
@end
