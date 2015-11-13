//
//  CCTVListingController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 27/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "CCTVDetailViewController.h"

@interface CCTVListingController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate> {
    
    AppDelegate *appDelegate;
    
    UITableView *cctvListingTable,*filterTableView;
    NSArray *filtersArray;
    
    NSMutableArray *filteredDataSource;
    
    BOOL isShowingFilter,isShowingSearchBar,isFiltered;
    NSInteger selectedFilterIndex;
    UISearchBar *listinSearchBar;

    NSInteger cctvPageCount;
    UIButton *hideFilterButton;

}
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end
