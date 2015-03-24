//
//  RewardDetailsViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UILabel + Extension.h"

@interface RewardDetailsViewController : UIViewController {
    
    AppDelegate *appDelegate;
    
    NSDictionary *dataDict;
    
    UIScrollView *bgScrollView;
    UIButton *redeemNowButton,*directionButton;
    
    UIView *descLabelBg;
    UIImageView *rewardImageView,*directionIcon,*infoIcon,*arrowIcon;
    UILabel *rewardInfoLabel,*rewardTitle,*distanceLabel;
    
    UILabel___Extension *descriptionLabel;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
}

@end
