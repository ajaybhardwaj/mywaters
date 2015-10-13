//
//  ProfileViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RewardsListingViewController.h"
#import "Constants.h"
#import "EditProfileViewController.h"
#import "BadgesViewController.h"
#import "PointsViewController.h"
#import "PhotosViewController.h"

@interface ProfileViewController : UIViewController <UITabBarControllerDelegate,UITableViewDataSource,UITableViewDelegate> {
    
    AppDelegate *appDelegate;
    
    UIImageView *profileImageView;
    UILabel *userNameLabel,*myBadgesLabel,*myPointsLabel,*myPointsValueLabel,*myPhotosLabel;
    UIButton *joinFriendOfWatersButton,*infoIconButton;
    
    UIScrollView *badgesScrollView,*photosScrollView,*bgContentScrollView;
    
    
    
    //===== Tabs Control
    UIView *tabsBackground;
    UIButton *badgesButton,*pointsButton,*rewardsButton,*photosButton;
    UIButton *badgesIcon,*pointsIcon,*rewardsIcon,*photosIcon;
    UILabel *badgesLabel,*pointsLabel,*rewardsLabel,*photosLabel;
    
    
    //===== Badges Controls
    UIView *badgesBackgroundView;
    NSArray *badgesDataSource;
    
    //===== Rewards Controls
    UITableView *rewardsListingTableView;
    NSArray *rewardsDataSource;
    
    //===== Points Controls
    UITableView *pointsTableView;
    NSArray *pointsDataSource;
    
    //===== Photos Controls
    UIView *photosBackgroundView;
    NSArray *photosDataSource;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
    UIButton *rewardsDetailButton;
}
//@property (nonatomic, strong) UITabBarController *tabBarController;


@end
