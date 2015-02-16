//
//  RewardsListingViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RewardDetailsViewController.h"

@interface RewardsListingViewController : UIViewController {
    
    AppDelegate *appDelegate;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
    UIButton *rewardsDetailsButton;
}

@end