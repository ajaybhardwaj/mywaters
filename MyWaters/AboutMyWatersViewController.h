//
//  AboutMyWatersViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/3/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CustomButtons.h"

@interface AboutMyWatersViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    
    UITableView *aboutTableView;
    NSArray *tableTitleDataSource;
}

@end
