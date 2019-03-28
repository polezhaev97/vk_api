//
//  SecondViewController.m
//  DZ-45
//
//  Created by mbp on 08/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "VideoViewController.h"
#import "NavigationController.h"
#import "NetworkManager.h"
#import "UIKit+AFNetworking.h"
#import "VideoModel.h"
#import "LoadWebVideoViewController.h"
@interface VideoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* videoArray;
@property (assign, nonatomic) BOOL alreadyLoaded;
@property (weak, nonatomic) UITableView* tableView;

@end

@implementation VideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Video";
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"hamburger"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(NavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
    
    self.videoArray = [[NSArray alloc] init];
    //[self getVideo];
    [self createTableView];
    [self.tableView reloadData];
}

-(void) createTableView {
    
    CGRect frame = self.view.frame;
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    
    [tableView registerClass:UITableViewCell.self forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    self.tableView = tableView;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.alreadyLoaded) {
        self.alreadyLoaded = YES;
        [self getVideo];
    }
}



-(void) getVideo {
    
    [[NetworkManager sharedInstance] getVideoMy:@"92246877"
                                      onSuccess:^(NSArray * _Nonnull videoArray) {
                                          self.videoArray = videoArray;
                                          [self.tableView reloadData];

                                      } onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                          
                                      }];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.videoArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    VideoModel* video =[self.videoArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", video.nameTitle];
    [cell.imageView setImageWithURL:video.imageURL];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LoadWebVideoViewController* vc =  [LoadWebVideoViewController new];
    VideoModel* videoPlayer =[self.videoArray objectAtIndex:indexPath.row];
    vc.player = videoPlayer.player;
    [self.navigationController pushViewController:vc animated:true];
}
    
@end
    
