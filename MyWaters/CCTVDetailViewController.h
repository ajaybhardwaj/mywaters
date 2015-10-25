//
//  CCTVDetailViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 29/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DirectionViewController.h"
#import "QuickMapViewController.h"

@interface CCTVDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate> {
    
    AppDelegate *appDelegate;
    
    UIView *topMenu;
    
    BOOL isShowingTopMenu;
    UIButton *exploreMapButton,*addToFavButton,*refreshButton,*shareButton,*favouritesButton;
    UILabel *exploreMapLabel,*addToFavLabel,*refreshLabel,*shareLabel,*addToFavlabel;
    
    UIButton *directionButton;
    UIImageView *directionIcon,*arrowIcon,*topImageView;
    UILabel *cctvTitleLabel,*distanceLabel;
    
    UITableView *cctvListingTable;
    NSArray *tableDataSource;
    BOOL isAlreadyFav;
    
    NSMutableArray *tempNearByArray;
    
    UIImageView *zoomedImageView;
    UIPinchGestureRecognizer *twoFingerPinch;
    UIScrollView *fullImageScrollView;
    UIButton *closeButton;
    
    UITableView *searchTableView;
    NSMutableArray *filterDataSource;
    BOOL isFiltered;
    UISearchBar *listinSearchBar;
    UIImageView *dimmedImageView;
}

@property (nonatomic, strong) NSString *imageUrl,*titleString,*cctvID;
@property (nonatomic, assign) double latValue,longValue;


@end
