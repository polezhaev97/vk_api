//
//  ShortProfile.h
//  DZ-45
//
//  Created by mbp on 06/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShortProfile : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* surname;
@property (strong, nonatomic) NSURL* imageURL;
@property(strong,nonatomic) NSString* userID;

- (instancetype)initWithDictionary: (NSDictionary*) dictionary;


@end

NS_ASSUME_NONNULL_END
