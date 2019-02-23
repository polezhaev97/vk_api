//
//  NetworkManager.m
//  DZ-45
//
//  Created by mbp on 23/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"

@interface NetworkManager ()

@property (strong, nonatomic) AFHTTPSessionManager* requestOperationManager;

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
     @"a7431503c25bf34087429a4d493a0ca25c572b80c4fdbad25b11200af87138c41ce89491fda276130fe43", @"access_token",
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

@end
