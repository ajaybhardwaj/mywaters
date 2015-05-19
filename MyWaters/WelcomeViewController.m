//
//  WelcomeViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 9/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController



//*************** Method To Move To Log In or Sign Up Views

- (void) handleLogInSignUpActions:(id) sender {
    
    UIButton *button = (id) sender;
    
    if (button.tag==1) {
        
        // Temp Action For Skip Button
        appDelegate.IS_COMING_AFTER_LOGIN = YES;
        
        [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
        [[ViewControllerHelper viewControllerHelper] enableThisController:HOME_CONTROLLER onCenter:YES withAnimate:YES];

    }
    else if (button.tag==2) {
        LoginViewController *viewObj = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (button.tag==3) {
        SignUpViewController *viewObj = [[SignUpViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [bgView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/welcome_background.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:bgView];

    
    skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [skipButton setTitle:@"or skip for now" forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:16];
    skipButton.tag = 1;
    skipButton.frame = CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 30);
    [skipButton addTarget:self action:@selector(handleLogInSignUpActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipButton];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    [loginButton setTitleColor:RGB(32, 51, 76) forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    loginButton.tag = 2;
    loginButton.frame = CGRectMake(0, skipButton.frame.origin.y - 60, self.view.bounds.size.width, 45);
    [loginButton setBackgroundColor:RGB(205, 208, 213)];
    [loginButton addTarget:self action:@selector(handleLogInSignUpActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];

    signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signUpButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signUpButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    signUpButton.tag = 3;
    signUpButton.frame = CGRectMake(0, loginButton.frame.origin.y - 55, self.view.bounds.size.width, 45);
    [signUpButton setBackgroundColor:RGB(67, 79, 96)];
    [signUpButton addTarget:self action:@selector(handleLogInSignUpActions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpButton];
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = YES;
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
