//
//  ChangePasswordViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 23/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Validate Change Password Inputs

- (void) validateChangePasswordParameters {
    
    if ([currentPassField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Old Password is mandatory." cancel:@"OK" otherButton:nil];
    }
    else if ([newPassField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Please provide a new password." cancel:@"OK" otherButton:nil];
    }
    else if ([confirmPassField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Please confirm your new password." cancel:@"OK" otherButton:nil];
    }
    else if (![confirmPassField.text isEqualToString:newPassField.text]) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Password and confirm password are not same." cancel:@"OK" otherButton:nil];
    }
    else if ([currentPassField.text isEqualToString:newPassField.text]) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"New password can not be same as current password." cancel:@"OK" otherButton:nil];
    }
    else {
        
        [currentPassField resignFirstResponder];
        [newPassField resignFirstResponder];
        [confirmPassField resignFirstResponder];
        
        [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
//        appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
//        appDelegate.hud.labelText = @"Loading...";
        
        NSMutableArray *parameters = [[NSMutableArray alloc] init];
        NSMutableArray *values = [[NSMutableArray alloc] init];
        
        [parameters addObject:@"OldPassword"];
        [values addObject:currentPassField.text];
        
        [parameters addObject:@"NewPassword"];
        [values addObject:newPassField.text];
        
        [parameters addObject:@"Email"];
        [values addObject:[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userEmail"]];
        
        [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,PROFILE_API_URL]];
    }
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    [CommonFunctions dismissGlobalHUD];
//    [appDelegate.hud hide:YES];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
//        [[SharedObject sharedClass] savePUBUserData:[responseString JSONValue]];
        
//        OTPViewController *viewObj = [[OTPViewController alloc] init];
//        viewObj.emailStringForVerification = [appDelegate.USER_PROFILE_DICTIONARY objectForKey:@"Email"];
//        [self.navigationController pushViewController:viewObj animated:YES];
        
        [CommonFunctions showAlertView:self title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
        
    }
    else {
        currentPassField.text = @"";
        newPassField.text = @"";
        confirmPassField.text = @"";
        
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
        [self.navigationController popViewControllerAnimated:YES];
    }
}


# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField==currentPassField) {
        [newPassField becomeFirstResponder];
    }
    else if (textField==newPassField) {
        [confirmPassField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Change Password";
    self.view.backgroundColor = RGB(247, 247, 247);
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    currentPassField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, self.view.bounds.size.width-20, 40)];
    currentPassField.textColor = RGB(61, 71, 94);
    currentPassField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    currentPassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    currentPassField.leftViewMode = UITextFieldViewModeAlways;
    currentPassField.borderStyle = UITextBorderStyleNone;
    currentPassField.textAlignment=NSTextAlignmentLeft;
    [currentPassField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    currentPassField.placeholder = @"Current password *";
    [self.view addSubview:currentPassField];
    currentPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    currentPassField.delegate = self;
    currentPassField.keyboardType = UIKeyboardTypeDefault;
    [currentPassField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    currentPassField.returnKeyType = UIReturnKeyNext;
    currentPassField.secureTextEntry = YES;
    [currentPassField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    currentPassField.tag = 1;
    
    
    newPassField = [[UITextField alloc] initWithFrame:CGRectMake(10, currentPassField.frame.origin.y+currentPassField.bounds.size.height+10, self.view.bounds.size.width-20, 40)];
    newPassField.textColor = RGB(61, 71, 94);
    newPassField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    newPassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    newPassField.leftViewMode = UITextFieldViewModeAlways;
    newPassField.borderStyle = UITextBorderStyleNone;
    newPassField.textAlignment=NSTextAlignmentLeft;
    [newPassField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    newPassField.placeholder = @"New password *";
    [self.view addSubview:newPassField];
    newPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    newPassField.delegate = self;
    newPassField.keyboardType = UIKeyboardTypeDefault;
    [newPassField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    newPassField.returnKeyType = UIReturnKeyNext;
    newPassField.secureTextEntry = YES;
    [newPassField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    newPassField.tag = 2;
    
    confirmPassField = [[UITextField alloc] initWithFrame:CGRectMake(10, newPassField.frame.origin.y+newPassField.bounds.size.height+10, self.view.bounds.size.width-20, 40)];
    confirmPassField.textColor = RGB(61, 71, 94);
    confirmPassField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    confirmPassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    confirmPassField.leftViewMode = UITextFieldViewModeAlways;
    confirmPassField.borderStyle = UITextBorderStyleNone;
    confirmPassField.textAlignment=NSTextAlignmentLeft;
    [confirmPassField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    confirmPassField.placeholder = @"Re-type password *";
    [self.view addSubview:confirmPassField];
    confirmPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    confirmPassField.delegate = self;
    confirmPassField.keyboardType = UIKeyboardTypeDefault;
    [confirmPassField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    confirmPassField.returnKeyType = UIReturnKeyDone;
    confirmPassField.secureTextEntry = YES;
    [confirmPassField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    confirmPassField.tag = 3;
    
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [submitButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    submitButton.tag = 1;
    submitButton.frame = CGRectMake(0, self.view.bounds.size.height-110, self.view.bounds.size.width, 45);
    [submitButton addTarget:self action:@selector(validateChangePasswordParameters) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setBackgroundColor:RGB(86, 46, 120)];
    [self.view addSubview:submitButton];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    [appDelegate setShouldRotate:NO];

}

- (void) viewWillDisappear:(BOOL)animated {
    
    for (ASIHTTPRequest *req in ASIHTTPRequest.sharedQueue.operations)
    {
        [req cancel];
        [req setDelegate:nil];
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
