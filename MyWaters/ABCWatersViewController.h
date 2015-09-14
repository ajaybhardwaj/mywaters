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
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "JSON.h"


@interface ABCWatersViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ASIHTTPRequestDelegate,UISearchBarDelegate,NSURLConnectionDelegate> {
    
    AppDelegate *appDelegate;
    
    
    UITableView *listTabeView,*filterTableView;
    NSArray *filtersArray;
    NSInteger abcWatersPageCount,abcWatersTotalCount;
    
    UISegmentedControl *gridListSegmentedControl;
    UIView *segmentedControlBackground;
    UIScrollView *abcWatersScrollView;
    
    UISearchBar *listinSearchBar;
    BOOL isShowingFilter,isShowingSearchBar,isFiltered;
    NSInteger selectedFilterIndex;
    
    NSMutableArray *filteredDataSource;
}

@end
