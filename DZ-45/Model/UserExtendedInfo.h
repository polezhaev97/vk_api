//
//  UserExtendedInfo.h
//  DZ-45
//
//  Created by mbp on 24/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserExtendedInfo : NSObject

@property(strong, nonatomic) NSString* name;
@property(strong, nonatomic) NSString* surname;
@property(strong, nonatomic) NSString* cityName;
@property(strong, nonatomic) NSString*  gender;
@property(strong, nonatomic) NSString* universityName;
@property(assign, nonatomic) BOOL isOnline;
@property(strong, nonatomic) NSURL * bigPhoto;

- (instancetype)initWith:(NSDictionary*) dictionary;

@end

