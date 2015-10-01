//
//  EditProfileViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 23/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController



//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



//*************** Method For Handling Edit Profile Actions

- (void) handleEitProfileActions:(id) sender {
    
    UIButton *button = (id) sender;
    if (button.tag==1) {
        
        if ([nameField.text length]==0) {
            [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Name is mandatory." cancel:@"OK" otherButton:nil];
        }
        else if ([emailField.text length]==0) {
            [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Email id is mandatory." cancel:@"OK" otherButton:nil];
        }
        else if (![CommonFunctions NSStringIsValidEmail:emailField.text]) {
            [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Please provide a valid email." cancel:@"OK" otherButton:nil];
        }
        else {
            
            [nameField resignFirstResponder];
            [emailField resignFirstResponder];
            
            appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
            appDelegate.hud.labelText = @"Loading..!!";
            
            NSMutableArray *parameters = [[NSMutableArray alloc] init];
            NSMutableArray *values = [[NSMutableArray alloc] init];
            
            [parameters addObject:@"Name"];
            [values addObject:nameField.text];
            
            [parameters addObject:@"Email"];
            [values addObject:emailField.text];
            
            [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,PROFILE_API_URL]];
        }
    }
    else if (button.tag==2) {
        
        ChangePasswordViewController *viewObj = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}


# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField==nameField) {
        [emailField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}



# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    [appDelegate.hud hide:YES];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [[SharedObject sharedClass] saveAccessTokenIfNeed:[responseString JSONValue]];
        
        appDelegate.USER_PROFILE_DICTIONARY = [[responseString JSONValue] objectForKey:@"UserProfile"];
        
        //        OTPViewController *viewObj = [[OTPViewController alloc] init];
        //        viewObj.emailStringForVerification = [appDelegate.USER_PROFILE_DICTIONARY objectForKey:@"Email"];
        //        [self.navigationController pushViewController:viewObj animated:YES];
        
        [CommonFunctions showAlertView:self title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
        
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:[error description] msg:nil cancel:@"OK" otherButton:nil];
    [appDelegate.hud hide:YES];
}



# pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Edit Profile";
    self.view.backgroundColor = RGB(247, 247, 247);
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];

    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 40)];
    nameField.textColor = RGB(35, 35, 35);
    nameField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    nameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    nameField.leftViewMode = UITextFieldViewModeAlways;
    nameField.borderStyle = UITextBorderStyleNone;
    nameField.textAlignment=NSTextAlignmentLeft;
    [nameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    nameField.placeholder=@"Name *";
    [self.view addSubview:nameField];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.delegate = self;
    nameField.keyboardType = UIKeyboardTypeDefault;
    nameField.backgroundColor = [UIColor whiteColor];
    nameField.returnKeyType = UIReturnKeyNext;
    [nameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    nameField.tag = 1;
    nameField.text = [appDelegate.USER_PROFILE_DICTIONARY objectForKey:@"Name"];
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, nameField.frame.origin.y+nameField.bounds.size.height+1, self.view.bounds.size.width, 40)];
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
    emailField.returnKeyType = UIReturnKeyDefault;
    [emailField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    emailField.tag = 2;
    emailField.text = [appDelegate.USER_PROFILE_DICTIONARY objectForKey:@"Email"];
    
    updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateButton setTitle:@"UPDATE" forState:UIControlStateNormal];
    [updateButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    updateButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    updateButton.tag = 1;
    updateButton.frame = CGRectMake(0, self.view.bounds.size.height-110, self.view.bounds.size.width, 45);
    [updateButton addTarget:self action:@selector(handleEitProfileActions:) forControlEvents:UIControlEventTouchUpInside];
    [updateButton setBackgroundColor:RGB(86, 46, 120)];
    [self.view addSubview:updateButton];
    
    changePasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changePasswordButton setTitle:@"CHANGE PASSWORD" forState:UIControlStateNormal];
    [changePasswordButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    changePasswordButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    changePasswordButton.tag = 2;
    changePasswordButton.frame = CGRectMake(0, updateButton.frame.origin.y-50, self.view.bounds.size.width, 45);
    [changePasswordButton addTarget:self action:@selector(handleEitProfileActions:) forControlEvents:UIControlEventTouchUpInside];
    [changePasswordButton setBackgroundColor:RGB(200, 0, 0)];
    [self.view addSubview:changePasswordButton];
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
