//
//  iPadHomeViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 8/12/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import "iPadHomeViewController.h"

@interface iPadHomeViewController ()

@end

@implementation iPadHomeViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    
    [appDelegate setShouldRotate:YES];
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
