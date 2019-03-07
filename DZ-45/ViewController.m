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
#import "Post.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray* friendsArray;
@property (strong, nonatomic) NSMutableArray* searchArray;
@property (weak, nonatomic) UITableView* tableView;
@property (assign, nonatomic) BOOL alreadyLoaded;
@property (strong, nonatomic)  UISearchBar* searchBar;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendsArray = [[NSMutableArray alloc] init];
  self.searchArray = [[NSMutableArray alloc] init];
    
    CGRect frame = self.view.frame;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 44)];
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    
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
     getAllFriendsOnSuccess:^(NSArray * _Nonnull friends) {
         
//         NSSortDescriptor *sortDescriptor;
//         sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
//                                                      ascending:YES];
//         NSArray *sortedArray = [friends sortedArrayUsingDescriptors:@[sortDescriptor]];
         
         [self.friendsArray addObjectsFromArray:friends];
         [self.searchArray addObjectsFromArray:friends];
         
         [self.tableView reloadData];
         
     }
     onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription] , statusCode);
     }];
    
}

#pragma mark - UITableViewDataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.searchArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
         User* currentUser =[self.searchArray objectAtIndex:indexPath.row];
         
         cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", currentUser.name, currentUser.surname];
         [cell.imageView setImageWithURL:currentUser.imageURL];
    
    return cell;
}
#pragma mark - UITAbleViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
        UserProfileViewController* vc = [[UserProfileViewController alloc] init];
        User* currentUser =[self.searchArray objectAtIndex:indexPath.row];
        vc.userId = currentUser.userID;
        [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearshBar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([searchText isEqualToString: @""]) {
        self.searchArray = self.friendsArray;
    }
    else {
        NSPredicate *surnamePredicate =
        [NSPredicate predicateWithFormat:@"SELF.surname beginswith[c] %@",searchText];
        
        NSPredicate *namePredicate =
        [NSPredicate predicateWithFormat:@"SELF.name beginswith[c] %@",searchText];
        
        NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[namePredicate, surnamePredicate]];
        
        NSArray* filtered = [self.friendsArray filteredArrayUsingPredicate:predicate];
        self.searchArray = [[NSMutableArray alloc] initWithArray: filtered ];
    }
    
    NSLog(@"yes %@",  searchBar.text);
    
    [self.tableView reloadData];
}

@end
