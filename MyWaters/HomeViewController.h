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

@interface HomeViewController : UIViewController {
    
    AppDelegate *appDelegate;
    
    
    //*************** Demo App UI Variables
    UIButton *quickMapButton,*whatsUpButton,*cctvButton,*reportButton;
}

@end
