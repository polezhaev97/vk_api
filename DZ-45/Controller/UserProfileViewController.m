//
//  UserProfileViewController.m
//  DZ-45
//
//  Created by mbp on 23/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "UserProfileViewController.h"
#import "NetworkManager.h"
#import "UIKit+AFNetworking.h"

#import "NavigationController.h"

typedef enum {
    
    nameAndSurname =1,
    sex,
    city,
    education,
    online
    
} userProfilInfoType;

@interface UserProfileViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) UserExtendedInfo* userInfo;
@property(strong, nonatomic) UITableView* tableView;
@property(strong, nonatomic) NSMutableArray* userDataArray;


//https://pp.userapi.com/c623425/v623425656/51c62/pQ9k2Ic4fCQ.jpg

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"hamburger"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:(NavigationController *)self.navigationController
                                                                                action:@selector(showMenu)];
    }
    
    
    
 
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.width)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.view.backgroundColor = [UIColor whiteColor];

    
self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+imageView.frame.size.height,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height - imageView.frame.size.height-44)
                                              style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = [UIColor redColor];
    
    [self.tableView registerClass:UITableViewCell.self forCellReuseIdentifier:@"Cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [[NetworkManager sharedInstance] getUserInfo:self.userId
                                       onSuccess:^(UserExtendedInfo * _Nonnull userInfo) {
                                           
                                           self.userInfo = userInfo;
                                            self.userDataArray = [NSMutableArray arrayWithArray:@[@(nameAndSurname), @(sex), @(city), @(education), @(online)]];
                                           if (self.userInfo.bigPhoto != nil) {
                                               [imageView setImageWithURL:self.userInfo.bigPhoto];
                                           }
                                           
                                           [self.tableView reloadData];
        
                                           
    } onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
        //
    }];
    
}

#pragma mark - UITableViewDataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.userDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSNumber* type =  [self.userDataArray objectAtIndex:indexPath.row];
    userProfilInfoType currentType = [type intValue];
    
    switch (currentType) {
        case nameAndSurname:
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", self.userInfo.name, self.userInfo.surname];
            break;
        case city:
            cell.textLabel.text = self.userInfo.cityName;
            break;
        case education:
            cell.textLabel.text = self.userInfo.universityName;
            break;
        case sex:
            cell.textLabel.text = self.userInfo.gender;
            break;
            
        case online:
            cell.textLabel.text = self.userInfo.isOnline ? @"online" : @"offline";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
