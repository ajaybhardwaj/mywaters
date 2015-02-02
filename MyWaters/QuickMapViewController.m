//
//  QuickMapViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 27/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "QuickMapViewController.h"
#import "ViewControllerHelper.h"


@interface QuickMapViewController ()

@end

@implementation QuickMapViewController
@synthesize isNotQuickMapController;


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Demo App Controls Action Handler

- (void) handleDemoControls {
    
    if (isControlMaximize) {
        isControlMaximize = NO;
        [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/quickmap.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else if (!isControlMaximize) {
        isControlMaximize = YES;
        [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/quickmap_expanded.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
}



//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/quickmap.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    
    maximizeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [maximizeButton addTarget:self action:@selector(handleDemoControls) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:maximizeButton];
    
    if (IS_IPHONE_4_OR_LESS) {
        maximizeButton.frame = CGRectMake(self.view.bounds.size.width-55, self.view.bounds.size.height-110, 40, 40);
    }
    else if (IS_IPHONE_5) {
        maximizeButton.frame = CGRectMake(self.view.bounds.size.width-55, self.view.bounds.size.height-125, 40, 40);
    }
    else if (IS_IPHONE_6) {
        maximizeButton.frame = CGRectMake(self.view.bounds.size.width-65, self.view.bounds.size.height-135, 45, 45);
    }
    else if (IS_IPHONE_6P) {
        maximizeButton.frame = CGRectMake(self.view.bounds.size.width-75, self.view.bounds.size.height-145, 50, 50);
    }
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


# pragma mark - View Lifecycle Methods

- (void) viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    // -- Right Bar Button Item
    if (!isNotQuickMapController) {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    }
    else {
        self.title = @"QUICK MAP";
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGB(255, 255, 255),UITextAttributeTextColor,[UIFont fontWithName:OPEN_SANS_REGULAR size:20.0f],UITextAttributeFont,[UIColor clearColor],UITextAttributeTextShadowColor,CGSizeZero,UITextAttributeTextShadowOffset, nil]];
        UIImage *headerImage = [AuxilaryUIService imageWithColor:RGB(65,73,74) frame:CGRectMake(0, 0, 1, 1)];
        [[[self navigationController] navigationBar] setBackgroundImage:headerImage forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];

    }
    
    [self createDemoAppControls];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
