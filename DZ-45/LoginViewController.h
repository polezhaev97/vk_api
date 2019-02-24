//
//  LoginViewController.h
//  DZ-45
//
//  Created by mbp on 24/02/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


@class AccessToken;

typedef void(^LoginCimpletionBlock)(AccessToken* token) ;

@interface LoginViewController : UIViewController

-(id) initWithCompletionBlock:(LoginCimpletionBlock) completionBlock;

@end

