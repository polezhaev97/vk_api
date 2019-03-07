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
    
    self.repostButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.repostButton addTarget:self
                        action:@selector(repostAction)
              forControlEvents:UIControlEventTouchUpInside];
    self.repostButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self addSubview:self.postTextLabel];
    [self addSubview:self.userName];
    [self addSubview:self.datePost];
    [self addSubview:self.userAvatar];
    [self addSubview:self.likeButton];
    [self addSubview:self.repostButton];

    //self.postTextLabel.text = @"test post1";
    self.postTextLabel.numberOfLines=0;
    self.postTextLabel.font = [UIFont systemFontOfSize:14];
   // self.postTextLabel.textColor = [UIColor redColor];

    
    //self.userName.text = @"Max polezhav";
    
    self.datePost.text = @"вчера в 21:49";
    self.datePost.textColor = [UIColor darkGrayColor];
    self.datePost.font = [UIFont systemFontOfSize:15];


   // self.userAvatar.image = [UIImage imageNamed: @"antoha" ];
    self.userAvatar.layer.masksToBounds = YES;
    self.userAvatar.layer.cornerRadius = 21 ;
    
    self.likeButton.backgroundColor = [UIColor redColor];
    
    [self applyConstraints];
}

-(void)applyConstraints {
    NSDictionary* views = @{
                            @"avatar" : self.userAvatar,
                            @"text" : self.postTextLabel,
                            @"date" : self.datePost,
                            @"name" : self.userName,
                            @"like":self.likeButton,
                            @"repost":self.repostButton
                            };
    
    NSArray* constraints =[[NSArray alloc] initWithObjects:
                           @"H:|-[avatar(44)]-[name]-|",
                           @"H:[avatar]-[date]-|",
                           @"H:|-[text]-|",
                           @"H:|-30-[like(20)]-25-[repost(20)]",
                           @"V:|-[avatar(44)]-[text]-[like(20)]-10-|",
                           @"V:[text]-[repost(20)]-10-|",
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
