//
//  QuickMapViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 27/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AuxilaryService.h"

@interface QuickMapViewController : UIViewController {
    
    AppDelegate *appDelegate;
    BOOL isControlMaximize;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
    UIButton *maximizeButton;
    
}

@property (nonatomic, assign) BOOL isNotQuickMapController;

@end
