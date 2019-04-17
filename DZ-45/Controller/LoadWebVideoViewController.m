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

@end
