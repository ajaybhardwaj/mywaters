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
#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate,FBLoginViewDelegate> {
    
    AppDelegate *appDelegate;
    
    UIButton *facebookButton,*loginButton,*forgotPassButton,*skipButton,*signupButton;
    UITextField *emailField,*passField;
    
    UIScrollView *backgroundScrollView;
    
    NSString *facebookIDString;
    UIButton *removeKeypadsButton;
}
@property (assign) bool isUsingFacebookForSignIn;
@property (strong, nonatomic) FBLoginView *loginView;

@property (nonatomic, strong) NSString *facebookID,*facebookName,*facebookEmail,*facebookImageUrl;

@end
