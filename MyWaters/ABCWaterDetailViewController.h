//
//  ABCWaterDetailViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CustomButtons.h"
#import "UILabel + Extension.h"

@interface ABCWaterDetailViewController : UIViewController {
    
    AppDelegate *appDelegate;
    BOOL isControlMaximize;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
    
    
    
    UIView *topMenu;
    
    BOOL isShowingTopMenu;
    UIButton *addPhotoButton,*galleryButton,*shareButton;
    UILabel *addPhotoLabel,*galleryLabel,*shareLabel;
    
    NSDictionary *dataDict;
    
    
    UIScrollView *bgScrollView;
    UIButton *bookingFormButton,*arViewButton,*contactUsButton,*directionButton;
    UILabel *bookingFormLabel,*arViewLabel,*contactUsLabel;
    
    UIView *descLabelBg;
    UIImageView *eventImageView,*directionIcon,*infoIcon,*arrowIcon;
    UILabel *eventInfoLabel,*abcWaterTitle,*distanceLabel;
    
    UILabel___Extension *descriptionLabel;
}

@end
