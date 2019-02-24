//
//  ViewController.m
//  DZ-45
//
//  Created by mbp on 23/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "ViewController.h"
#import "NetworkManager.h"
#import "UIKit+AFNetworking.h"
#import "UserProfileViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* friendsArray;
@property (weak, nonatomic) UITableView* tableView;
@property (assign, nonatomic) BOOL alreadyLoaded;

@end

@implementation ViewController

static NSInteger friendsInRequest = 15;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendsArray = [[NSMutableArray alloc] init];
 
    
    CGRect frame = self.view.frame;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor redColor];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:UITableViewCell.self forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:tableView];
    [tableView reloadData];
    
    self.tableView = tableView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.alreadyLoaded) {
        self.alreadyLoaded = true;
        [[NetworkManager sharedInstance] authorizeUser:^(BOOL isSuccess) {
            NSLog(@"isOk %d ", isSuccess);
            if (isSuccess) {
                   [self getFriendsFromServer];
            }
        }];
    }
}

#pragma mark - API

-(void) getFriendsFromServer {
    
    [[NetworkManager sharedInstance]
     getFriendsWithOffset:[self.friendsArray count]
     count:friendsInRequest
     onSuccess:^(NSArray * _Nonnull friends) {
         
         [self.friendsArray addObjectsFromArray:friends];
         [self.tableView reloadData];
         
     }
     onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription] , statusCode);
     }];
    
}

#pragma mark - UITableViewDataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.friendsArray count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
     if (indexPath.row == [self.friendsArray count] ){
         cell.textLabel.text = @"load more";
     }else{
         User* currentUser =[self.friendsArray objectAtIndex:indexPath.row];
         
         cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", currentUser.name, currentUser.surname];
         [cell.imageView setImageWithURL:currentUser.imageURL];
     }
    
    return cell;
}
#pragma mark - UITAbleViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.friendsArray count]){
        
        [self getFriendsFromServer];
        
    }else{
        UserProfileViewController* vc = [[UserProfileViewController alloc] init];
        User* currentUser =[self.friendsArray objectAtIndex:indexPath.row];
        vc.userId = currentUser.userID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
