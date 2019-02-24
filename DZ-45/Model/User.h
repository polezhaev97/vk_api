//
//  User.h
//  DZ-45
//
//  Created by mbp on 23/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* surname;
@property (strong, nonatomic) NSURL* imageURL;
@property(strong,nonatomic) NSString* userID;

- (instancetype)initWithDictionary: (NSDictionary*) dictionary;

@end

NS_ASSUME_NONNULL_END
