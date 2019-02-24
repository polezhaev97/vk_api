//
//  UserProfileViewController.m
//  DZ-45
//
//  Created by mbp on 23/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "UserProfileViewController.h"
#import "NetworkManager.h"

@interface UserProfileViewController ()

@property(strong, nonatomic) UserExtendedInfo* userInfo;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NetworkManager sharedInstance] getUserInfo:self.userId
                                       onSuccess:^(UserExtendedInfo * _Nonnull userInfo) {
                                           
                                           self.userInfo = userInfo;
//                                           [self.tableView reloadData];
        
                                           
    } onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
        //
    }];
    
}

@end
