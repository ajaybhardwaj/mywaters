//
//  ABCWatersViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 23/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ABCWaterDetailViewController.h"

@interface ABCWatersViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    
    AppDelegate *appDelegate;
    
    
    UITableView *listTabeView,*filterTableView;
    NSArray *filtersArray;
    
    UISegmentedControl *gridListSegmentedControl;
    UIView *segmentedControlBackground;
    UIScrollView *abcWatersScrollView;
    
    UITextField *searchField;
    BOOL isShowingFilter,isShowingSearchBar;
    NSInteger selectedFilterIndex;
}

@end
