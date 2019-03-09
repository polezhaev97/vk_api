//
//  Section.m
//  DZ-45
//
//  Created by mbp on 08/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "Section.h"

@implementation Section

- (instancetype)initWithRows:(NSArray *)rows
{
    self = [super init];
    if (self) {
        self.arrayRows = rows;
        
    }
    return self;
}

@end
