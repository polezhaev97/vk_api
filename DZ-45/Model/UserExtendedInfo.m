//
//  UserExtendedInfo.m
//  DZ-45
//
//  Created by mbp on 24/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "UserExtendedInfo.h"

@implementation UserExtendedInfo

- (instancetype)initWith:(NSDictionary*) dictionary
{
    self = [super init];
    if (self) {
        self.name = [dictionary objectForKey:@"first_name"];
        self.surname = [dictionary objectForKey:@"last_name"];
        self.cityName =@"spb";
        //[dictionary objectForKey:@"city"];
        NSInteger data =[[dictionary objectForKey:@"sex"] integerValue];
        self.gender = [self getGender:data];
        self.universityName = [dictionary objectForKey:@"university_name"];
        self.isOnline = [[dictionary objectForKey:@"online"] integerValue];
        NSString* stringURL = [dictionary objectForKey: @"photo_400_orig"];
        self.bigPhoto = [[NSURL alloc] initWithString:stringURL];
    }
    return self;
}


-(NSString*) getGender: (NSInteger) data {
    if (data == 1) {
        return @"woman";
    }else if (data == 2){
        return @"man";
    }
    
    
    return @"";
}


@end
