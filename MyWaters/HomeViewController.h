//
//  HomeViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "QuickMapViewController.h"
#import "WhatsUpViewController.h"
#import "FeedbackViewController.h"
#import "CCTVDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WelcomeViewController.h"

@interface HomeViewController : UIViewController {
    
    AppDelegate *appDelegate;
    
    UIView *welcomeView;
    UIImageView *profileImageView;
    UIScrollView *backgroundScrollView;
    UIButton *reportIncidentButton;
    
    NSInteger leftCoulumnIndex,rightColumnIndex;
    float left_yAxis,right_yAxis;
    
    //*************** Demo App UI Variables
    UIButton *quickMapButton,*whatsUpButton,*cctvButton,*reportButton;
}

@end
