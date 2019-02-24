//
//  AccessToken.h
//  DZ-45
//
//  Created by mbp on 24/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccessToken : NSObject

@property(strong, nonatomic) NSString* token;
@property(strong, nonatomic) NSDate* expirationDate;
@property(strong, nonatomic) NSString* userID;
@end

NS_ASSUME_NONNULL_END
