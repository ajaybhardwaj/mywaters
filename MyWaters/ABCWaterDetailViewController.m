//
//  ABCWaterDetailViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ABCWaterDetailViewController.h"

@implementation ABCWaterDetailViewController



//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwaters_detail_options.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
    self.title = @"ABC WATERS INFO";
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(255, 255, 255),UITextAttributeTextColor,[UIFont fontWithName:OPEN_SANS_REGULAR size:20.0f],UITextAttributeFont,[UIColor clearColor],UITextAttributeTextShadowColor,CGSizeZero,UITextAttributeTextShadowOffset, nil]];

    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(255, 255, 255),UITextAttributeTextColor,[UIFont fontWithName:OPEN_SANS_REGULAR size:20.0f],UITextAttributeFont,[UIColor clearColor],UITextAttributeTextShadowColor,CGSizeZero,UITextAttributeTextShadowOffset, nil]];

    UIImage *headerImage = [AuxilaryUIService imageWithColor:RGB(65,73,74) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:headerImage forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];

    
    [self createDemoAppControls];
}

@end
