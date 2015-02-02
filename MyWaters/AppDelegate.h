//
//  AppDelegate.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 27/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IIViewDeckController.h"
#import "SharedObject.h"
#import "HomeViewController.h"
#import "ViewControllerHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,IIViewDeckControllerDelegate> {
    
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IIViewDeckController *rootDeckController;
@property (nonatomic, assign) NSInteger left_deck_width;
@property (nonatomic, retain) NSString *RESOURCE_FOLDER_PATH;


- (void) createViewDeckController;

@end

