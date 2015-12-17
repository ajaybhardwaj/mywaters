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
@synthesize isUsingFacebookForSignIn = _isUsingFacebookForSignIn;
@synthesize facebookID,facebookName,facebookEmail,facebookImageUrl;



- (void) tempSkipFunction {
    
    appDelegate.IS_COMING_AFTER_LOGIN = YES;
    appDelegate.IS_SKIPPING_USER_LOGIN = YES;
    //    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
    [[ViewControllerHelper viewControllerHelper] enableThisController:HOME_CONTROLLER onCenter:YES withAnimate:YES];
}



//*************** Method To Hide Pass Field & Login Button

- (void) hidePassFieldLoginbutton {
    
    forgotPassButton.hidden = YES;
    passField.hidden = YES;
    passField.text = @"";
    loginButton.hidden = YES;
    
}


//*************** Method To Make Pass Field & Login Button Visible

- (void) unhidePassFieldLoginbutton {
    
    forgotPassButton.hidden = NO;
    passField.hidden = NO;
    loginButton.hidden = NO;
    
    loginBottomSectionView.hidden = YES;
}


//*************** Method To Hide Keypads

- (void) hideKeypads {
    
    [emailField resignFirstResponder];
    [passField resignFirstResponder];
    
    [UIView beginAnimations:@"emailField" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint viewPOS = self.view.center;
    
    if (IS_IPHONE_4_OR_LESS) {
        viewPOS.y = self.view.bounds.size.height-250;
    }
    else if (IS_IPHONE_5) {
        viewPOS.y = self.view.bounds.size.height-294;
    }
    else if (IS_IPHONE_6) {
        viewPOS.y = self.view.bounds.size.height-344;
    }
    else {
        viewPOS.y = self.view.bounds.size.height-377;
    }
    
    backgroundScrollView.center = viewPOS;
    [UIView commitAnimations];
}


//*************** Method To Move To Signup View

- (void) moveToSignUpView {
    
    SignUpViewController *viewObj = [[SignUpViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:YES];
    
}


//*************** Method To Move To Forgot Password View

- (void) moveToForgotPasswordView {
    
    ForgotPasswordViewController *viewObj = [[ForgotPasswordViewController alloc] init];
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
    
    if (IS_IPHONE_4_OR_LESS) {
        
        [UIView beginAnimations:@"emailField" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint viewPOS = self.view.center;
        viewPOS.y = self.view.bounds.size.height-250;
        backgroundScrollView.center = viewPOS;
        [UIView commitAnimations];
        
    }
    else {
        [UIView beginAnimations:@"emailField" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint viewPOS = self.view.center;
        viewPOS.y = self.view.bounds.size.height-294;
        backgroundScrollView.center = viewPOS;
        [UIView commitAnimations];
    }
}


//*************** Method To Validate Login Inputs

- (void) validateLoginParameters {
    
    if ([CommonFunctions hasConnectivity]) {
        
        if ([emailField.text length]==0) {
            [CommonFunctions showAlertView:nil title:nil msg:@"Required info missing." cancel:@"OK" otherButton:nil];
        }
        else if (![CommonFunctions NSStringIsValidEmail:emailField.text]) {
            [CommonFunctions showAlertView:nil title:nil msg:@"Provide  valid e-mail address." cancel:@"OK" otherButton:nil];
        }
        else if ([passField.text length]==0) {
            [CommonFunctions showAlertView:nil title:nil msg:@"Required info missing." cancel:@"OK" otherButton:nil];
        }
        else {
            
            [emailField resignFirstResponder];
            [passField resignFirstResponder];
            
            [UIView beginAnimations:@"emailField" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = self.view.center;
            
            if (IS_IPHONE_4_OR_LESS) {
                viewPOS.y = self.view.bounds.size.height-250;
            }
            else if (IS_IPHONE_5) {
                viewPOS.y = self.view.bounds.size.height-294;
            }
            else if (IS_IPHONE_6) {
                viewPOS.y = self.view.bounds.size.height-344;
            }
            else {
                viewPOS.y = self.view.bounds.size.height-377;
            }
            
            backgroundScrollView.center = viewPOS;
            [UIView commitAnimations];
            
            [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
            
            NSMutableArray *parameters = [[NSMutableArray alloc] init];
            NSMutableArray *values = [[NSMutableArray alloc] init];
            
            
            [parameters addObject:@"Email"];
            [values addObject:emailField.text];
            
            
            [parameters addObject:@"Password"];
            [values addObject:passField.text];
            
            [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,LOGIN_API_URL]];
        }
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Connection error. Check your internet connection." msg:nil cancel:@"OK" otherButton:nil];
    }
}


//*************** Method To Go To Facebook App For Signup

- (void) getFacebookDetailsForLogin {
    
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions:[NSArray arrayWithObjects:@"public_profile",@"email", nil] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            DebugLog(@"%@---%@--Process error",result,[error description]);
        } else if (result.isCancelled) {
            DebugLog(@"Facebook Cancelled");
        } else {
            
            DebugLog(@"%@---Logged in",result);
            
            if ([FBSDKAccessToken currentAccessToken]) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture.width(800).height(800), email, name"}]
                 
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                     if (!error) {
                         
                         DebugLog(@"%@",result);
                         
                         [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
                         
                         NSMutableArray *parameters = [[NSMutableArray alloc] init];
                         NSMutableArray *values = [[NSMutableArray alloc] init];
                         
                         facebookID = [result objectForKey:@"id"];
                         facebookName = [result objectForKey:@"name"];
                         facebookEmail = [result objectForKey:@"email"];
                         facebookImageUrl = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
                         
                         [parameters addObject:@"Email"];
                         [values addObject:[result objectForKey:@"email"]];
                         
                         [parameters addObject:@"FacebookID"];
                         [values addObject:[result objectForKey:@"id"]];
                         
                         [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,LOGIN_API_URL]];
                         
                     }
                 }];
            }
        }
    }];
    
}


//*************** Method For Creating Login UI

- (void) createLoginUI {
    
    UIImageView *topVolleyView = [[UIImageView alloc] initWithFrame:CGRectMake(backgroundScrollView.bounds.size.width/2 - 75, 30, 150, 213)];
    [topVolleyView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/login_top_volley.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [backgroundScrollView addSubview:topVolleyView];
    
    
    facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton setTitle:@"CONNECT VIA FACEBOOK" forState:UIControlStateNormal];
    [facebookButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    facebookButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    facebookButton.tag = 1;
    facebookButton.frame = CGRectMake(10, topVolleyView.frame.origin.y+topVolleyView.bounds.size.height+20, backgroundScrollView.bounds.size.width-20, 40);
    [facebookButton setBackgroundColor:RGB(45, 72, 166)];
    [facebookButton addTarget:self action:@selector(getFacebookDetailsForLogin) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:facebookButton];
    
    UIImageView *fbIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 7.5, 25, 25)];
    [fbIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_facebook.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [facebookButton addSubview:fbIcon];
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, facebookButton.frame.origin.y+facebookButton.bounds.size.height+10, backgroundScrollView.bounds.size.width-20, 40)];
    emailField.textColor = RGB(61, 71, 94);
    emailField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    emailField.leftViewMode = UITextFieldViewModeAlways;
    emailField.borderStyle = UITextBorderStyleNone;
    emailField.textAlignment=NSTextAlignmentLeft;
    [emailField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    emailField.placeholder=@"Email *";
    [backgroundScrollView addSubview:emailField];
    emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailField.delegate = self;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    [emailField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    //    emailField.backgroundColor = [UIColor whiteColor];
    emailField.returnKeyType = UIReturnKeyNext;
    [emailField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    emailField.tag = 1;
    
    passField = [[UITextField alloc] initWithFrame:CGRectMake(10, emailField.frame.origin.y+emailField.bounds.size.height+10, backgroundScrollView.bounds.size.width-20, 40)];
    passField.textColor = RGB(61, 71, 94);
    passField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    passField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    passField.leftViewMode = UITextFieldViewModeAlways;
    passField.borderStyle = UITextBorderStyleNone;
    passField.textAlignment=NSTextAlignmentLeft;
    [passField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    passField.secureTextEntry = YES;
    passField.placeholder=@"Password *";
    [backgroundScrollView addSubview:passField];
    passField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passField.delegate = self;
    [passField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    //    passField.backgroundColor = [UIColor whiteColor];
    passField.returnKeyType = UIReturnKeyDone;
    [passField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    passField.tag = 2;
    
    
    
    //Temp Field Data
    //    emailField.text = @"ajay@iappsasia.com";
    //    passField.text = @"M123456@";
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    loginButton.tag = 3;
    loginButton.frame = CGRectMake(10, passField.frame.origin.y+passField.bounds.size.height+20, backgroundScrollView.bounds.size.width-20, 40);
    [loginButton addTarget:self action:@selector(validateLoginParameters) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundColor:RGB(68, 78, 98)];
    [backgroundScrollView addSubview:loginButton];
    
    
    signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signupButton setTitleColor:RGB(61, 71, 94) forState:UIControlStateNormal];
    signupButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13];
    signupButton.tag = 6;
    signupButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    signupButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    signupButton.frame = CGRectMake(10, loginButton.frame.origin.y+loginButton.bounds.size.height+10, backgroundScrollView.bounds.size.width/2, 20);
    [signupButton addTarget:self action:@selector(moveToSignUpView) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:signupButton];
    
    
    forgotPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgotPassButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
    [forgotPassButton setTitleColor:RGB(61, 71, 94) forState:UIControlStateNormal];
    forgotPassButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13];
    forgotPassButton.tag = 2;
    forgotPassButton.titleLabel.textAlignment = NSTextAlignmentRight;
    forgotPassButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgotPassButton.frame = CGRectMake(backgroundScrollView.bounds.size.width/2-10, loginButton.frame.origin.y+loginButton.bounds.size.height+10, backgroundScrollView.bounds.size.width/2, 20);
    [forgotPassButton addTarget:self action:@selector(moveToForgotPasswordView) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:forgotPassButton];
    
    
    skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [skipButton setTitle:@"SKIP" forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    skipButton.tag = 5;
    [skipButton setBackgroundColor:RGB(205, 208, 215)];
    skipButton.frame = CGRectMake(10, forgotPassButton.frame.origin.y+forgotPassButton.bounds.size.height+30, backgroundScrollView.bounds.size.width-20, 40);
    // Temp Action For Skip Button
    [skipButton addTarget:self action:@selector(tempSkipFunction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:skipButton];
    
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    
    if (IS_IPHONE_4_OR_LESS) {
        backgroundScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 580);
    }
    
    
    removeKeypadsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    removeKeypadsButton.frame = CGRectMake(0, 0, backgroundScrollView.bounds.size.width, backgroundScrollView.bounds.size.height);
    [removeKeypadsButton addTarget:self action:@selector(hideKeypads) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:removeKeypadsButton];
    [backgroundScrollView sendSubviewToBack:removeKeypadsButton];
}



//*************** Method For Checking Email Field Text Length To Change UI

- (void) emailFieldTextChange {
    
    if ([emailField.text length] == 0) {
        
        loginBottomSectionView.hidden = NO;
        
        [UIView beginAnimations:@"emailField" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint loginBottomSectionPos = self.view.center;
        loginBottomSectionPos.y = loginButton.frame.origin.y+80;
        loginBottomSectionView.center = loginBottomSectionPos;
        [UIView commitAnimations];
        
        [self performSelector:@selector(hidePassFieldLoginbutton) withObject:nil afterDelay:0.4];
        
    }
    else {
        
        
        [UIView beginAnimations:@"emailField" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint loginBottomSectionPos = self.view.center;
        loginBottomSectionPos.y = loginButton.frame.origin.y+225;
        loginBottomSectionView.center = loginBottomSectionPos;
        [UIView commitAnimations];
        
        [self performSelector:@selector(unhidePassFieldLoginbutton) withObject:nil afterDelay:0.3];
    }
}


//*************** Method For Creating New Login UI

- (void) newLoginUI {
    
    //    UIImageView *topVolleyView = [[UIImageView alloc] initWithFrame:CGRectMake(backgroundScrollView.bounds.size.width/2 - 75, 30, 150, 213)];
    UIImageView *topVolleyView = [[UIImageView alloc] initWithFrame:CGRectMake(backgroundScrollView.bounds.size.width/2 - 50, 40, 100, 142)];
    [topVolleyView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/login_top_volley.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [backgroundScrollView addSubview:topVolleyView];
    
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, topVolleyView.frame.origin.y+topVolleyView.bounds.size.height+20, backgroundScrollView.bounds.size.width-20, 40)];
    emailField.textColor = RGB(61, 71, 94);
    emailField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    emailField.leftViewMode = UITextFieldViewModeAlways;
    emailField.borderStyle = UITextBorderStyleNone;
    emailField.textAlignment=NSTextAlignmentLeft;
    [emailField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    emailField.placeholder=@"Enter email *";
    [backgroundScrollView addSubview:emailField];
    emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailField.delegate = self;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    [emailField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    emailField.returnKeyType = UIReturnKeyNext;
    [emailField addTarget:self action:@selector(emailFieldTextChange) forControlEvents:UIControlEventEditingChanged];
    [emailField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    emailField.tag = 1;
    
    passField = [[UITextField alloc] initWithFrame:CGRectMake(10, emailField.frame.origin.y+emailField.bounds.size.height+10, backgroundScrollView.bounds.size.width-20, 40)];
    passField.textColor = RGB(61, 71, 94);
    passField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    passField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    passField.leftViewMode = UITextFieldViewModeAlways;
    passField.borderStyle = UITextBorderStyleNone;
    passField.textAlignment=NSTextAlignmentLeft;
    [passField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    passField.secureTextEntry = YES;
    passField.placeholder=@"Enter password *";
    [backgroundScrollView addSubview:passField];
    passField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passField.delegate = self;
    [passField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    passField.returnKeyType = UIReturnKeyDone;
    [passField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    passField.tag = 2;
    passField.hidden = YES;
    
    forgotPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgotPassButton setTitle:@"Forgot password?" forState:UIControlStateNormal];
    [forgotPassButton setTitleColor:RGB(61, 71, 94) forState:UIControlStateNormal];
    forgotPassButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    forgotPassButton.tag = 2;
    forgotPassButton.titleLabel.textAlignment = NSTextAlignmentRight;
    forgotPassButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgotPassButton.frame = CGRectMake(backgroundScrollView.bounds.size.width/2-10, passField.frame.origin.y+passField.bounds.size.height+15, backgroundScrollView.bounds.size.width/2, 20);
    [forgotPassButton addTarget:self action:@selector(moveToForgotPasswordView) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:forgotPassButton];
    forgotPassButton.hidden = YES;
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"LOG IN" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    loginButton.tag = 3;
    loginButton.frame = CGRectMake(10, forgotPassButton.frame.origin.y+forgotPassButton.bounds.size.height+20, backgroundScrollView.bounds.size.width-20, 40);
    [loginButton addTarget:self action:@selector(validateLoginParameters) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setBackgroundColor:RGB(68, 78, 98)];
    [backgroundScrollView addSubview:loginButton];
    loginButton.hidden = YES;
    
    
    loginBottomSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, emailField.frame.origin.y+emailField.bounds.size.height, backgroundScrollView.bounds.size.width, backgroundScrollView.bounds.size.height-emailField.frame.origin.y-20)];
    loginBottomSectionView.backgroundColor = [UIColor clearColor];
    [backgroundScrollView addSubview:loginBottomSectionView];
    loginBottomSectionView.userInteractionEnabled = YES;
    
    UILabel *orLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, loginBottomSectionView.bounds.size.width, 20)];
    orLabel.text = @"OR";
    orLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    orLabel.backgroundColor = [UIColor clearColor];
    orLabel.textAlignment = NSTextAlignmentCenter;
    [loginBottomSectionView addSubview:orLabel];
    
    
    facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton setTitle:@"CONNECT VIA FACEBOOK" forState:UIControlStateNormal];
    [facebookButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    facebookButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    facebookButton.tag = 1;
    facebookButton.frame = CGRectMake(10, orLabel.frame.origin.y+orLabel.bounds.size.height+15, backgroundScrollView.bounds.size.width-20, 40);
    [facebookButton setBackgroundColor:RGB(45, 72, 166)];
    [facebookButton addTarget:self action:@selector(getFacebookDetailsForLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginBottomSectionView addSubview:facebookButton];
    
    UIImageView *fbIcon = [[UIImageView alloc] initWithFrame:CGRectMake(20, 7.5, 25, 25)];
    [fbIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_facebook.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [facebookButton addSubview:fbIcon];
    
    
    skipButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [skipButton setTitleColor:RGB(61, 71, 94) forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    skipButton.tag = 5;
    skipButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    skipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    skipButton.frame = CGRectMake(10, backgroundScrollView.bounds.size.height-50, backgroundScrollView.bounds.size.width/2-10, 30);
    [skipButton addTarget:self action:@selector(tempSkipFunction) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:skipButton];
    
    signupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signupButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    [signupButton setTitleColor:RGB(61, 71, 94) forState:UIControlStateNormal];
    signupButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    signupButton.tag = 6;
    signupButton.titleLabel.textAlignment = NSTextAlignmentRight;
    signupButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    signupButton.frame = CGRectMake(backgroundScrollView.bounds.size.width/2, backgroundScrollView.bounds.size.height-50, backgroundScrollView.bounds.size.width/2-10, 30);
    [signupButton addTarget:self action:@selector(moveToSignUpView) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:signupButton];
    
    removeKeypadsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    removeKeypadsButton.frame = CGRectMake(0, 0, backgroundScrollView.bounds.size.width, backgroundScrollView.bounds.size.height);
    [removeKeypadsButton addTarget:self action:@selector(hideKeypads) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:removeKeypadsButton];
    [backgroundScrollView sendSubviewToBack:removeKeypadsButton];
}


# pragma mark - FBLoginViewDelegate Methods

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
    
    DebugLog(@"User name - %@",user);
}


- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    DebugLog(@"You are logged in");
    
}


- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    
    DebugLog(@"You are logged out");
}


- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    
    NSString *alertMessage,*alertTitle;
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook Error";
        alertMessage = [FBErrorUtility userMessageForError:error];
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        DebugLog(@"User Cancelled Login");
    }
    else {
        alertTitle = @"Something went wrong";
        alertMessage = @"Please try later.";
        DebugLog(@"Unexpected error: %@",error.description);
    }
    
    if (alertMessage) {
        [CommonFunctions showAlertView:nil title:alertTitle msg:alertMessage cancel:@"OK" otherButton:nil];
    }
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    DebugLog(@"%@--%@",responseString,[[responseString JSONValue] objectForKey:@"AccessToken"]);
    [CommonFunctions dismissGlobalHUD];
    //    [appDelegate.hud hide:YES];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [[SharedObject sharedClass] savePUBUserData:[responseString JSONValue]];
        
        if ([[[[responseString JSONValue] objectForKey:@"UserProfile"] objectForKey:@"IsEmailVerified"] intValue] ==  true) {
            
            appDelegate.IS_COMING_AFTER_LOGIN = YES;
            
            // Commented out to stop showing menu when login Asked By Salaman
            //            [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
            [[ViewControllerHelper viewControllerHelper] enableThisController:HOME_CONTROLLER onCenter:YES withAnimate:YES];
            
        }
        else {
            
            OTPViewController *viewObj = [[OTPViewController alloc] init];
            viewObj.emailStringForVerification = emailField.text;
            viewObj.isValidatingEmail = YES;
            viewObj.isResettingPassword = NO;
            [self.navigationController pushViewController:viewObj animated:YES];
        }
        
        
    }
    else if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == false) {
        
        if ([[[responseString JSONValue] objectForKey:API_STATUS_CODE] intValue] == 1003) {
            SignUpViewController *viewObj = [[SignUpViewController alloc] init];
            viewObj.facebookIDStringFromLogin = facebookID;
            viewObj.facebookEmailIDFromLogin = facebookEmail;
            viewObj.facebookImageUrlFromLogin = facebookImageUrl;
            viewObj.facebookNameStringFromLogin = facebookName;
            viewObj.isFacebookDataFetchInLogin = YES;
            [self.navigationController pushViewController:viewObj animated:YES];
        }
        else {
            [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
        }
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:[error description] msg:nil cancel:@"OK" otherButton:nil];
    [CommonFunctions dismissGlobalHUD];
    //    [appDelegate.hud hide:YES];
}


# pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (IS_IPHONE_4_OR_LESS) {
        
        if (textField==emailField || textField==passField) {
            
            [UIView beginAnimations:@"emailField" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = self.view.center;
            viewPOS.y = self.view.bounds.size.height-400;
            backgroundScrollView.center = viewPOS;
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
            
            //        if (IS_IPHONE_4_OR_LESS) {
            viewPOS.y = self.view.bounds.size.height-250;
            //        }
            //        else if (IS_IPHONE_5) {
            //            viewPOS.y = self.view.bounds.size.height-294;
            //        }
            //        else if (IS_IPHONE_6) {
            //            viewPOS.y = self.view.bounds.size.height-344;
            //        }
            //        else {
            //            viewPOS.y = self.view.bounds.size.height-377;
            //        }
            
            backgroundScrollView.center = viewPOS;
            [UIView commitAnimations];
        }
        
        [self validateLoginParameters];
    }
    return YES;
}



# pragma mark - View Lifecycle Methods

- (void) viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationController setNavigationBarHidden:YES];
    
    
    
    
    backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, self.view.bounds.size.height+20)];
    backgroundScrollView.showsHorizontalScrollIndicator = NO;
    backgroundScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backgroundScrollView];
    backgroundScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    
    UIImageView *bgView = [[UIImageView alloc] init];
    if (IS_IPHONE_4_OR_LESS) {
        bgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 580);
    }
    else {
        bgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    [bgView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/image_background.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [backgroundScrollView addSubview:bgView];
    
    
    [self newLoginUI];
}

- (void) viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [CommonFunctions googleAnalyticsTracking:@"Page: Login View"];
    //    emailField.text = @"";
    //    passField.text = @"";
    
    //    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //
    //    if ([prefs valueForKey:@"userEmail"] != NULL) {
    //        emailField.text = [prefs valueForKey:@"userEmail"];
    //    }
    //    else {
    //        emailField.text = @"";
    //    }
    //    if ([prefs valueForKey:@"userPassword"] != NULL) {
    //        passField.text = [prefs valueForKey:@"userPassword"];
    //    }
    //    else {
    //        passField.text = @"";
    //    }
    
    [appDelegate.locationManager startUpdatingLocation];
    
    if (appDelegate.IS_RELAUNCHING_APP) {
        
        appDelegate.IS_RELAUNCHING_APP = NO;
        
        if ([[[SharedObject sharedClass] getPUBUserSavedDataValue:@"AccessToken"] length] !=0) {
            appDelegate.IS_COMING_AFTER_LOGIN = YES;
            
            //            [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
            [[ViewControllerHelper viewControllerHelper] enableThisController:HOME_CONTROLLER onCenter:YES withAnimate:YES];
            //            [self validateLoginParameters];
        }
    }
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
