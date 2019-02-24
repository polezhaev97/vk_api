//
//  LoginViewController.m
//  DZ-45
//
//  Created by mbp on 24/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "LoginViewController.h"
#import "AccessToken.h"
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
    NSURL *nsurl=[NSURL URLWithString:@"https://oauth.vk.com/authorize?client_id=6874505&display=mobile&redirect_uri=http://test.max/&scope=131078&response_type=token&v=5.92&state=123456"];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [webView loadRequest:nsrequest];
    [self.view addSubview:webView];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(actionCancel:)];
    
    [self.navigationItem setRightBarButtonItem:item animated:NO];
    self.navigationItem.title = @"Login";
    
}


- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"Error = %@", error.description);
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    if ([[[navigationAction.request URL] host] isEqualToString:@"test.max"]) {
        
        AccessToken* token = [[AccessToken alloc] init];
        
        NSString* query = [[navigationAction.request URL] description];
        
        NSArray* array = [query componentsSeparatedByString:@"#"];
        
        if ([array count] > 1) {
            query = [array lastObject];
        }
        
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        
        for (NSString* pair in pairs) {
            
            NSArray* values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2) {
                
                NSString* key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"]) {
                    token.token = [values lastObject];
                } else if ([key isEqualToString:@"expires_in"]) {
                    
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    
                } else if ([key isEqualToString:@"user_id"]) {
                    
                    token.userID = [values lastObject];
                }
            }
        }
        
        
        if (self.completionBlock) {
            self.completionBlock(token);
        }
        
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
        
      

    }
     decisionHandler(WKNavigationActionPolicyAllow);
}




-(void) actionCancel: (UIBarButtonItem*) item {
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end
