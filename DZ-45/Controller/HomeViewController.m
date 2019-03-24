//
//  HomeViewController.m
//  DZ-45
//
//  Created by mbp on 08/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "HomeViewController.h"
#import "NavigationController.h"
#import "NetworkManager.h"
#import "NewsFeedItem.h"
#import "PostCell.h"
#import "WallData.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,PostCellDelegate>

@property (assign, nonatomic) BOOL alreadyLoaded;
@property (strong, nonatomic) NSArray* postArray;
@property (strong, nonatomic) UITableView* tableView;


@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.frame;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 800;
    
    [tableView registerClass:PostCell.self forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.tableView = tableView;
    
    [self.tableView reloadData];

    

    
    self.title = @"News";
    
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    imageView.image = [UIImage imageNamed:@"Balloon"];
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self.view addSubview:imageView];
    
}

-(void) getUserNewsFeed{
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.alreadyLoaded) {
        self.alreadyLoaded = true;
        
        UIImage* hamburger = [[UIImage imageNamed:@"hamburger"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:hamburger
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:(NavigationController *)self.navigationController
                                                                                action:@selector(showMenu)];
        
        [[NetworkManager sharedInstance] getOwnerPhotoUploadServer:@"92246877"
                                                         onSuccess:^(NSString * _Nonnull uploadUrl) {
                                                             
                                                         }
                                                         onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                                             
                                                         }];
        
        [[NetworkManager sharedInstance] getUserNewsFeedOnSuccess:^(NSArray * _Nonnull news) {
            self.postArray = news;
            [self.tableView reloadData];
        } onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
            
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.postArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NewsFeedItem* newsFeed = [self.postArray objectAtIndex:indexPath.row];
                   
    cell.postTextLabel.text = newsFeed.text;
    
    cell.countCommentLabel.text = [newsFeed.comments stringValue];
    
    cell.countLikeLabel.text = [newsFeed.like stringValue];
    
    //cell.userName.text = [NSString stringWithFormat:@"%@ %@", profile.name, profile.surname];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd-MMM-yyyy HH:mm";
    
    cell.datePost.text = [formatter stringFromDate:newsFeed.postDate];
    
    cell.delegate = self;
    
    return cell;
}

- (void)likeAction {
    NSLog(@"like");
}

- (void)repostAction {
    NSLog(@"Repost");
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (indexPath.row == [self.postArray count]) {
//        [self getUserNewsFeed];
//    }
}

@end
