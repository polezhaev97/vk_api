//
//  MenuNavigationController.m
//  DZ-45
//
//  Created by mbp on 08/03/2019.
//  Copyright © 2019 mbp. All rights reserved.
//

#import "MenuNavigationController.h"
#import "UIViewController+REFrostedViewController.h"
#import "HomeViewController.h"
#import "SecondViewController.h"

#import "ViewController.h"
#import "GroupWallViewController.h"
#import "Section.h"


@interface MenuNavigationController ()

@property(strong, nonatomic) NSMutableArray* sectionsArray;

@end

@implementation MenuNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sectionsArray = [[NSMutableArray alloc] init];
    
    Section* section1 = [[Section alloc] initWithRows:@[@(myProfile), @(friends), @(group)]];
    
    [self.sectionsArray addObject:section1];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"antoha"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UIButton* photoButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 10, 50, 50)];
        UIImage *imageButton = [UIImage imageNamed:@"photoButton"];
        
//        CGRect listButtonFrame = photoButton.frame;
//        listButtonFrame.size = imageButton.size;
//        photoButton.frame = listButtonFrame;
        
        [photoButton setImage:imageButton forState:UIControlStateNormal];
        photoButton.layer.cornerRadius = 15;
        photoButton.backgroundColor = [UIColor redColor];
        
        [photoButton addTarget:self
                        action:@selector(takePhoto)
              forControlEvents:UIControlEventTouchUpInside];


        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"antoha";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

        [view addSubview:imageView];
        [view addSubview:label];
        [view addSubview:photoButton];

        view;
    });
}

- (void)takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;
    
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    Section* currentSection = [self.sectionsArray objectAtIndex:indexPath.section];
    
    NSNumber* type = [currentSection.arrayRows objectAtIndex:indexPath.row];
    menuRows currentType = [type intValue];
    
    if (currentType == myProfile) {
        
    }else if (currentType == friends){
        ViewController * friendsViewController = [[ViewController alloc] init];
        NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:friendsViewController];
        self.frostedViewController.contentViewController = navigationController;
    }else if(currentType == group){
        GroupWallViewController *groupViewController = [[GroupWallViewController alloc] init];
        NavigationController *navigationController = [[NavigationController alloc] initWithRootViewController:groupViewController];
        self.frostedViewController.contentViewController = navigationController;
    }
    
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    Section* currentSection = [self.sectionsArray objectAtIndex:sectionIndex];
    return [currentSection.arrayRows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Section* currentSection = [self.sectionsArray objectAtIndex:indexPath.section];
    
    NSNumber* type = [currentSection.arrayRows objectAtIndex:indexPath.row];
    menuRows currentType = [type intValue];
    
    switch (currentType) {
        case myProfile:
            cell.textLabel.text = @"Profile";
            break;
        case friends:
            cell.textLabel.text = @"Friends";
            break;
        case group:
            cell.textLabel.text = @"Group";
            break;
    }
    

    return cell;
}

@end
