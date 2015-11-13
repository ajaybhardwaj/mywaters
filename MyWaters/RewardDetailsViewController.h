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
#import "QuickMapViewController.h"

@interface RewardDetailsViewController : UIViewController {
    
    AppDelegate *appDelegate;
    
    NSDictionary *dataDict;
    
    UIScrollView *bgScrollView;
    UIButton *redeemNowButton,*directionButton;
    
    UIView *descLabelBg;
    UIImageView *rewardImageView,*directionIcon,*infoIcon,*arrowIcon;
    UILabel *rewardInfoLabel,*rewardTitle,*distanceLabel;
    
    UILabel___Extension *descriptionLabel,*validFromLabel,*validFromValueLabel,*validToLabel,*validToValueLabel,*locationLabel,*locationValueLabel,*pointsLabel;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
}

@property (nonatomic, strong) NSString *rewardID,*descriptionString,*titleString,*validFromDateString,*validTillDateString,*locationValueString,*pointsValueString,*imageName,*imageUrl,*currentPointsString;
@property (nonatomic, assign) double latValue,longValue;

@end
