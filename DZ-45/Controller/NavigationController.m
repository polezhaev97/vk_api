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
#import "NewsViewController.h"
#import "NetworkManager.h"


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
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController presentMenuViewController];
    [self getVideo];
}

-(void) getVideo {
    
    [[NetworkManager sharedInstance] getVideoMy:@"92246877"
                                      onSuccess:^(NSArray * _Nonnull videoArray) {
                                          
                                      } onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                          
                                      }];
}

-(void) writeToTextFile{
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"mbp/Desktop/haha.txt"];
//
//    NSString *str = @"hello world";
//
//    [str writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"haha.txt"];
    NSString *str = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
//    NSString* str = myTextView.text;
//    myAnotherTextView.text = str;
    
    NSLog(@"%@",str );
    
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    [self.frostedViewController panGestureRecognized:sender];
}

@end
