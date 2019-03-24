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

-(NSURLRequest*) getAuthorizeRequest {
 
    NSString* urlString = [NSString stringWithFormat:@"https://oauth.vk.com/authorize?client_id=6873328&display=mobile&redirect_uri=https://oauth.vk.com/blank.html/&scope=%@&response_type=token&v=5.92&state=123456",  [self getScope]];
    NSURL *nsurl = [NSURL URLWithString:urlString];
     return [NSURLRequest requestWithURL:nsurl];
}

-(NSString*) getScope {
    NSInteger photoScope = 4;
    NSInteger wallScope = 8192;
    NSInteger friendsScope = 2;
    
    NSInteger scope = photoScope + wallScope + friendsScope;
    return [NSString stringWithFormat:@"%ld",scope];;
}

-(AccessToken*) getTokenFromResponce:(NSString*) query {
    
    AccessToken* token = [[AccessToken alloc] init];
    
    NSArray* array = [query componentsSeparatedByString:@"#"];
    
    if ([array count] > 1) {
        query = [array lastObject];
    }
    
    NSArray* pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString* pair in pairs) {
        
        NSArray* values = [pair componentsSeparatedByString:@"="];
        
        if ([values count] == 2) {
            
            NSString* key = [values firstObject];
            
            if ([key isEqualToString:@"access_token"]) {
                token.token = [values lastObject];
            } else if ([key isEqualToString:@"expires_in"]) {
                
                NSTimeInterval interval = [[values lastObject] doubleValue];
                
                token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                
            } else if ([key isEqualToString:@"user_id"]) {
                
                token.userID = [values lastObject];
            }
        }
    }
    
    return token;
}

- (void) getAllFriendsOnSuccess:(void(^)(NSArray* friends)) success
                      onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     @"92246877",   @"user_id",
     @"name",       @"order",
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

-(void) getSearchWallGroupID:(NSString*) groupID
                   withQuery:(NSString*) querySearch
                   onSuccess:(void(^)(NSArray* posts)) success
                   onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     groupID,   @"owner_id",
     querySearch,        @"query",
     self.accessToken.token, @"access_token",
     @"5.92", @"version",
     nil];
    
    [self.requestOperationManager GET:@"wall.search"
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

- (void) getUserNewsFeedOnSuccess:(void(^)(NSArray* news)) success
                        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSMutableDictionary* params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"5.92", @"version",
     @"g30602036", @"source_ids",
     @"post, photo , wall_photo , note",       @"filters",
     @(10), @"count",
     nil];
    
    if (self.accessToken ) {
        [params setObject:self.accessToken.token forKey:@"access_token"];
    }
    
    [self.requestOperationManager GET:@"newsfeed.get"
                           parameters:params
                             progress:^(NSProgress * _Nonnull downloadProgress) {
                                 //
                             }
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  NSLog(@"JSON %@ ", responseObject);
                                  
                                  NSDictionary* json = [responseObject objectForKey:@"response"] ;
                                  
                                  NSArray* items = [json objectForKey:@"items"];
                                  NSMutableArray* result =[[NSMutableArray alloc] init];
                                  
                                  for (NSDictionary* item  in items) {
                                      NewsFeedItem* feed = [[NewsFeedItem alloc] initWithDictionary:item];
                                      [result addObject:feed];
                                  }
                                  
                                  
                                  success(result);
                                  
                              }
                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  
                              }];
    
}


-(void) getOwnerPhotoUploadServer:(NSString*) userID
                        onSuccess:(void(^)(NSString* uploadUrl)) success
                        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,   @"owner_id",
     self.accessToken.token, @"access_token",
     @"5.92", @"version",
     nil];
    
    [self.requestOperationManager GET:@"photos.getOwnerPhotoUploadServer"
                           parameters:params
                             progress:^(NSProgress * _Nonnull downloadProgress) {
                                 //
                             }
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  NSLog(@"JSON %@ ", responseObject);
                                  NSDictionary* data = [responseObject objectForKey:@"response"];
                                  
                                  
                                  NSString*result   = [data objectForKey:@"upload_url"];
                                  NSLog(@"%@", result);
                                        [self uploadPhoto:[UIImage imageNamed:@"yana"] forPath:result];
                              }
                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  
                              }];
    
    
}

-(void) postSaveOwnerPhoto:(PostOwnerPhoto*) data
                        onSuccess:(void(^)(NSString* uploadUrl)) success
                        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure{
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     data.photoValue,   @"photo",
     data.serverValue,   @"server",
     data.hashValue,   @"hash",
     self.accessToken.token, @"access_token",
     @"5.92", @"version",
     nil];
    
    //https://pu.vk.com/c855024/upload.php?_query=eyJhY3QiOiJvd25lcl9waG90byIsInNhdmUiOjEsImFwaV93cmFwIjp7InNlcnZlciI6OTk5LCJwaG90byI6IntyZXN1bHR9IiwibWlkIjo5MjI0Njg3NywiaGFzaCI6Ijc0NDhmOTNmNDA1ZGZkNWM0NDRmNWQ0YWFiYjg0OTQyIiwibWVzc2FnZV9jb2RlIjoyLCJwcm9maWxlX2FpZCI6LTZ9LCJvaWQiOjkyMjQ2ODc3LCJtaWQiOjkyMjQ2ODc3LCJzZXJ2ZXIiOjg1NTAyNCwiX29yaWdpbiI6Imh0dHBzOlwvXC9hcGkudmsuY29tIiwiX3NpZyI6ImVkNmY5ZmM2NjA2ZmZkNmI1ZTAyOGFiOWY4MmNlNzEyIn0
    
    [self.requestOperationManager POST:@"photos.saveOwnerPhoto"
                           parameters:params
                             progress:^(NSProgress * _Nonnull downloadProgress) {
                                 //
                             }
                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                  NSLog(@"JSON %@ ", responseObject);
                                  NSArray* data = [responseObject objectForKey:@"response"];
                                  
                                  
                                  NSString*result   = [[data firstObject] objectForKey:@"upload_url"];
                                  NSLog(@"%@", result);
                                  
                     
                                  
                                  
                              }
                              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                  
                              }];
    
    
}

-(void) uploadPhoto:(UIImage*) profileImage forPath:(NSString*) uploadURL {
    
//    NSString* string = [NSString stringWithFormat:@"%@/%@", uploadURL, @"photo"];
    
    NSURL* url = [NSURL URLWithString:uploadURL];

    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    NSData *postData = UIImageJPEGRepresentation(profileImage, 1.0);
    [urlRequest setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200)
        {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            NSLog(@"The response is - %@",responseDictionary);
            PostOwnerPhoto* data = [[PostOwnerPhoto alloc] initWith:responseDictionary];
            [self postSaveOwnerPhoto:data onSuccess:^(NSString *uploadUrl) {
                //
            } onFailure:^(NSError *error, NSInteger statusCode) {
                //
            }];
         
        }
        else
        {
            NSLog(@"Error");
        }
    }];
    [dataTask resume];
}


@end
