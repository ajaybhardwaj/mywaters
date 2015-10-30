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
#import "AsyncImageView.h"
#import "DirectionViewController.h"
#import "GalleryViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "QuickMapViewController.h"
#import "FGalleryViewController.h"

@interface ABCWaterDetailViewController : UIViewController <UINavigationControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FBSDKSharingDelegate,FGalleryViewControllerDelegate> {
    
    AppDelegate *appDelegate;
    BOOL isControlMaximize;
    
    //*************** Demo App Variables
    UIImageView *bgImageView;
    
    
    
    UIView *topMenu;
    
    BOOL isShowingTopMenu;
    UIButton *addPhotoButton,*favouritesButton,*shareButton;
    UILabel *addPhotoLabel,*favouriteLabel,*shareLabel;
    
    NSDictionary *dataDict;
    
    
    UIScrollView *bgScrollView;
    UIButton *bookingFormButton,*arViewButton,*contactUsButton,*directionButton;
    UILabel *bookingFormLabel,*arViewLabel,*contactUsLabel;
    
    UIView *descLabelBg;
    UIImageView *eventImageView;
    UIImageView *directionIcon,*infoIcon,*arrowIcon;
    UILabel *eventInfoLabel,*abcWaterTitle,*distanceLabel;
    
    UILabel___Extension *descriptionLabel;
    
    NSMutableArray *abcGalleryImages;
    BOOL isFetchingGalleryImages;
    
    NSDictionary *twelveHourWeatherData;
    UIImageView *temperatureBgView,*temperatureIcon;
    UILabel *temperatureLabel;
    
    FGalleryViewController *networkGallery;
//    NSArray *networkImages;
}

@property (nonatomic, strong) NSString *abcSiteId,*imageUrl,*titleString,*descriptionString,*phoneNoString,*addressString,*imageName;
@property (nonatomic, assign) double latValue,longValue;
@property (nonatomic, assign) BOOL isCertified,isAlreadyFav,isHavingPOI;

@end
