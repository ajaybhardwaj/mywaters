//
//  TipsListingViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 20/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TipsListingViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    AppDelegate *appDelegate;
    UITableView *tipsListingTableView;
    
    UILabel *noDataLabel;
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;


@end
