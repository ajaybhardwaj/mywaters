//
//  BadgesViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 11/8/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Constants.h"

@interface BadgesViewController : UIViewController {
    
    AppDelegate *appDelegate;
    
    UILabel *myBadgesLabel;
    UIButton *infoIconButton;
    
    UIScrollView *badgesScrollView;
}

@end
