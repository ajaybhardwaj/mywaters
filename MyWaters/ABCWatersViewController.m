//
//  ABCWatersViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 23/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ABCWatersViewController.h"
#import "ViewControllerHelper.h"


@interface ABCWatersViewController ()

@end

@implementation ABCWatersViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


// Temp Method

- (void) moveToABCWaterDetails {
    
    ABCWaterDetailViewController *viewObj = [[ABCWaterDetailViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:NO];
    
}

//*************** Demo App Controls Action Handler

- (void) handleDemoControls:(id) sender {
    
    UIButton *button = (id) sender;
    
    if (button.tag==1) {
        [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwaters_grid.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        [self.navigationItem setRightBarButtonItem:nil];
    }
    else if (button.tag==2) {
        [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwaters_list.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:nil withIconName:@"icn_filter"]];
    }
}



//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwaters_grid.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    
    gridButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    gridButton.tag = 1;
    [gridButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gridButton];
    
    listButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    listButton.tag = 2;
    [listButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listButton];
    
    if (IS_IPHONE_4_OR_LESS) {
        gridButton.frame = CGRectMake(self.view.bounds.size.width/2-90, 5, 90, 25);
        listButton.frame = CGRectMake(self.view.bounds.size.width/2, 5, 90, 25);
    }
    else if (IS_IPHONE_5) {
        gridButton.frame = CGRectMake(self.view.bounds.size.width/2-85, 5, 85, 25);
        listButton.frame = CGRectMake(self.view.bounds.size.width/2, 5, 85, 25);
    }
    else if (IS_IPHONE_6) {
        gridButton.frame = CGRectMake(self.view.bounds.size.width/2-100, 5, 100, 35);
        listButton.frame = CGRectMake(self.view.bounds.size.width/2, 5, 100, 35);
    }
    else if (IS_IPHONE_6P) {
        gridButton.frame = CGRectMake(self.view.bounds.size.width/2-110, 5, 110, 45);
        listButton.frame = CGRectMake(self.view.bounds.size.width/2, 5, 110, 45);
    }
    
    
    UIButton *moveToABCWaterDetailsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moveToABCWaterDetailsButton.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-40);
    [moveToABCWaterDetailsButton addTarget:self action:@selector(moveToABCWaterDetails) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moveToABCWaterDetailsButton];
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    
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
