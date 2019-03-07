//
//  GroupWallViewController.m
//  DZ-45
//
//  Created by mbp on 05/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "GroupWallViewController.h"
#import "NetworkManager.h"
#import "UIKit+AFNetworking.h"
#import "UserProfileViewController.h"
#import "PostCommentsWallViewController.h"
#import "PostCell.h"
#import "Post.h"
#import "User.h"
#import "AccessToken.h"

@interface GroupWallViewController ()<UITableViewDelegate, UITableViewDataSource, PostCellDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray* postArray;
@property (weak, nonatomic) UITableView* tableView;
@property (assign, nonatomic) BOOL alreadyLoaded;
@property (strong, nonatomic) WallData * data;
@property (strong, nonatomic)  UISearchBar* searchBar;

@end

@implementation GroupWallViewController

static NSInteger postInRequest = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.view.frame;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:frame];
    [self.searchBar sizeToFit];
    self.searchBar.delegate = self;
    [self.navigationController.navigationBar addSubview:self.searchBar];


    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:self];
    self.navigationItem.titleView = searchController.searchBar;
    self.definesPresentationContext = YES;
    

    
//     self.searchBar = [[UISearchBar alloc] initWithFrame:frame];
//    [self.searchBar sizeToFit];
//
//    UISearchDisplayController *searchDisplayController= [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar
//                                                                                          contentsController:self];
//    self.searchDisplayController.searchResultsDelegate = self;
//    self.searchDisplayController.searchResultsDataSource = self;
//    self.searchBar.delegate = self;
//    self.navigationItem.titleView = searchDisplayController.searchBar;
//    [self.navigationController.navigationBar addSubview:self.searchBar];

    
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 800;
    
    [tableView registerClass:PostCell.self forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.tableView = tableView;
    
    self.data = [WallData new];
    self.data.posts = [NSMutableArray new];
       self.data.profiles = [NSMutableDictionary new];
    self.postArray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.alreadyLoaded) {
        self.alreadyLoaded = YES;
        [[NetworkManager sharedInstance] authorizeUser:^(BOOL isSuccess) {
            NSLog(@"isOk %d ", isSuccess);
            if (isSuccess) {
                [self getPostFromServer];
            }
        }];
    }
}

#pragma mark - API

-(void) getPostFromServer {
    
    [[NetworkManager sharedInstance]
     getGroupWall:@"58860049"
     withOffset:[self.data.posts count]
     count:postInRequest
     onSuccess:^(WallData* currentData) {
         self.data.profiles = currentData.profiles;
         [self.data.posts addObjectsFromArray:currentData.posts];
         
         NSMutableArray* newPaths = [NSMutableArray array];
         for (int i = (int)[self.data.posts count] - (int)[self.data.posts count]; i < [self.data.posts count]; i++) {
             [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
         [self.tableView endUpdates];
         
     }
     onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld", [error localizedDescription] , statusCode);
     }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.data.posts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Post* currentPost =[self.data.posts objectAtIndex:indexPath.row];
    ShortProfile* profile = [self.data.profiles objectForKey:currentPost.fromID];
    cell.postTextLabel.text = currentPost.text;
    cell.userName.text = [NSString stringWithFormat:@"%@ %@", profile.name, profile.surname];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MMM-yyyy HH:mm";
    
    cell.datePost.text = [formatter stringFromDate:currentPost.postDate];
;
    
    [cell.userAvatar setImageWithURL:profile.imageURL];
    
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     Post* currentPost =[self.data.posts objectAtIndex:indexPath.row];
    PostCommentsWallViewController* vc =  [PostCommentsWallViewController new];
    vc.currentPost = currentPost;
    [self.navigationController pushViewController:vc animated:true];
}


- (void)likeAction {
    //
}

- (void)repostAction {
    
}

#pragma mark - UISearshBar

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [searchBar setShowsCancelButton:YES animated:YES];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSLog(@"yes %@",  searchBar);
    
    [self.tableView reloadData];
}


@end
