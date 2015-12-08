//
//  iPadMenuViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 8/12/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "AppDelegate.h"

@class iPadHomeViewController;
@interface iPadMenuViewController : UITableViewController {
    
    AppDelegate *appDelegate;
    NSInteger selectedMenuIndex;
}

@property (nonatomic, strong) iPadHomeViewController *homeView;
@property (nonatomic, strong) NSArray *optionsArray;
@end
