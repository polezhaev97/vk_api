//
//  SecondViewController.m
//  DZ-45
//
//  Created by mbp on 08/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "SecondViewController.h"
#import "NavigationController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Second Controller";
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(NavigationController *)self.navigationController
                                                                            action:@selector(showMenu)];
}
@end
