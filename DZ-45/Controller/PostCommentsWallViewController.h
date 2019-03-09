//
//  PostCommentsWallViewController.h
//  DZ-45
//
//  Created by mbp on 05/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
NS_ASSUME_NONNULL_BEGIN

@interface PostCommentsWallViewController : UIViewController

@property(strong,nonatomic) Post* currentPost;
@end

NS_ASSUME_NONNULL_END
