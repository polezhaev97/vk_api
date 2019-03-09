//
//  Section.h
//  DZ-45
//
//  Created by mbp on 08/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Section : NSObject

@property(strong, nonatomic) NSArray* arrayRows;

- (instancetype)initWithRows:(NSArray *)rows;

@end

typedef enum {
    
    myProfile,
    friends,
    group

}menuRows;

NS_ASSUME_NONNULL_END
