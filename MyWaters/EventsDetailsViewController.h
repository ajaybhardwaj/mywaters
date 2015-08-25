//
//  EventsDetailsViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 29/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UILabel + Extension.h"
#import "AsyncImageView.h"

@interface EventsDetailsViewController : UIViewController {
    
    AppDelegate *appDelegate;
    UIView *topMenu;
    
    BOOL isShowingTopMenu;
    UIButton *notifyButton,*favouritesButton,*shareButton;
    UILabel *notifyLabel,*addToFavlabel,*shareLabel;
    
    NSDictionary *dataDict;

    
    UIScrollView *bgScrollView;
    UIButton *callUsButton,*directionButton;
    UILabel *callUsLabel;
    
    UIView *descLabelBg;
    AsyncImageView *eventImageView;
    UIImageView *directionIcon,*infoIcon,*arrowIcon;
    UILabel *eventInfoLabel,*eventTitle,*distanceLabel;
    
    UILabel___Extension *descriptionLabel;
}

@property (nonatomic, strong) NSString *imageUrl,*titleString,*descriptionString,*phoneNoString,*addressString,*startDateString,*endDateString,*websiteString;
@property (nonatomic, assign) double latValue,longValue;


@end
