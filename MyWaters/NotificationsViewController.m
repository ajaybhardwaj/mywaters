//
//  NotificationsViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "NotificationsViewController.h"
#import "ViewControllerHelper.h"


@interface NotificationsViewController ()

@end

@implementation NotificationsViewController



//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Demo App Controls Action Handler

- (void) handleDemoControls:(id) sender {
    
    UIButton *button = (id) sender;
    
    if (button.tag==1) {
        
    }
}



//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/notifications.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    
    detailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    detailButton.tag = 1;
    detailButton.frame = CGRectMake(0, self.view.bounds.size.height-100, self.view.bounds.size.width, 50);
    [detailButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailButton];
    
    
    
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:nil withIconName:@"icn_filter"]];

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