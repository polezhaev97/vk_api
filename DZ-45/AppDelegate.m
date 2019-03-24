//
//  AppDelegate.m
//  DZ-45
//
//  Created by mbp on 23/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MenuNavigationController.h"
#import "NavigationController.h"
#import "Network/NetworkManager.h"
#import "LoginViewController.h"
#import "Controller/LoadingViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    LoginViewController* vc = [[LoginViewController alloc] initWithCompletionBlock:^(AccessToken* token){
        if (token != nil) {
            NetworkManager.sharedInstance.accessToken = token;
            self.window.rootViewController = [self getMainScene];
        }
    }];
    self.window.rootViewController = vc;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(UIViewController*) getMainScene {
    NavigationController* navController = [[NavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    MenuNavigationController* menuController = [[MenuNavigationController alloc] initWithStyle:UITableViewStylePlain];
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    
    return frostedViewController;
}

@end
