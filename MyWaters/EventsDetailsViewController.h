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
#import "DirectionViewController.h"
#import "QuickMapViewController.h"

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
    UIImageView *eventImageView;
    UIImageView *directionIcon,*infoIcon,*arrowIcon;
    UILabel *eventInfoLabel,*eventTitle,*distanceLabel;
    
    UILabel___Extension *descriptionLabel;
    
    BOOL isAlreadyFav,isSubscribing,isUnsubscribing;
}

@property (nonatomic, strong) NSString *eventID,*imageUrl,*titleString,*descriptionString,*phoneNoString,*addressString,*startDateString,*endDateString,*websiteString,*imageName,*timeValueString;
@property (nonatomic, assign) double latValue,longValue;
@property (nonatomic, assign) BOOL isSubscribed;

@end
