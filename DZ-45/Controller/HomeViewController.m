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

@interface HomeViewController ()

@property (assign, nonatomic) BOOL alreadyLoaded;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Home";
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"Balloon"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.alreadyLoaded) {
        self.alreadyLoaded = true;
        [[NetworkManager sharedInstance] authorizeUser:^(BOOL isSuccess) {
            NSLog(@"isOk %d ", isSuccess);
            if (isSuccess) {
                self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"hamburger"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                                         style:UIBarButtonItemStylePlain
                                                                                        target:(NavigationController *)self.navigationController
                                                                                        action:@selector(showMenu)];
            }
        }];
    }
}

@end
