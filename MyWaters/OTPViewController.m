//
//  OTPViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 28/9/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import "OTPViewController.h"

@interface OTPViewController ()

@end

@implementation OTPViewController
@synthesize emailStringForVerification;
@synthesize isResettingPassword,isValidatingEmail;



//*************** Method To Resign Keypad

- (void) removeKeypad {
    
    [otpField1 resignFirstResponder];
    [otpField2 resignFirstResponder];
    [otpField3 resignFirstResponder];
    [otpField4 resignFirstResponder];
    [otpField5 resignFirstResponder];
    [otpField6 resignFirstResponder];
}


//*************** Method To Submit OTP Code

- (void) submitOTPCode {
    
    if ([otpField1.text length] ==0 || [otpField2.text length] ==0 || [otpField3.text length] ==0 || [otpField4.text length] ==0 || [otpField5.text length] ==0 || [otpField6.text length] ==0) {
        
        [CommonFunctions showAlertView:nil title:nil msg:@"Please enter your six digit OTP code." cancel:@"OK" otherButton:nil];
    }
    else {
        
        [self removeKeypad];
        
        isVerifyingEmail = YES;
        isResendingOTP = NO;
        
        NSString *otpString = [NSString stringWithFormat:@"%@%@%@%@%@%@",otpField1.text,otpField2.text,otpField3.text,otpField4.text,otpField5.text,otpField6.text];
        
        appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
        appDelegate.hud.labelText = @"Loading...";
        
        NSMutableArray *parameters = [[NSMutableArray alloc] init];
        NSMutableArray *values = [[NSMutableArray alloc] init];
        
        if (isValidatingEmail) {
            [parameters addObject:@"VerificationMode"];
            [values addObject:@"1"];
        }
        else if (isResettingPassword) {
            [parameters addObject:@"VerificationMode"];
            [values addObject:@"2"];
        }
        
        
        [parameters addObject:@"Email"];
        [values addObject:emailStringForVerification];
        
        
        [parameters addObject:@"OTP"];
        [values addObject:otpString];
        
        [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,VERIFICATION_API_URL]];
    }
}



//*************** Method To Move Back To Parent View

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}



//*************** Method To Request OTP Code

- (void) requestNewOTPCode {
    
    if ([CommonFunctions hasConnectivity]) {
        isVerifyingEmail = NO;
        isResendingOTP = YES;
        
        appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
        appDelegate.hud.labelText = @"Loading...";
        
        NSMutableArray *parameters = [[NSMutableArray alloc] init];
        NSMutableArray *values = [[NSMutableArray alloc] init];
        
        if (isValidatingEmail) {
            [parameters addObject:@"VerificationMode"];
            [values addObject:@"3"];
        }
        else if (isResettingPassword) {
            [parameters addObject:@"VerificationMode"];
            [values addObject:@"4"];
        }
        
        
        [parameters addObject:@"Email"];
        [values addObject:emailStringForVerification];
        
        [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,VERIFICATION_API_URL]];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Sorry" msg:@"No internet connectivity." cancel:@"OK" otherButton:nil];
    }
}


//*************** Method To Create UI

- (void) createUI {
    
    instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width-20, 20)];
    instructionLabel.text = @"Kindly key in the OTP sent to your email.";
    instructionLabel.textColor = RGB(22, 25, 62);
    instructionLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    instructionLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:instructionLabel];
    
    otpField1 = [[UITextField alloc] initWithFrame:CGRectMake(10, instructionLabel.frame.origin.y+instructionLabel.bounds.size.height+10, self.view.bounds.size.width/6-8, 40)];
    otpField1.textColor = RGB(61, 71, 94);
    otpField1.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    otpField1.leftViewMode = UITextFieldViewModeAlways;
    otpField1.borderStyle = UITextBorderStyleNone;
    otpField1.textAlignment = NSTextAlignmentCenter;
    [otpField1 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:otpField1];
    otpField1.delegate = self;
    otpField1.keyboardType = UIKeyboardTypeNumberPad;
    otpField1.returnKeyType = UIReturnKeyNext;
    [otpField1 setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/otpline_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    otpField1.tag = 1;
    [[otpField1 valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    
    
    otpField2 = [[UITextField alloc] initWithFrame:CGRectMake(otpField1.frame.origin.x+otpField1.bounds.size.width+5, instructionLabel.frame.origin.y+instructionLabel.bounds.size.height+10, self.view.bounds.size.width/6-8, 40)];
    otpField2.textColor = RGB(61, 71, 94);
    otpField2.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    otpField2.leftViewMode = UITextFieldViewModeAlways;
    otpField2.borderStyle = UITextBorderStyleNone;
    otpField2.textAlignment = NSTextAlignmentCenter;
    [otpField2 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:otpField2];
    otpField2.delegate = self;
    otpField2.keyboardType = UIKeyboardTypeNumberPad;
    otpField2.returnKeyType = UIReturnKeyNext;
    [otpField2 setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/otpline_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    otpField2.tag = 2;
    [[otpField2 valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    
    
    
    otpField3 = [[UITextField alloc] initWithFrame:CGRectMake(otpField2.frame.origin.x+otpField2.bounds.size.width+5, instructionLabel.frame.origin.y+instructionLabel.bounds.size.height+10, self.view.bounds.size.width/6-8, 40)];
    otpField3.textColor = RGB(61, 71, 94);
    otpField3.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    otpField3.leftViewMode = UITextFieldViewModeAlways;
    otpField3.borderStyle = UITextBorderStyleNone;
    otpField3.textAlignment = NSTextAlignmentCenter;
    [otpField3 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:otpField3];
    otpField3.delegate = self;
    otpField3.keyboardType = UIKeyboardTypeNumberPad;
    otpField3.returnKeyType = UIReturnKeyNext;
    [otpField3 setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/otpline_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    otpField3.tag = 3;
    [[otpField3 valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    
    
    otpField4 = [[UITextField alloc] initWithFrame:CGRectMake(otpField3.frame.origin.x+otpField3.bounds.size.width+5, instructionLabel.frame.origin.y+instructionLabel.bounds.size.height+10, self.view.bounds.size.width/6-8, 40)];
    otpField4.textColor = RGB(61, 71, 94);
    otpField4.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    otpField4.leftViewMode = UITextFieldViewModeAlways;
    otpField4.borderStyle = UITextBorderStyleNone;
    otpField4.textAlignment = NSTextAlignmentCenter;
    [otpField4 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:otpField4];
    otpField4.delegate = self;
    otpField4.keyboardType = UIKeyboardTypeNumberPad;
    otpField4.returnKeyType = UIReturnKeyNext;
    [otpField4 setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/otpline_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    otpField4.tag = 4;
    [[otpField4 valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    
    
    otpField5 = [[UITextField alloc] initWithFrame:CGRectMake(otpField4.frame.origin.x+otpField4.bounds.size.width+5, instructionLabel.frame.origin.y+instructionLabel.bounds.size.height+10, self.view.bounds.size.width/6-8, 40)];
    otpField5.textColor = RGB(61, 71, 94);
    otpField5.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    otpField5.leftViewMode = UITextFieldViewModeAlways;
    otpField5.borderStyle = UITextBorderStyleNone;
    otpField5.textAlignment = NSTextAlignmentCenter;
    [otpField5 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:otpField5];
    otpField5.delegate = self;
    otpField5.keyboardType = UIKeyboardTypeNumberPad;
    otpField5.returnKeyType = UIReturnKeyNext;
    [otpField5 setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/otpline_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    otpField5.tag = 5;
    [[otpField5 valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    
    
    otpField6 = [[UITextField alloc] initWithFrame:CGRectMake(otpField5.frame.origin.x+otpField5.bounds.size.width+5, instructionLabel.frame.origin.y+instructionLabel.bounds.size.height+10, self.view.bounds.size.width/6-8, 40)];
    otpField6.textColor = RGB(61, 71, 94);
    otpField6.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    otpField6.leftViewMode = UITextFieldViewModeAlways;
    otpField6.borderStyle = UITextBorderStyleNone;
    otpField6.textAlignment = NSTextAlignmentCenter;
    [otpField6 setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:otpField6];
    otpField6.delegate = self;
    otpField6.keyboardType = UIKeyboardTypeNumberPad;
    otpField6.returnKeyType = UIReturnKeyNext;
    [otpField6 setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/otpline_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    otpField6.tag = 6;
    [[otpField6 valueForKey:@"textInputTraits"] setValue:[UIColor clearColor] forKey:@"insertionPointColor"];
    
    
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    submitButton.frame = CGRectMake(10, otpField6.frame.origin.y+otpField6.bounds.size.height+20, self.view.bounds.size.width-20, 40);
    [submitButton setBackgroundColor:RGB(68, 78, 98)];
    [submitButton addTarget:self action:@selector(submitOTPCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"BACK" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    backButton.frame = CGRectMake(10, submitButton.frame.origin.y+submitButton.bounds.size.height+10, self.view.bounds.size.width-20, 40);
    [backButton addTarget:self action:@selector(pop2Dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundColor:RGB(83, 83, 83)];
    [self.view addSubview:backButton];
    
    resendOTPButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [resendOTPButton setTitle:@"Re-send OTP" forState:UIControlStateNormal];
    [resendOTPButton setTitleColor:RGB(22, 25, 62) forState:UIControlStateNormal];
    resendOTPButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:15];
    resendOTPButton.frame = CGRectMake(0, backButton.frame.origin.y+backButton.bounds.size.height+10, self.view.bounds.size.width, 30);
    [resendOTPButton addTarget:self action:@selector(requestNewOTPCode) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resendOTPButton];
    
    [otpField1 becomeFirstResponder];
    
    UIButton *resignKeyPadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    resignKeyPadButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [resignKeyPadButton addTarget:self action:@selector(removeKeypad) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resignKeyPadButton];
    [self.view sendSubviewToBack:resignKeyPadButton];
}



# pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
        
        [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
        [[ViewControllerHelper viewControllerHelper] enableThisController:HOME_CONTROLLER onCenter:YES withAnimate:YES];
        
        appDelegate.IS_COMING_AFTER_LOGIN = YES;
    }
}



# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    DebugLog(@"%@",responseString);
    
    [appDelegate.hud hide:YES];
    
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        if (isVerifyingEmail) {
            
            if (isValidatingEmail) {
                
                [[SharedObject sharedClass] saveAccessTokenIfNeed:[responseString JSONValue]];
                [[SharedObject sharedClass] savePUBUserData:[responseString JSONValue]];
                
                [CommonFunctions showAlertView:self title:nil msg:@"Account successfully created." cancel:@"OK" otherButton:nil];
            }
            else if (isResettingPassword) {
                
                PasswordResetViewController *viewObj = [[PasswordResetViewController alloc] init];
                viewObj.emailString = emailStringForVerification;
                [self.navigationController pushViewController:viewObj animated:YES];
            }
        }
        else if (isResendingOTP) {
            
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
    [appDelegate.hud hide:YES];
    [CommonFunctions showAlertView:nil title:[error description] msg:nil cancel:@"OK" otherButton:nil];
}


# pragma mark - UITextFieldDelegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag<10) {
        
        if ((textField.text.length >= 1) && (string.length > 0))
        {
            
            NSInteger nextText = textField.tag + 1;
            UIResponder* nextResponder = [textField.superview viewWithTag:nextText];
            if (! nextResponder)
                [textField resignFirstResponder];
            if (nextResponder){
                [nextResponder becomeFirstResponder];
                
                UITextField* nextTextfield= (UITextField*) [textField.superview viewWithTag:nextText];
                
                if ((nextTextfield.text.length < 1)){
                    [nextTextfield setText:string];
                }
                return NO;
            }
            
        }
    }
    
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
    
    [self createUI];
    
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
