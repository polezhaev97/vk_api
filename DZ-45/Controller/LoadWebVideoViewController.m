//
//  LoadWebVideoViewController.m
//  DZ-45
//
//  Created by mbp on 27/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "LoadWebVideoViewController.h"
#import <WebKit/WebKit.h>

@interface LoadWebVideoViewController ()<WKNavigationDelegate>

@end

@implementation LoadWebVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.view.frame;
    
    WKWebView* webView = [[WKWebView alloc] initWithFrame:frame];
    webView.navigationDelegate = self;
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.player]];
    [webView loadRequest:nsrequest];
    [self.view addSubview:webView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
