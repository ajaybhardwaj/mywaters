//
//  ABCWaterDetailViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ABCWaterDetailViewController.h"
#import "ARViewController.h"

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


- (void) moveToARView {
    
    ARViewController *viewObj = [[ARViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:NO];
//    [self.navigationController presentViewController:viewObj animated:NO completion:nil];
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    
    self.title = @"ABC Waters";
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:nil withIconName:@"icn_3dots"]];

    
    [self createDemoAppControls];
    
    UIButton *moveToArView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moveToArView.frame = CGRectMake(40, 200, 200, 200);
    moveToArView.backgroundColor = [UIColor redColor];
    [moveToArView addTarget:self action:@selector(moveToARView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moveToArView];
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = NO;
}


@end
