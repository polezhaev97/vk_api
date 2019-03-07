//
//  PostCell.h
//  DZ-45
//
//  Created by mbp on 05/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PostCellDelegate <NSObject>

-(void)likeAction;
-(void)repostAction;


@end

@interface PostCell : UITableViewCell

@property(weak,nonatomic) id <PostCellDelegate> delegate;

@property(strong, nonatomic) UILabel* postTextLabel;
@property(strong, nonatomic) UIImageView* userAvatar;
@property(strong, nonatomic) UILabel* userName;
@property(strong,nonatomic) UILabel* datePost;
@property(strong,nonatomic) UIButton* likeButton;
@property(strong,nonatomic) UIButton* repostButton;

- (instancetype)initWith:(NSDictionary*) dictionary;



@end

NS_ASSUME_NONNULL_END
