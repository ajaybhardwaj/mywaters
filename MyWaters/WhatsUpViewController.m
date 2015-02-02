//
//  WhatsUpViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "WhatsUpViewController.h"
#import "ViewControllerHelper.h"


@interface WhatsUpViewController ()

@end

@implementation WhatsUpViewController
@synthesize isNotWhatsUpController;


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}

//*************** Demo App Controls Action Handler

- (void) handleDemoControls:(id) sender {
    
    UIButton *button = (id) sender;
    
    if (button.tag==1) {
        [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/whatsup_feed.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else if (button.tag==2) {
        [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/whatsup_explore.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
}



//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/whatsup_feed.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    
    feedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    feedButton.tag = 1;
    [feedButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feedButton];
    
    exploreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exploreButton.tag = 2;
    [exploreButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exploreButton];
    
    if (IS_IPHONE_4_OR_LESS) {
        feedButton.frame = CGRectMake(self.view.bounds.size.width/2-90, 5, 90, 25);
        exploreButton.frame = CGRectMake(self.view.bounds.size.width/2, 5, 90, 25);
    }
    else if (IS_IPHONE_5) {
        feedButton.frame = CGRectMake(self.view.bounds.size.width/2-85, 5, 85, 25);
        exploreButton.frame = CGRectMake(self.view.bounds.size.width/2, 5, 85, 25);
    }
    else if (IS_IPHONE_6) {
        feedButton.frame = CGRectMake(self.view.bounds.size.width/2-100, 5, 100, 35);
        exploreButton.frame = CGRectMake(self.view.bounds.size.width/2, 5, 100, 35);
    }
    else if (IS_IPHONE_6P) {
        feedButton.frame = CGRectMake(self.view.bounds.size.width/2-110, 5, 110, 45);
        exploreButton.frame = CGRectMake(self.view.bounds.size.width/2, 5, 110, 45);
    }
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    // -- Right Bar Button Item
    if (!isNotWhatsUpController) {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
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
