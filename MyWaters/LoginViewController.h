//
//  LoginViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 9/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SignUpViewController.h"
#import "OTPViewController.h"
#import "ForgotPasswordViewController.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate> {
    
    AppDelegate *appDelegate;
    
    UIButton *facebookButton,*loginButton,*forgotPassButton,*skipButton,*signupButton;
    UITextField *emailField,*passField;
    
    UIScrollView *backgroundScrollView;
    
    NSString *facebookIDString;
}
@property (assign) bool isUsingFacebookForSignIn;

@end
