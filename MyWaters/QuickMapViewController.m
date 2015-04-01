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
    
    self.view.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Demo App Controls Action Handler

- (void) handleExpandingControls {
    
    if (isControlMaximize) {
        isControlMaximize = NO;
        optionsView.hidden = YES;
    }
    else if (!isControlMaximize) {
        isControlMaximize = YES;
        optionsView.hidden = NO;
    }
}



//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/quickmap.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    
    
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
    
    
    quickMap = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    quickMap.delegate = self;
    [self.view  addSubview:quickMap];
    
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(quickMap.userLocation.coordinate, 6000, 6000);
    viewRegion.span.longitudeDelta  = 0.005;
    viewRegion.span.latitudeDelta  = 0.005;
    
    maximizeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [maximizeButton addTarget:self action:@selector(handleExpandingControls) forControlEvents:UIControlEventTouchUpInside];
    [maximizeButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_expand.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    
    if (IS_IPHONE_4_OR_LESS) {
        maximizeButton.frame = CGRectMake(quickMap.bounds.size.width-55, quickMap.bounds.size.height-60, 40, 40);
    }
    else if (IS_IPHONE_5) {
        maximizeButton.frame = CGRectMake(quickMap.bounds.size.width-55, quickMap.bounds.size.height-65, 40, 40);
    }
    else if (IS_IPHONE_6) {
        maximizeButton.frame = CGRectMake(quickMap.bounds.size.width-65, quickMap.bounds.size.height-75, 45, 45);
    }
    else if (IS_IPHONE_6P) {
        maximizeButton.frame = CGRectMake(quickMap.bounds.size.width-75, quickMap.bounds.size.height-85, 50, 50);
    }
    [quickMap addSubview:maximizeButton];
    
    
    optionsView = [[UIView alloc] init];
    optionsView.backgroundColor = [UIColor clearColor];
    if (IS_IPHONE_4_OR_LESS) {
        optionsView.frame = CGRectMake(quickMap.bounds.size.width-55, maximizeButton.frame.origin.y-300, 40, 300);
    }
    else if (IS_IPHONE_5) {
        optionsView.frame = CGRectMake(quickMap.bounds.size.width-55, maximizeButton.frame.origin.y-300, 40, 300);
    }
    else if (IS_IPHONE_6) {
        optionsView.frame = CGRectMake(quickMap.bounds.size.width-65, maximizeButton.frame.origin.y-325, 45, 325);
    }
    else if (IS_IPHONE_6P) {
        optionsView.frame = CGRectMake(quickMap.bounds.size.width-75, maximizeButton.frame.origin.y-350, 50, 350);
    }
    [quickMap addSubview:optionsView];
    optionsView.hidden = YES;
    
    
    carButton = [UIButton buttonWithType:UIButtonTypeCustom];
    carButton.frame = CGRectMake(0, 10, optionsView.bounds.size.width, optionsView.bounds.size.width);
    [carButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_pub_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [optionsView addSubview:carButton];
    
    chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chatButton.frame = CGRectMake(0, carButton.frame.origin.y+carButton.bounds.size.height+18, optionsView.bounds.size.width, optionsView.bounds.size.width);
    [chatButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_userfeedback_submission_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [optionsView addSubview:chatButton];
    
    cloudButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cloudButton.frame = CGRectMake(0, chatButton.frame.origin.y+chatButton.bounds.size.height+18, optionsView.bounds.size.width, optionsView.bounds.size.width);
    [cloudButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainarea_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [optionsView addSubview:cloudButton];
    
    cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake(0, cloudButton.frame.origin.y+cloudButton.bounds.size.height+18, optionsView.bounds.size.width, optionsView.bounds.size.width);
    [cameraButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_cctv_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [optionsView addSubview:cameraButton];
    
    dropButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dropButton.frame = CGRectMake(0, cameraButton.frame.origin.y+cameraButton.bounds.size.height+18, optionsView.bounds.size.width, optionsView.bounds.size.width);
    [dropButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_big.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [optionsView addSubview:dropButton];
    

    //[self createDemoAppControls];
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    
    if (!isNotQuickMapController) {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    }
    else {
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(229,0,87) frame:CGRectMake(0, 0, 1, 1)];
        [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
        [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
        [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
        [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
        
        self.title = @"Quick Map";
        
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
        
    }
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
