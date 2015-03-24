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

@interface ProfileViewController : UIViewController {
    
    AppDelegate *appDelegate;
    
    UIImageView *profileImageView;
    UILabel *userNameLabel,*myBadgesLabel,*myPointsLabel,*myPointsValueLabel,*myPhotosLabel;
    UIButton *rewardsButton,*joinFriendOfWatersButton,*infoIconButton;
    
    UIScrollView *badgesScrollView,*photosScrollView,*bgContentScrollView;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
}

@end
