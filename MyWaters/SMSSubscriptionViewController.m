//
//  SMSSubscriptionViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 19/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import "SMSSubscriptionViewController.h"

@interface SMSSubscriptionViewController ()

@end

@implementation SMSSubscriptionViewController


//*************** Method To Move Back To Parent View

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Validate Inputs

- (void) validateInputParameters {
    
    
    if ([nameField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Name is mandatory." cancel:@"OK" otherButton:nil];
        return;
    }
    
    if ([CommonFunctions characterSet1Found:nameField.text]) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Please provide a valid name." cancel:@"OK" otherButton:nil];
        return;
    }
    if ([emailField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Email is mandatory." cancel:@"OK" otherButton:nil];
        return;
    }
    
    if (![CommonFunctions NSStringIsValidEmail:emailField.text]) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Please provide a valid email." cancel:@"OK" otherButton:nil];
        return;
    }
    
    if ([idTypeField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"ID Type is mandatory." cancel:@"OK" otherButton:nil];
        return;
    }
    
    if ([identificationNumberField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Identification number is mandatory." cancel:@"OK" otherButton:nil];
        return;
    }
    
    if ([mobileField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Mobile number is mandatory." cancel:@"OK" otherButton:nil];
        return;
    }
    
    if ([postalCodeField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Postal code is mandatory." cancel:@"OK" otherButton:nil];
        return;
    }
    
    
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    appDelegate.hud.labelText = @"Loading...";
    
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    [parameters addObject:@"Profile.Name"];
    [values addObject:nameField.text];
    
    
    [parameters addObject:@"Profile.Email"];
    [values addObject:emailField.text];
    
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,SIGNUP_API_URL]];
    
}



//*************** Method To Create UI

- (void) createSubscriptionUI {
    
    UIImageView *bgView = [[UIImageView alloc] init];
    
    if (IS_IPHONE_4_OR_LESS) {
        bgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 580);
    }
    else {
        bgView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }
    [bgView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/image_background.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:bgView];
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, self.view.bounds.size.width-20, 40)];
    nameField.textColor = RGB(0, 0, 0);
    nameField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    nameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    nameField.leftViewMode = UITextFieldViewModeAlways;
    nameField.borderStyle = UITextBorderStyleNone;
    nameField.textAlignment=NSTextAlignmentLeft;
    [nameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    nameField.placeholder=@"Enter Name *";
    [self.view addSubview:nameField];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.delegate = self;
    nameField.returnKeyType = UIReturnKeyNext;
    [nameField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [nameField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    nameField.tag = 1;
    
    idTypeField = [[UITextField alloc] initWithFrame:CGRectMake(10, nameField.frame.origin.y+nameField.bounds.size.height+1, self.view.bounds.size.width-20, 40)];
    idTypeField.textColor = RGB(0, 0, 0);
    idTypeField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    idTypeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    idTypeField.leftViewMode = UITextFieldViewModeAlways;
    idTypeField.borderStyle = UITextBorderStyleNone;
    idTypeField.textAlignment=NSTextAlignmentLeft;
    [idTypeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    idTypeField.placeholder=@"Select ID Type *";
    [self.view addSubview:idTypeField];
    idTypeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    idTypeField.delegate = self;
    idTypeField.returnKeyType = UIReturnKeyNext;
    [idTypeField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [idTypeField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    idTypeField.tag = 2;
    
    identificationNumberField = [[UITextField alloc] initWithFrame:CGRectMake(10, idTypeField.frame.origin.y+idTypeField.bounds.size.height+1, self.view.bounds.size.width-20, 40)];
    identificationNumberField.textColor = RGB(0, 0, 0);
    identificationNumberField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    identificationNumberField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    identificationNumberField.leftViewMode = UITextFieldViewModeAlways;
    identificationNumberField.borderStyle = UITextBorderStyleNone;
    identificationNumberField.textAlignment=NSTextAlignmentLeft;
    [identificationNumberField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    identificationNumberField.placeholder=@"Enter Identification No *";
    [self.view addSubview:identificationNumberField];
    identificationNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    identificationNumberField.delegate = self;
    identificationNumberField.returnKeyType = UIReturnKeyNext;
    [identificationNumberField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [identificationNumberField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    identificationNumberField.tag = 3;
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, identificationNumberField.frame.origin.y+identificationNumberField.bounds.size.height+1, self.view.bounds.size.width-20, 40)];
    emailField.textColor = RGB(0, 0, 0);
    emailField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    emailField.leftViewMode = UITextFieldViewModeAlways;
    emailField.borderStyle = UITextBorderStyleNone;
    emailField.textAlignment=NSTextAlignmentLeft;
    [emailField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    emailField.placeholder=@"Enter Email *";
    [self.view addSubview:emailField];
    emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailField.delegate = self;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    emailField.returnKeyType = UIReturnKeyNext;
    [emailField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [emailField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    emailField.tag = 4;
    
    mobileField = [[UITextField alloc] initWithFrame:CGRectMake(10, emailField.frame.origin.y+emailField.bounds.size.height+1, self.view.bounds.size.width-20, 40)];
    mobileField.textColor = RGB(0, 0, 0);
    mobileField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    mobileField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    mobileField.leftViewMode = UITextFieldViewModeAlways;
    mobileField.borderStyle = UITextBorderStyleNone;
    mobileField.textAlignment=NSTextAlignmentLeft;
    [mobileField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    mobileField.placeholder=@"Enter Mobile *";
    [self.view addSubview:mobileField];
    mobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
    mobileField.delegate = self;
    mobileField.keyboardType = UIKeyboardTypeNumberPad;
    mobileField.returnKeyType = UIReturnKeyNext;
    [mobileField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [mobileField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    mobileField.tag = 5;
    
    postalCodeField = [[UITextField alloc] initWithFrame:CGRectMake(10, mobileField.frame.origin.y+mobileField.bounds.size.height+1, self.view.bounds.size.width-20, 40)];
    postalCodeField.textColor = RGB(0, 0, 0);
    postalCodeField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    postalCodeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    postalCodeField.leftViewMode = UITextFieldViewModeAlways;
    postalCodeField.borderStyle = UITextBorderStyleNone;
    postalCodeField.textAlignment=NSTextAlignmentLeft;
    [postalCodeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    postalCodeField.placeholder=@"Enter Postal Code *";
    [self.view addSubview:postalCodeField];
    postalCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    postalCodeField.delegate = self;
    postalCodeField.keyboardType = UIKeyboardTypeNumberPad;
    postalCodeField.returnKeyType = UIReturnKeyDone;
    [postalCodeField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [postalCodeField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    postalCodeField.tag = 6;
    
    subscribreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [subscribreButton setTitle:@"SUBSCRIBE" forState:UIControlStateNormal];
    [subscribreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subscribreButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    subscribreButton.frame = CGRectMake(10, self.view.bounds.size.height-110, self.view.bounds.size.width-20, 40);
    [subscribreButton setBackgroundColor:RGB(68, 78, 98)];
    [subscribreButton addTarget:self action:@selector(validateInputParameters) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:subscribreButton];
}



# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField==idTypeField) {
        
        [nameField resignFirstResponder];
        [identificationNumberField resignFirstResponder];
        [emailField resignFirstResponder];
        [mobileField resignFirstResponder];
        [postalCodeField resignFirstResponder];
        
        [CommonFunctions showActionSheet:self containerView:self.view.window title:@"Select ID Type" msg:nil cancel:nil tag:1 destructive:nil otherButton:@"NRIC",@"FIN",@"Other",@"",nil];
        
        return NO;
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField==nameField) {
        [idTypeField becomeFirstResponder];
    }
    else if (textField==identificationNumberField) {
        [emailField becomeFirstResponder];
    }
    else if (textField==mobileField) {
        [postalCodeField resignFirstResponder];
    }
    else if (textField==postalCodeField) {
        // call subscribe method
    }
    return YES;
}


# pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag==1) {
        if (buttonIndex==0) {
            idTypeField.text = @"NRIC";
        }
        else if (buttonIndex==1) {
            idTypeField.text = @"FIN";
        }
        else if (buttonIndex==2) {
            idTypeField.text = @"Other";
        }
    }
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"SMS Subscription";
    self.view.backgroundColor = RGB(247, 247, 247);
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];

    [self createSubscriptionUI];
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
