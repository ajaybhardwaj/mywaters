//
//  SignUpViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 9/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController



//*************** Method To Skip Sign Up

- (void) skipSignUpProcess {
    
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


//*************** Method To Move Back To Parent View

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method For Handling Photo Library Action

- (void) handlePhotoLibraryAction {
    
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:NULL];
}


//*************** Method For Handling Camera Action

- (void) handleCameraAction {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Camera is not supported by device." cancel:@"OK" otherButton:nil];
    }
}


//*************** Method To Handle Tap Gesture For Profile Pic

- (void) handleSingleTapGesture: (UITapGestureRecognizer*) sender {
    
    if (sender==profileImageTap) {
        [CommonFunctions showActionSheet:self containerView:self.view title:@"Profile Picture" msg:nil cancel:nil tag:1 destructive:nil otherButton:@"Camera",@"Photo Library",@"Cancel",nil];
    }
}


//*************** Method To Handle Terms Actions

- (void) changeTermsAgreeStatus {
    
    if (isTermsAgree) {
        isTermsAgree = NO;
        [checkboxButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/checkbox.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else {
        isTermsAgree = YES;
        [checkboxButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icon_tick.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
}


//*************** Method To Detect Swipe Gesture

- (void) swipedScreen:(UISwipeGestureRecognizer*)gesture {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}



//*************** Method To Submit Signup Inputs

- (void) submitSignupDetails {
    
    // Submit Login Details
    [emailField resignFirstResponder];
    [passField resignFirstResponder];
    [nameField resignFirstResponder];
    [retypePassField resignFirstResponder];
    
    if (IS_IPHONE_4_OR_LESS) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint viewPOS = backgroundScrollView.center;
        viewPOS.y = backgroundScrollView.bounds.size.height-261;
        self.view.center = viewPOS;
        [UIView commitAnimations];
        
    }
    else if (IS_IPHONE_5) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint viewPOS = backgroundScrollView.center;
        viewPOS.y = backgroundScrollView.bounds.size.height-304;
        self.view.center = viewPOS;
        [UIView commitAnimations];
    }
    else if (IS_IPHONE_6) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint viewPOS = backgroundScrollView.center;
        viewPOS.y = backgroundScrollView.bounds.size.height-353;
        self.view.center = viewPOS;
        [UIView commitAnimations];
    }
    else if (IS_IPHONE_6P) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint viewPOS = backgroundScrollView.center;
        viewPOS.y = backgroundScrollView.bounds.size.height-389;
        self.view.center = viewPOS;
        [UIView commitAnimations];
    }
}


//*************** Method To Validate Signup Inputs

- (void) validateSignUpParameters {
    
    if ([emailField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Email is mandatory." cancel:@"OK" otherButton:nil];
    }
    else if (![CommonFunctions NSStringIsValidEmail:emailField.text]) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Please provide a valid email." cancel:@"OK" otherButton:nil];
    }
    else if ([nameField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Name is mandatory." cancel:@"OK" otherButton:nil];
    }
    else if ([CommonFunctions characterSet1Found:nameField.text]) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Please provide a valid name." cancel:@"OK" otherButton:nil];
    }
    else if ([passField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Password is mandatory." cancel:@"OK" otherButton:nil];
    }
    else if ([retypePassField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Retype password is mandatory." cancel:@"OK" otherButton:nil];
    }
    else if (![passField.text isEqualToString:retypePassField.text]) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Password & retype password does not match." cancel:@"OK" otherButton:nil];
    }
    else {
        
        [self submitSignupDetails];
        
        appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
        appDelegate.hud.labelText = @"Loading..!!";
        
        NSMutableArray *parameters = [[NSMutableArray alloc] init];
        NSMutableArray *values = [[NSMutableArray alloc] init];
        
        [parameters addObject:@"Profile.Name"];
        [values addObject:nameField.text];
        
        
        [parameters addObject:@"Profile.Email"];
        [values addObject:emailField.text];
        
        
        [parameters addObject:@"Profile.Password"];
        [values addObject:passField.text];
        
        
        if (isProfilePictureSelected) {
            
            NSData* data = UIImageJPEGRepresentation(profileImageView.image, 1.0f);
            NSString *base64ImageString = [Base64 encode:data];
            
            [parameters addObject:@"Profile.ImageBase64"];
            [values addObject:base64ImageString];
            
        }
        
        [parameters addObject:@"Profile.IsFriendOfWater"];
        if (isTermsAgree) {
            [values addObject:@"true"];
        }
        else {
            [values addObject:@"false"];
        }
                
        [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,SIGNUP_API_URL]];
    }
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    DebugLog(@"%@",responseString);
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [appDelegate.hud hide:YES];
        OTPViewController *viewObj = [[OTPViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else {
        [appDelegate.hud hide:YES];
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:[error description] msg:nil cancel:@"OK" otherButton:nil];
    [appDelegate.hud hide:YES];
}



# pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (IS_IPHONE_4_OR_LESS) {
        
        if (textField==emailField) {
            
            [UIView beginAnimations:@"emailField" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = backgroundScrollView.center;
            viewPOS.y = backgroundScrollView.bounds.size.height-280;
            self.view.center = viewPOS;
            [UIView commitAnimations];
        }
        else if (textField==nameField) {
            
            [UIView beginAnimations:@"nameField" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = backgroundScrollView.center;
            viewPOS.y = backgroundScrollView.bounds.size.height-310;
            self.view.center = viewPOS;
            [UIView commitAnimations];
        }
        else if (textField==passField) {
            
            [UIView beginAnimations:@"passField" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = backgroundScrollView.center;
            viewPOS.y = backgroundScrollView.bounds.size.height-410;
            self.view.center = viewPOS;
            [UIView commitAnimations];
        }
        else if (textField==retypePassField) {
            
            [UIView beginAnimations:@"retypeField" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = backgroundScrollView.center;
            viewPOS.y = backgroundScrollView.bounds.size.height-510;
            self.view.center = viewPOS;
            [UIView commitAnimations];
        }
    }
    else if (IS_IPHONE_5) {
        
        if (textField==retypePassField || textField==passField) {
            
            [UIView beginAnimations:@"passField" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = backgroundScrollView.center;
            viewPOS.y = backgroundScrollView.bounds.size.height-490;
            self.view.center = viewPOS;
            [UIView commitAnimations];
        }
    }
    else if (IS_IPHONE_6 || IS_IPHONE_6P) {
        
        if (textField==retypePassField) {
            
            [UIView beginAnimations:@"retypeField" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = backgroundScrollView.center;
            viewPOS.y = backgroundScrollView.bounds.size.height-450;
            self.view.center = viewPOS;
            [UIView commitAnimations];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField==emailField) {
        [nameField becomeFirstResponder];
    }
    else if (textField==nameField) {
        [passField becomeFirstResponder];
    }
    else if (textField==passField) {
        [retypePassField becomeFirstResponder];
    }
    else {
        
        [textField resignFirstResponder];
        
        if (IS_IPHONE_4_OR_LESS) {
            
            [UIView beginAnimations:@"retypePass" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = backgroundScrollView.center;
            viewPOS.y = backgroundScrollView.bounds.size.height-261;
            self.view.center = viewPOS;
            [UIView commitAnimations];
            
        }
        else if (IS_IPHONE_5) {
            
            [UIView beginAnimations:@"retypePass" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = backgroundScrollView.center;
            viewPOS.y = backgroundScrollView.bounds.size.height-304;
            self.view.center = viewPOS;
            [UIView commitAnimations];
        }
        else if (IS_IPHONE_6) {
            
            [UIView beginAnimations:@"retypePass" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = backgroundScrollView.center;
            viewPOS.y = backgroundScrollView.bounds.size.height-353;
            self.view.center = viewPOS;
            [UIView commitAnimations];
        }
        else if (IS_IPHONE_6P) {
            
            [UIView beginAnimations:@"retypePass" context:NULL];
            [UIView setAnimationDuration:0.5];
            CGPoint viewPOS = backgroundScrollView.center;
            viewPOS.y = backgroundScrollView.bounds.size.height-389;
            self.view.center = viewPOS;
            [UIView commitAnimations];
        }
    }
    return YES;
}


# pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag==1) {
        if (buttonIndex==0) {
            [self handleCameraAction];
        }
        else if (buttonIndex==1) {
            [self handlePhotoLibraryAction];
        }
    }
}

# pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    isProfilePictureSelected = YES;
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    profileImageView.image=image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    isProfilePictureSelected = NO;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
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
    
    
    facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton setTitle:@"CONNECT VIA FACEBOOK" forState:UIControlStateNormal];
    [facebookButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    facebookButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    facebookButton.tag = 1;
    facebookButton.frame = CGRectMake(10, 40, backgroundScrollView.bounds.size.width-20, 40);
    [facebookButton setBackgroundColor:RGB(45, 72, 166)];
    [backgroundScrollView addSubview:facebookButton];
    
    
    UIImageView *fbIcon = [[UIImageView alloc] initWithFrame:CGRectMake(40, 10, 25, 25)];
    [fbIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_facebook.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [facebookButton addSubview:fbIcon];
    
    
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)-50, facebookButton.frame.origin.y+facebookButton.bounds.size.height+15, 100, 100)];
    [profileImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/image_avatar.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    profileImageView.layer.cornerRadius = profileImageView.bounds.size.width/2;
    profileImageView.layer.masksToBounds = YES;
    [backgroundScrollView addSubview:profileImageView];
    profileImageView.userInteractionEnabled = YES;
    
    profileImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    profileImageTap.numberOfTapsRequired = 1;
    profileImageTap.numberOfTouchesRequired = 1;
    [profileImageView addGestureRecognizer: profileImageTap];
    
    
    uploadAvatarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, profileImageView.frame.origin.y+profileImageView.bounds.size.height, self.view.bounds.size.width, 20)];
    uploadAvatarLabel.backgroundColor = [UIColor clearColor];
    uploadAvatarLabel.textAlignment = NSTextAlignmentCenter;
    uploadAvatarLabel.textColor = RGB(61, 71, 94);
    uploadAvatarLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    uploadAvatarLabel.text = @"Upload Avatar";
    [backgroundScrollView addSubview:uploadAvatarLabel];
    
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, profileImageView.frame.origin.y+profileImageView.bounds.size.height+15, self.view.bounds.size.width-20, 40)];
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
    emailField.returnKeyType = UIReturnKeyNext;
    [emailField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [emailField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    emailField.tag = 1;
    
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, emailField.frame.origin.y+emailField.bounds.size.height+1, self.view.bounds.size.width-20, 40)];
    nameField.textColor = RGB(61, 71, 94);
    nameField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    nameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    nameField.leftViewMode = UITextFieldViewModeAlways;
    nameField.borderStyle = UITextBorderStyleNone;
    nameField.textAlignment=NSTextAlignmentLeft;
    [nameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    nameField.placeholder=@"Name *";
    [backgroundScrollView addSubview:nameField];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.delegate = self;
    nameField.returnKeyType = UIReturnKeyNext;
    [nameField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [nameField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    nameField.tag = 2;
    
    
    passField = [[UITextField alloc] initWithFrame:CGRectMake(10, nameField.frame.origin.y+nameField.bounds.size.height+1, self.view.bounds.size.width-20, 40)];
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
    passField.returnKeyType = UIReturnKeyNext;
    [passField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [passField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    passField.tag = 3;
    
    
    retypePassField = [[UITextField alloc] initWithFrame:CGRectMake(10, passField.frame.origin.y+passField.bounds.size.height+1, self.view.bounds.size.width-20, 40)];
    retypePassField.textColor = RGB(61, 71, 94);
    retypePassField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    retypePassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    retypePassField.leftViewMode = UITextFieldViewModeAlways;
    retypePassField.borderStyle = UITextBorderStyleNone;
    retypePassField.textAlignment=NSTextAlignmentLeft;
    [retypePassField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    retypePassField.secureTextEntry = YES;
    retypePassField.placeholder=@"Re-enter Password *";
    [backgroundScrollView addSubview:retypePassField];
    retypePassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    retypePassField.delegate = self;
    retypePassField.returnKeyType = UIReturnKeyDone;
    [retypePassField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [retypePassField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    retypePassField.tag = 4;
    
    checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkboxButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    checkboxButton.tag = 2;
    checkboxButton.frame = CGRectMake(15, retypePassField.frame.origin.y+retypePassField.bounds.size.height+20, 20, 20);
    [checkboxButton addTarget:self action:@selector(changeTermsAgreeStatus) forControlEvents:UIControlEventTouchUpInside];
    [checkboxButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/checkbox.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [backgroundScrollView addSubview:checkboxButton];
    
    termsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [termsButton setTitle:@"I would like to sign up as a Friend of Water." forState:UIControlStateNormal];
    [termsButton setTitleColor:RGB(22, 25, 62) forState:UIControlStateNormal];
    termsButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
    termsButton.tag = 3;
    termsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    termsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
    termsButton.frame = CGRectMake(0, retypePassField.frame.origin.y+retypePassField.bounds.size.height+20, self.view.bounds.size.width, 20);
    [termsButton addTarget:self action:@selector(changeTermsAgreeStatus) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:termsButton];
    
    signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signUpButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signUpButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    signUpButton.tag = 4;
    signUpButton.frame = CGRectMake(10, termsButton.frame.origin.y+termsButton.bounds.size.height+15, self.view.bounds.size.width-20, 40);
    [signUpButton setBackgroundColor:RGB(68, 78, 98)];
    [signUpButton addTarget:self action:@selector(validateSignUpParameters) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:signUpButton];
    
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"BACK" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    backButton.tag = 5;
    backButton.frame = CGRectMake(10, signUpButton.frame.origin.y+signUpButton.bounds.size.height+15, self.view.bounds.size.width-20, 40);
    [backButton addTarget:self action:@selector(pop2Dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundColor:RGB(83, 83, 83)];
    [backgroundScrollView addSubview:backButton];
    
    skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [skipButton setTitle:@"or skip for now" forState:UIControlStateNormal];
    [skipButton setTitleColor:RGB(22, 25, 62) forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:15];
    skipButton.tag = 6;
    skipButton.frame = CGRectMake(0, backButton.frame.origin.y+backButton.bounds.size.height+5, self.view.bounds.size.width, 30);
    [skipButton addTarget:self action:@selector(skipSignUpProcess) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:skipButton];
    
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
//    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
//    [backgroundScrollView addGestureRecognizer:swipeGesture];
    
    if (IS_IPHONE_4_OR_LESS) {
        backgroundScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 580);
    }
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillDisappear:(BOOL)animated {
    
    isProfilePictureSelected = NO;
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
