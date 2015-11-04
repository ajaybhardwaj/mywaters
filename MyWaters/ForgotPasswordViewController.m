//
//  ForgotPasswordViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 10/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ForgotPasswordViewController.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController


//*************** Method To Detect Swipe Gesture

- (void) swipedScreen:(UISwipeGestureRecognizer*)gesture {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


//*************** Method To Hide Keypads

- (void) hideAllKeypads {
    
    [emailField resignFirstResponder];
}


//*************** Method To Move Back To Parent View

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}



//*************** Method For Submitting Forgot Password Data

- (void) submitForgotPasswordRequest {
    
    [emailField resignFirstResponder];
    
    if ([CommonFunctions hasConnectivity]) {
        if ([emailField.text length]==0) {
            [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Email id is mandatory." cancel:@"OK" otherButton:nil];
        }
        else if (![CommonFunctions NSStringIsValidEmail:emailField.text]) {
            [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Please provide a valid email." cancel:@"OK" otherButton:nil];
        }
        else {
            
            [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
//            appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
//            appDelegate.hud.labelText = @"Loading...";
            
            NSMutableArray *parameters = [[NSMutableArray alloc] init];
            NSMutableArray *values = [[NSMutableArray alloc] init];
            
            [parameters addObject:@"VerificationMode"];
            [values addObject:@"4"];
            
            [parameters addObject:@"Email"];
            [values addObject:emailField.text];
            
            [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,VERIFICATION_API_URL]];
        }
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Sorry" msg:@"No internet Connectivity." cancel:@"OK" otherButton:nil];
    }
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    [CommonFunctions dismissGlobalHUD];
//    [appDelegate.hud hide:YES];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        OTPViewController *viewObj = [[OTPViewController alloc] init];
        viewObj.emailStringForVerification = emailField.text;
        viewObj.isResettingPassword = YES;
        viewObj.isValidatingEmail = NO;
        [self.navigationController pushViewController:viewObj animated:YES];
        
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


# pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
        
    }
}


# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UIImageView *bgView = [[UIImageView alloc] init];
    if (IS_IPHONE_4_OR_LESS) {
        bgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 580);
    }
    else {
        bgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    [bgView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/image_background.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:bgView];
    
    
    UIButton *hideKeypadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hideKeypadButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [hideKeypadButton addTarget:self action:@selector(hideAllKeypads) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hideKeypadButton];
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, self.view.bounds.size.width-20, 40)];
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
    emailField.returnKeyType = UIReturnKeyDefault;
    [emailField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    emailField.tag = 1;
    
    
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [submitButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    submitButton.tag = 1;
    submitButton.frame = CGRectMake(10, self.view.bounds.size.height-100, self.view.bounds.size.width-20, 40);
    [submitButton addTarget:self action:@selector(submitForgotPasswordRequest) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setBackgroundColor:RGB(68, 78, 98)];
    [self.view addSubview:submitButton];
    
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"BACK" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    backButton.frame = CGRectMake(10, self.view.bounds.size.height-45, self.view.bounds.size.width-20, 40);
    [backButton addTarget:self action:@selector(pop2Dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundColor:RGB(83, 83, 83)];
    [self.view addSubview:backButton];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    
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
