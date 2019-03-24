//
//  LoginViewController.m
//  DZ-45
//
//  Created by mbp on 24/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "LoginViewController.h"
#import "AccessToken.h"
#import "NetworkManager.h"
@interface LoginViewController ()<WKNavigationDelegate>

@property (copy, nonatomic) LoginCimpletionBlock completionBlock;

@end

@implementation LoginViewController

- (id) initWithCompletionBlock:(LoginCimpletionBlock)completionBlock{
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = self.view.frame;
    
    WKWebView* webView = [[WKWebView alloc] initWithFrame:frame];
    webView.navigationDelegate = self;
    NSURLRequest* nsrequest =  [[NetworkManager sharedInstance] getAuthorizeRequest];
    [webView loadRequest:nsrequest];
    [self.view addSubview:webView];

    self.navigationItem.title = @"Login";
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"Error = %@", error.description);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    if ([[[navigationAction.request URL] host] isEqualToString:@"oauth.vk.com"]) {
        
        NSString* query = [[navigationAction.request URL] description];
    
        if ([query containsString:@"https://oauth.vk.com/authorize?client_id=6873328"]) {
              decisionHandler(WKNavigationActionPolicyAllow);
            return;
        }
        
        AccessToken* token = [[NetworkManager sharedInstance] getTokenFromResponce:query];
        
        if (self.completionBlock) {
            self.completionBlock(token);
        }
    }
     decisionHandler(WKNavigationActionPolicyAllow);
}

@end
