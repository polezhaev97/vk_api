//
//  HomeNavigationController.m
//  DZ-45
//
//  Created by mbp on 08/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "NavigationController.h"
#import "UIViewController+REFrostedViewController.h"
#import "MenuNavigationController.h"
#import "HomeViewController.h"


@interface NavigationController ()

@property (strong, readwrite, nonatomic) MenuNavigationController* menuNavController;


@end

@implementation NavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

- (void)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController panGestureRecognized:sender];
}

@end
