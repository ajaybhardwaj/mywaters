//
//  EventsViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "EventsDetailsViewController.h"

@interface EventsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate> {
    
    AppDelegate *appDelegate;
    
    UITableView *eventsListingTableView,*filterTableView;
    
    NSMutableArray *eventsTableDataSource;
    NSArray *filtersArray;
    
    BOOL isShowingFilter,isShowingSearchBar;
    NSInteger selectedFilterIndex;
    
    UITextField *searchField;
    //*************** Demo App Variables
    UIButton *eventDetailButton;
}
@property (nonatomic, assign) BOOL isNotEventController;

@end
