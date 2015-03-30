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
    
    [self createDemoAppControls];
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
