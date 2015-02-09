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


//*************** Method To Detect Swipe Gesture

- (void) swipedScreen:(UISwipeGestureRecognizer*)gesture {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



# pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (IS_IPHONE_4_OR_LESS) {
        
        if (textField==emailField || textField==passField) {
            
            [UIView beginAnimations:@"emailField" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = self.view.center;
            viewPOS.y = self.view.bounds.size.height-300;
            self.view.center = viewPOS;
            [UIView commitAnimations];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField==emailField) {
        [passField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
        
        if (IS_IPHONE_4_OR_LESS) {
            
            [UIView beginAnimations:@"emailField" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = self.view.center;
            viewPOS.y = self.view.bounds.size.height-240;
            self.view.center = viewPOS;
            [UIView commitAnimations];
            
        }
    }
    return YES;
}


# pragma mark - View Lifecycle Methods

- (void) viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [bgView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/image_background.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:bgView];
    
    facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton setTitle:@"LOG IN VIA FACEBOOK" forState:UIControlStateNormal];
    [facebookButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    facebookButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    facebookButton.tag = 1;
    facebookButton.frame = CGRectMake(0, 40, self.view.bounds.size.width, 45);
    [facebookButton setBackgroundColor:RGB(45, 72, 166)];
    [self.view addSubview:facebookButton];
    
    
    UIImageView *fbIcon = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 25, 25)];
    [fbIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_facebook.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [facebookButton addSubview:fbIcon];
    
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, facebookButton.frame.origin.y+facebookButton.bounds.size.height+30, self.view.bounds.size.width, 40)];
    emailField.textColor = RGB(35, 35, 35);
    emailField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
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
    emailField.backgroundColor = [UIColor whiteColor];
    emailField.returnKeyType = UIReturnKeyNext;
    [emailField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    emailField.tag = 1;
    
    
    passField = [[UITextField alloc] initWithFrame:CGRectMake(0, emailField.frame.origin.y+emailField.bounds.size.height+1, self.view.bounds.size.width, 40)];
    passField.textColor = RGB(35, 35, 35);
    passField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
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
    passField.backgroundColor = [UIColor whiteColor];
    passField.returnKeyType = UIReturnKeyDone;
    [passField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    passField.tag = 2;
    
    
    forgotPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgotPassButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
    [forgotPassButton setTitleColor:RGB(22, 25, 62) forState:UIControlStateNormal];
    forgotPassButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    forgotPassButton.tag = 2;
    forgotPassButton.titleLabel.textAlignment = NSTextAlignmentRight;
    forgotPassButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgotPassButton.frame = CGRectMake(0, passField.frame.origin.y+passField.bounds.size.height+10, self.view.bounds.size.width-10, 20);
    [self.view addSubview:forgotPassButton];
    
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    [loginButton setTitleColor:RGB(32, 51, 76) forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    loginButton.tag = 3;
    loginButton.frame = CGRectMake(0, forgotPassButton.frame.origin.y+forgotPassButton.bounds.size.height+30, self.view.bounds.size.width, 45);
    [loginButton setBackgroundColor:RGB(205, 208, 213)];
    [self.view addSubview:loginButton];
    
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    //    self.navigationController.navigationBar.hidden = YES;
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
