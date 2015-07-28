//
//  LoginViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 9/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


//*************** Method To Move To Login View After Spalsh Screen

- (void) moveToSignUpView {
    
    SignUpViewController *viewObj = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:YES];
    
}


//*************** Method To Detect Swipe Gesture

- (void) swipedScreen:(UISwipeGestureRecognizer*)gesture {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


//*************** Method To Move Back To Parent View

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Submit Login Inputs

- (void) submitLoginCredentials {
    
    // Submit Login Details
    [emailField resignFirstResponder];
    [passField resignFirstResponder];
    
//    if (IS_IPHONE_4_OR_LESS) {
    
        [UIView beginAnimations:@"emailField" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint viewPOS = self.view.center;
        viewPOS.y = self.view.bounds.size.height-284;
        self.view.center = viewPOS;
        [UIView commitAnimations];
        
//    }
}


//*************** Method To Validate Login Inputs

- (void) validateLoginParameters {
    
//    if ([emailField.text length]==0) {
//        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Email is mandatory." cancel:@"OK" otherButton:nil];
//    }
//    else if (![CommonFunctions NSStringIsValidEmail:emailField.text]) {
//        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Please provide a valid email." cancel:@"OK" otherButton:nil];
//    }
//    else if ([passField.text length]==0) {
//        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Password is mandatory." cancel:@"OK" otherButton:nil];
//    }
//    else {
//        [self submitLoginCredentials];
    
        // After Validation call it.
        [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
        [[ViewControllerHelper viewControllerHelper] enableThisController:HOME_CONTROLLER onCenter:YES withAnimate:YES];

        appDelegate.IS_COMING_AFTER_LOGIN = YES;
//    }
}


# pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
//    if (IS_IPHONE_4_OR_LESS) {
    
        if (textField==emailField || textField==passField) {
            
            [UIView beginAnimations:@"emailField" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = self.view.center;
            viewPOS.y = self.view.bounds.size.height-400;
            self.view.center = viewPOS;
            [UIView commitAnimations];
        }
//    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField==emailField) {
        [passField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
        
//        if (IS_IPHONE_4_OR_LESS) {
        
            [UIView beginAnimations:@"emailField" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = self.view.center;
            viewPOS.y = self.view.bounds.size.height-284;
            self.view.center = viewPOS;
            [UIView commitAnimations];
            
//        }
    }
    return YES;
}


# pragma mark - View Lifecycle Methods

- (void) viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.navigationController.navigationBar.hidden = YES;

    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [bgView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/image_background.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:bgView];
    
    
    skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [skipButton setTitle:@"SKIP" forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    skipButton.tag = 5;
    [skipButton setBackgroundColor:RGB(205, 208, 215)];
    skipButton.frame = CGRectMake(10, self.view.bounds.size.height-50, self.view.bounds.size.width-20, 40);
    // Temp Action For Skip Button
    [skipButton addTarget:self action:@selector(validateLoginParameters) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipButton];
    
    
    
    signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signupButton setTitleColor:RGB(61, 71, 94) forState:UIControlStateNormal];
    signupButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13];
    signupButton.tag = 6;
    signupButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    signupButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    signupButton.frame = CGRectMake(10, skipButton.frame.origin.y-60, self.view.bounds.size.width/2, 20);
    [signupButton addTarget:self action:@selector(moveToSignUpView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signupButton];
    
    
    forgotPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgotPassButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
    [forgotPassButton setTitleColor:RGB(61, 71, 94) forState:UIControlStateNormal];
    forgotPassButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13];
    forgotPassButton.tag = 2;
    forgotPassButton.titleLabel.textAlignment = NSTextAlignmentRight;
    forgotPassButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgotPassButton.frame = CGRectMake(self.view.bounds.size.width/2-10, skipButton.frame.origin.y-60, self.view.bounds.size.width/2, 20);
    [self.view addSubview:forgotPassButton];
    
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    loginButton.tag = 3;
    loginButton.frame = CGRectMake(10, forgotPassButton.frame.origin.y-50, self.view.bounds.size.width-20, 40);
    [loginButton addTarget:self action:@selector(validateLoginParameters) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundColor:RGB(68, 78, 98)];
    [self.view addSubview:loginButton];
    
    
    passField = [[UITextField alloc] initWithFrame:CGRectMake(10, loginButton.frame.origin.y-50, self.view.bounds.size.width-20, 40)];
    passField.textColor = RGB(61, 71, 94);
    passField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    passField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    passField.leftViewMode = UITextFieldViewModeAlways;
    passField.borderStyle = UITextBorderStyleNone;
    passField.textAlignment=NSTextAlignmentLeft;
    [passField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    passField.secureTextEntry = YES;
    passField.placeholder=@"Password *";
    [self.view addSubview:passField];
    passField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passField.delegate = self;
    [passField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//    passField.backgroundColor = [UIColor whiteColor];
    passField.returnKeyType = UIReturnKeyDone;
    [passField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    passField.tag = 2;
    
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, passField.frame.origin.y-40, self.view.bounds.size.width-20, 40)];
    emailField.textColor = RGB(61, 71, 94);
    emailField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    emailField.leftViewMode = UITextFieldViewModeAlways;
    emailField.borderStyle = UITextBorderStyleNone;
    emailField.textAlignment=NSTextAlignmentLeft;
    [emailField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    emailField.placeholder=@"Email *";
    [self.view addSubview:emailField];
    emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailField.delegate = self;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    [emailField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//    emailField.backgroundColor = [UIColor whiteColor];
    emailField.returnKeyType = UIReturnKeyNext;
    [emailField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    emailField.tag = 1;
    
    
    facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton setTitle:@"CONNECT VIA FACEBOOK" forState:UIControlStateNormal];
    [facebookButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    facebookButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    facebookButton.tag = 1;
    facebookButton.frame = CGRectMake(10, emailField.frame.origin.y-50, self.view.bounds.size.width-20, 40);
    [facebookButton setBackgroundColor:RGB(45, 72, 166)];
    [self.view addSubview:facebookButton];
    
    
    UIImageView *fbIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 7.5, 25, 25)];
    [fbIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_facebook.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [facebookButton addSubview:fbIcon];
    
    
    UIImageView *topVolleyView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 75, facebookButton.frame.origin.y-230, 150, 213)];
    [topVolleyView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/login_top_volley.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:topVolleyView];

    
    
//    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setTitle:@"BACK" forState:UIControlStateNormal];
//    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
//    backButton.tag = 4;
//    backButton.frame = CGRectMake(0, loginButton.frame.origin.y+loginButton.bounds.size.height+15, self.view.bounds.size.width, 45);
//    [backButton addTarget:self action:@selector(pop2Dismiss:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton setBackgroundColor:RGB(83, 83, 83)];
//    [self.view addSubview:backButton];
    
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = YES;
    self.navigationItem.hidesBackButton = YES;
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
