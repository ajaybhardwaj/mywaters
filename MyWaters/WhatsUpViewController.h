//
//  WhatsUpViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface WhatsUpViewController : UIViewController {
    
    AppDelegate *appDelegate;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
    UIButton *feedButton,*exploreButton;
}

@property (nonatomic, assign) BOOL isNotWhatsUpController;

@end
