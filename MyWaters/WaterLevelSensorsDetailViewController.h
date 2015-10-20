//
//  WaterLevelSensorsDetailViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 14/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "CustomButtons.h"
#import "QuickMapAnnotations.h"
#import "DirectionViewController.h"
#import "SMSSubscriptionViewController.h"

@interface WaterLevelSensorsDetailViewController : UIViewController <MKMapViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    
    AppDelegate *appDelegate;
    
    MKMapView *wateLevelMapView;
    BOOL isShowingTopMenu;
    
    UIView *topMenu,*cctvView;
    UILabel *titleLabel,*timeLabel,*drainDepthLabel,*depthValueLabel;
    UIButton *clockButton,*levelButton,*currentLocationButton;
    UIImageView *measurementBar;
    
    UIImageView *wlsIconView;
    UILabel *riskLabel;
    
    UISearchBar *topSearchBar;
    UIButton *alertButton,*addToFavButton,*refreshButton;
    UILabel *iAlertLabel,*addToFavLabel,*refreshLabel;
    
    UIImageView *topImageView,*directionIcon,*arrowIcon;
    UIButton *directionButton;
    UILabel *cctvTitleLabel,*distanceLabel;
    
    UITableView *wlsListingTable;
    
    UIButton *notifiyButton;
    
    QuickMapAnnotations *annotation1;
    
    UIView *alertOptionsView;
    int selectedAlertType;
    UIButton *level50Button,*level75Button,*level90Button,*level100Button;
    
    UIImageView *dimmedImageView;
    
    BOOL isAlreadyFav,isSubscribingForAlert;
    NSMutableArray *tempNearByArray;

    UITextField *locationField;
    
    UIToolbar *dropDownToolbar;
    UIPickerView *dropDownPicker;
    UIBarButtonItem *cancelBarButton,*doneBarButton,*flexibleSpace;
    UIView *dropDownBg;
    NSInteger pickerSelectedIndex;
}

@property (nonatomic, assign) NSInteger drainDepthType;
@property (nonatomic, strong) NSString *wlsID,*wlsName,*observedTime,*waterLevelValue,*waterLevelPercentageValue,*waterLevelTypeValue,*drainDepthValue;
@property (nonatomic, assign) double latValue,longValue;
@property (nonatomic, assign) BOOL isSubscribed;


@end
