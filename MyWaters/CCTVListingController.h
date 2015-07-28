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

@interface CCTVListingController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    
    AppDelegate *appDelegate;
    
    UITableView *cctvListingTable,*filterTableView;
    NSArray *cctvDataSource,*filtersArray;
    
    BOOL isShowingFilter,isShowingSearchBar;
    NSInteger selectedFilterIndex;

    UITextField *searchField;
}

@end
