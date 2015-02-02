//
//  FavouritesViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "FavouritesViewController.h"
#import "ViewControllerHelper.h"


@interface FavouritesViewController ()

@end

@implementation FavouritesViewController


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
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/favourites.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    
    favouritesDetailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    favouritesDetailButton.tag = 1;
    favouritesDetailButton.frame = CGRectMake(0, self.view.bounds.size.height-100, self.view.bounds.size.width, 50);
    [favouritesDetailButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:favouritesDetailButton];
    
    
    
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
