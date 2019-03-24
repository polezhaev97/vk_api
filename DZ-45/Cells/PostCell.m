//
//  PostCell.m
//  DZ-45
//
//  Created by mbp on 05/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "PostCell.h"

@implementation PostCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void) initView{
    
    self.postTextLabel =[[UILabel alloc] init];
    self.postTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.countLikeLabel =[[UILabel alloc] init];
    self.countLikeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.countCommentLabel =[[UILabel alloc] init];
    self.countCommentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.userName = [[UILabel alloc] init];
    self.userName.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.datePost = [[UILabel alloc] init];
    self.datePost.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.userAvatar = [[UIImageView alloc]init];
    self.userAvatar.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.likeButton = [[UIButton alloc] init];
    [self.likeButton addTarget:self
                        action:@selector(likeAction)
              forControlEvents:UIControlEventTouchUpInside];
    self.likeButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *imageLikeButton = [UIImage imageNamed:@"likeButton"];

    
    self.comentsButton = [[UIButton alloc] init];
    [self.comentsButton addTarget:self
                        action:@selector(repostAction)
              forControlEvents:UIControlEventTouchUpInside];
    self.comentsButton.translatesAutoresizingMaskIntoConstraints = NO;
    UIImage *imageComentsButton = [UIImage imageNamed:@"comment"];

    [self addSubview:self.postTextLabel];
    [self addSubview:self.countLikeLabel];
    [self addSubview:self.countCommentLabel];
    [self addSubview:self.userName];
    [self addSubview:self.datePost];
    [self addSubview:self.userAvatar];
    [self addSubview:self.likeButton];
    [self addSubview:self.comentsButton];

    self.postTextLabel.numberOfLines=0;
    self.postTextLabel.font = [UIFont systemFontOfSize:14];

    self.datePost.text = @"вчера в 21:49";
    self.datePost.textColor = [UIColor darkGrayColor];
    self.datePost.font = [UIFont systemFontOfSize:15];

    self.userAvatar.layer.masksToBounds = YES;
    self.userAvatar.layer.cornerRadius = 21 ;
    
    [self.likeButton setImage:imageLikeButton forState:UIControlStateNormal];
    
    [self.comentsButton setImage:imageComentsButton forState:UIControlStateNormal];

    
    [self applyConstraints];
}

-(void)applyConstraints {
    NSDictionary* views = @{
                            @"avatar" : self.userAvatar,
                            @"text" : self.postTextLabel,
                            @"countLike":self.countLikeLabel,
                            @"countComment":self.countCommentLabel,
                            @"date" : self.datePost,
                            @"name" : self.userName,
                            @"like":self.likeButton,
                            @"repost":self.comentsButton
                            };
    
    NSArray* constraints =[[NSArray alloc] initWithObjects:
                           @"H:|-[avatar(44)]-[name]-|",
                           @"H:[avatar]-[date]-|",
                           @"H:|-[text]-|",
                           @"H:|-30-[like(30)]-6-[countLike(40)]-30-[repost(30)]-6-[countComment(35)]",
                           @"V:|-[avatar(44)]-[text]-[like(30)]-10-|",
                           @"V:[text]-[repost(30)]-10-|",
                           @"V:[text]-[countLike(30)]-10-|",
                           @"V:[text]-[countComment(30)]-10-|",
                           @"V:|-[name(18)]-5-[date]-10-[text]"
                           ,nil];
    
    NSMutableArray* layoutConstraint = [[NSMutableArray alloc] init];
    
    for (NSString* constraint in constraints) {
        NSArray* c = [NSLayoutConstraint constraintsWithVisualFormat:constraint options:0 metrics:nil views:views];
        [layoutConstraint addObjectsFromArray:c];
    }
    [NSLayoutConstraint activateConstraints:layoutConstraint];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    self.postTextLabel.preferredMaxLayoutWidth = self.postTextLabel.frame.size.width;
}

-(void) likeAction{
    NSLog(@"like!!!!!");
    [self.delegate likeAction];

}

-(void) repostAction{
    NSLog(@"repost!!!!!");
    
    [self.delegate repostAction];
}


@end
