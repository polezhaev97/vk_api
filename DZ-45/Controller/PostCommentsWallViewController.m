//
//  PostCommentsWallViewController.m
//  DZ-45
//
//  Created by mbp on 05/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "PostCommentsWallViewController.h"
#import "NetworkManager.h"
#import "UIKit+AFNetworking.h"
#import "UserProfileViewController.h"

#import "PostComments.h"

@interface PostCommentsWallViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* commentsArray;
@property (weak, nonatomic) UITableView* tableView;
@property (assign, nonatomic) BOOL alreadyLoaded;

@end

@implementation PostCommentsWallViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.view.frame;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 800;
    
    [tableView registerClass:UITableViewCell.self forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    
    self.commentsArray = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.alreadyLoaded) {
        self.alreadyLoaded = YES;
        [self getCommentsFromServer];
    }
}

#pragma mark - API

-(void) getCommentsFromServer {
    [[NetworkManager sharedInstance] getCommentsWall:@"58860049"
                                          withOffset:self.currentPost.postID
                                           onSuccess:^(NSArray * _Nonnull posts) {
                                               [self.commentsArray addObjectsFromArray:posts];
                                               
                                               NSMutableArray* newPaths = [NSMutableArray array];
                                               for (int i = (int)[self.commentsArray count] - (int)[posts count]; i < [self.commentsArray count]; i++) {
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
    
    return [self.commentsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PostComments* currentComments =[self.commentsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = currentComments.text;
    
    return cell;
}
@end
