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
@synthesize wlsID;

//*************** Method To Move Back To Parent View

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Show Terms Of Use For SMS Alert

- (void) movetoTermsView {
    
    WebViewUrlViewController *viewObj = [[WebViewUrlViewController alloc] init];
    viewObj.headerTitle = @"Terms of Use";
    viewObj.webUrl = @"http://www.pub.gov.sg/managingflashfloods/WLS/Pages/TermsUseSMSAlert.aspx";
    [self.navigationController pushViewController:viewObj animated:YES];
}


//*************** Method For Animating Dropdown Picker

- (void) animateOptionsPicker {
    
    dropDownBg.hidden = NO;
    
    [UIView beginAnimations:@"PickerAnimation" context:NULL];
    [UIView setAnimationDuration:0.5];
    
    CGPoint pos = dropDownBg.center;
    pos.y = self.view.bounds.size.height-90;
    dropDownBg.center = pos;
    
    [UIView commitAnimations];
    
    pickerSelectedIndex = 0;
    [dropDownPicker reloadAllComponents];
    [dropDownPicker selectRow:0 inComponent:0 animated:NO];
    
}


//*************** Method For Dismissing The Picker View With Animation

- (void) dismissDropdownPicker {
    
    [UIView beginAnimations:@"PickerAnimation" context:NULL];
    [UIView setAnimationDuration:0.5];
    
    CGPoint pos = dropDownBg.center;
    pos.y = self.view.bounds.size.height+100;
    dropDownBg.center = pos;
    
    [UIView commitAnimations];
    
}


//*************** Method For Selecting Option Value & Dismissing The Picker View With Animation

- (void) selectPickerValue {
    
    [UIView beginAnimations:@"PickerAnimation" context:NULL];
    [UIView setAnimationDuration:0.5];
    
    CGPoint pos = dropDownBg.center;
    pos.y = self.view.bounds.size.height+100;
    dropDownBg.center = pos;
    [UIView commitAnimations];
    
    if (isShwoingLocations) {
        locationField.text = [[appDelegate.WLS_LISTING_ARRAY objectAtIndex:pickerSelectedIndex] objectForKey:@"name"];
    }
    else if (isShowingIDType) {
        idTypeField.text = [idTypeArray objectAtIndex:pickerSelectedIndex];
    }
    
    
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
    
    if ([locationField.text length]==0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Location is mandatory." cancel:@"OK" otherButton:nil];
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
    
    
    NSURL *url = [NSURL URLWithString:@"http://207.82.13.198/PUB_FMAS/Public/SubscribeWaterSensorAlert.ashx"];
//    NSURL *url = [NSURL URLWithString:@"https://www.pubfmas.com.sg/PUB_FMAS/Public/SubscribeWaterSensorAlert.ashx"];
    __block ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:20];
    [request setPostValue:@"1ac9e66fde53ecb4adf8f22f82aff0bc" forKey:@"Key"];
    [request setPostValue:@"Subscribe" forKey:@"Action"];
    [request setPostValue:nameField.text forKey:@"Name"];
    [request setPostValue:idTypeField.text forKey:@"IDType"];
    [request setPostValue:identificationNumberField.text forKey:@"IDNum"];
    [request setPostValue:emailField.text forKey:@"Email"];
    [request setPostValue:mobileField.text forKey:@"Mobile"];
    [request setPostValue:postalCodeField.text forKey:@"PostalCode"];
    [request setPostValue:[[appDelegate.WLS_LISTING_ARRAY objectAtIndex:pickerSelectedIndex] objectForKey:@"id"] forKey:@"StationCode"];
    [request setPostValue:@"0" forKey:@"HRWFlag"];
    [request setPostValue:@"1" forKey:@"WSAFlag"];
//    [request startSynchronous];
    
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        DebugLog(@"%@",responseString);
        // Use when fetching binary data
//        NSData *responseData = [request responseData];
        
        [CommonFunctions showAlertView:nil title:nil msg:@"Successfully subscribed to SMS alert." cancel:@"OK" otherButton:nil];
        nameField.text = @"";
        emailField.text = @"";
        identificationNumberField.text = @"";
        mobileField.text = @"";
        postalCodeField.text = @"";
        idTypeField.text = @"";
        locationField.text = @"";
        pickerSelectedIndex = 0;

    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];

    }];
    [request startAsynchronous];
    
//    //NSLog(@"request: %@", request.postBody);
//    NSError *error = [request error];
//    if (!error) {
//        NSString *response = [request responseString];
//        DebugLog(@"%@",response);
////        NSRange titleResultsRange3 = [response rangeOfString:@"<html>"];
////        if (titleResultsRange3.location != NSNotFound)
////        {
////            NSLog(@"found <html> !!!!!");
////            /*NSString *msg = [NSString stringWithFormat:@"Please call PUB 24hr Call Centre to report failure to subscribe."];
////             UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
////             message:msg
////             delegate:self
////             cancelButtonTitle:@"OK"
////             otherButtonTitles:nil ];
////             [alertView show];
////             [alertView release];*/
////            return 3;
////            //return NO;
////        }
////        NSLog(@"response: %@", response);
////        
////        NSRange titleResultsRange = [response rangeOfString:@"1:" options:NSCaseInsensitiveSearch];
////        NSRange titleResultsRange2 = [response rangeOfString:@"2:" options:NSCaseInsensitiveSearch];
////        
////        if (titleResultsRange.length > 0)
////        {
////            return 1;
////            //return YES;
////        }
////        else if(titleResultsRange2.length > 0)
////        {
////            //action 'after i found , want to add that array in arrayNew.
////            return 2;
////            //return YES;
////        }
////        else
////        {
////            /*NSString *msg = [NSString stringWithFormat:@"%@\nPlease call PUB 24hr Call Centre to report failure to subscribe.", response];
////             UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
////             message:msg
////             delegate:self
////             cancelButtonTitle:@"OK"
////             otherButtonTitles:nil ];
////             [alertView show];
////             [alertView release];*/
////            //return NO;
////            return 3;
////        }
//        
//        [CommonFunctions showAlertView:nil title:nil msg:@"Successfully subscribed to SMS alert." cancel:@"OK" otherButton:nil];
//        nameField.text = @"";
//        emailField.text = @"";
//        identificationNumberField.text = @"";
//        mobileField.text = @"";
//        postalCodeField.text = @"";
//        idTypeField.text = @"";
//        locationField.text = @"";
//        pickerSelectedIndex = 0;
//    }
//    else {
//        [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
//    }
}



//*************** Method To Hide Keypads

- (void) hideAllKeypads {
    
    [nameField resignFirstResponder];
    [emailField resignFirstResponder];
    [mobileField resignFirstResponder];
    [postalCodeField resignFirstResponder];
    [identificationNumberField resignFirstResponder];
    
    [UIView beginAnimations:@"topMenu" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = uiBackgroundView.center;
    pos.y = 284;
    uiBackgroundView.center = pos;
    [UIView commitAnimations];
    
    [self dismissDropdownPicker];
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
    
    
    uiBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:uiBackgroundView];
    
    UIButton *hideKeypadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hideKeypadButton.frame = CGRectMake(0, 0, uiBackgroundView.bounds.size.width, uiBackgroundView.bounds.size.height);
    [hideKeypadButton addTarget:self action:@selector(hideAllKeypads) forControlEvents:UIControlEventTouchUpInside];
    [uiBackgroundView addSubview:hideKeypadButton];
    
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, self.view.bounds.size.width-20, 40)];
    nameField.textColor = RGB(0, 0, 0);
    nameField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    nameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    nameField.leftViewMode = UITextFieldViewModeAlways;
    nameField.borderStyle = UITextBorderStyleNone;
    nameField.textAlignment=NSTextAlignmentLeft;
    [nameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    nameField.placeholder=@"Enter Name *";
    [uiBackgroundView addSubview:nameField];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.delegate = self;
    nameField.returnKeyType = UIReturnKeyNext;
    [nameField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [nameField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    nameField.tag = 1;
    nameField.text = [[SharedObject sharedClass] getPUBUserSavedDataValue:@"userName"];
    
    idTypeField = [[UITextField alloc] initWithFrame:CGRectMake(10, nameField.frame.origin.y+nameField.bounds.size.height+1, self.view.bounds.size.width-20, 40)];
    idTypeField.textColor = RGB(0, 0, 0);
    idTypeField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    idTypeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    idTypeField.leftViewMode = UITextFieldViewModeAlways;
    idTypeField.borderStyle = UITextBorderStyleNone;
    idTypeField.textAlignment=NSTextAlignmentLeft;
    [idTypeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    idTypeField.placeholder=@"Select ID Type *";
    [uiBackgroundView addSubview:idTypeField];
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
    [uiBackgroundView addSubview:identificationNumberField];
    identificationNumberField.clearButtonMode = UITextFieldViewModeWhileEditing;
    identificationNumberField.delegate = self;
    identificationNumberField.returnKeyType = UIReturnKeyNext;
    [identificationNumberField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [identificationNumberField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    identificationNumberField.tag = 3;
    
    
    locationField = [[UITextField alloc] initWithFrame:CGRectMake(10, identificationNumberField.frame.origin.y+identificationNumberField.bounds.size.height+1, self.view.bounds.size.width-20, 40)];
    locationField.textColor = RGB(0, 0, 0);
    locationField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    locationField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    locationField.leftViewMode = UITextFieldViewModeAlways;
    locationField.borderStyle = UITextBorderStyleNone;
    locationField.textAlignment=NSTextAlignmentLeft;
    [locationField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    locationField.placeholder=@"Select Location *";
    [uiBackgroundView addSubview:locationField];
    locationField.clearButtonMode = UITextFieldViewModeWhileEditing;
    locationField.delegate = self;
    locationField.keyboardType = UIKeyboardTypeEmailAddress;
    locationField.returnKeyType = UIReturnKeyNext;
    [locationField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [locationField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    locationField.tag = 4;
    
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, locationField.frame.origin.y+locationField.bounds.size.height+1, self.view.bounds.size.width-20, 40)];
    emailField.textColor = RGB(0, 0, 0);
    emailField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    emailField.leftViewMode = UITextFieldViewModeAlways;
    emailField.borderStyle = UITextBorderStyleNone;
    emailField.textAlignment=NSTextAlignmentLeft;
    [emailField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    emailField.placeholder=@"Enter Email *";
    [uiBackgroundView addSubview:emailField];
    emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailField.delegate = self;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    emailField.returnKeyType = UIReturnKeyNext;
    [emailField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [emailField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    emailField.tag = 5;
    emailField.text = [[SharedObject sharedClass] getPUBUserSavedDataValue:@"userEmail"];
    
    mobileField = [[UITextField alloc] initWithFrame:CGRectMake(10, emailField.frame.origin.y+emailField.bounds.size.height+1, self.view.bounds.size.width-20, 40)];
    mobileField.textColor = RGB(0, 0, 0);
    mobileField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    mobileField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    mobileField.leftViewMode = UITextFieldViewModeAlways;
    mobileField.borderStyle = UITextBorderStyleNone;
    mobileField.textAlignment=NSTextAlignmentLeft;
    [mobileField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    mobileField.placeholder=@"Enter Mobile *";
    [uiBackgroundView addSubview:mobileField];
    mobileField.clearButtonMode = UITextFieldViewModeWhileEditing;
    mobileField.delegate = self;
    mobileField.keyboardType = UIKeyboardTypeNumberPad;
    mobileField.returnKeyType = UIReturnKeyNext;
    [mobileField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [mobileField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    mobileField.tag = 6;
    
    postalCodeField = [[UITextField alloc] initWithFrame:CGRectMake(10, mobileField.frame.origin.y+mobileField.bounds.size.height+1, self.view.bounds.size.width-20, 40)];
    postalCodeField.textColor = RGB(0, 0, 0);
    postalCodeField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    postalCodeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    postalCodeField.leftViewMode = UITextFieldViewModeAlways;
    postalCodeField.borderStyle = UITextBorderStyleNone;
    postalCodeField.textAlignment=NSTextAlignmentLeft;
    [postalCodeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    postalCodeField.placeholder=@"Enter Postal Code *";
    [uiBackgroundView addSubview:postalCodeField];
    postalCodeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    postalCodeField.delegate = self;
    postalCodeField.keyboardType = UIKeyboardTypeNumberPad;
    postalCodeField.returnKeyType = UIReturnKeyDone;
    [postalCodeField setValue:RGB(61, 71, 94) forKeyPath:@"_placeholderLabel.textColor"];
    [postalCodeField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    postalCodeField.tag = 7;
    
    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"By clicking on the 'SUBSCRIBE' button, you agree that you have read and understood the Terms of Use set out here and agree to be bound by the same."];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(86,13)];
    
    termsOfUseLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, postalCodeField.frame.origin.y+postalCodeField.bounds.size.height+10, uiBackgroundView.bounds.size.width-20, 80)];
    termsOfUseLabel.backgroundColor = [UIColor clearColor];
    termsOfUseLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    [termsOfUseLabel setAttributedText:string];
    termsOfUseLabel.numberOfLines = 0;
    [uiBackgroundView addSubview:termsOfUseLabel];
    termsOfUseLabel.userInteractionEnabled = YES;
    
    UIButton *termsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    termsButton.frame = CGRectMake(0, 42, 90, 15);
    [termsButton addTarget:self action:@selector(movetoTermsView) forControlEvents:UIControlEventTouchUpInside];
    [termsOfUseLabel addSubview:termsButton];
    
    subscribreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [subscribreButton setTitle:@"SUBSCRIBE" forState:UIControlStateNormal];
    [subscribreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subscribreButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    subscribreButton.frame = CGRectMake(10, self.view.bounds.size.height-110, self.view.bounds.size.width-20, 40);
    [subscribreButton setBackgroundColor:RGB(68, 78, 98)];
    [subscribreButton addTarget:self action:@selector(validateInputParameters) forControlEvents:UIControlEventTouchUpInside];
    [uiBackgroundView addSubview:subscribreButton];
    
    [uiBackgroundView sendSubviewToBack:hideKeypadButton];
    
    cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissDropdownPicker)];
    flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(selectPickerValue)];
    
    
    dropDownBg = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 184)];
    dropDownBg.backgroundColor = [UIColor whiteColor];
    dropDownBg.userInteractionEnabled = YES;
    [self.view addSubview:dropDownBg];
    [self.view bringSubviewToFront:dropDownBg];
    
    
    dropDownToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, dropDownBg.bounds.size.width, 44)];
    [dropDownToolbar setItems:[NSArray arrayWithObjects:cancelBarButton,flexibleSpace,doneBarButton, nil] animated:NO];
    [dropDownBg addSubview:dropDownToolbar];
    
    dropDownPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, dropDownBg.bounds.size.width, 100)];
    dropDownPicker.delegate = self;
    dropDownPicker.dataSource = self;
    dropDownPicker.backgroundColor = [UIColor whiteColor];
    [dropDownBg addSubview:dropDownPicker];
    dropDownPicker.showsSelectionIndicator = YES;
    
}




//*************** Method To Get WLS Listing

- (void) fetchWLSListing {
    
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    appDelegate.hud.labelText = @"Loading...";
    
    //    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"PushToken",@"SortBy",@"version", nil];
    //    NSArray *values = [[NSArray alloc] initWithObjects:@"6",[prefs stringForKey:@"device_token"],[NSString stringWithFormat:@"1"],@"1.0", nil];
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"SortBy",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"6",[NSString stringWithFormat:@"1"],@"1.0", nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    DebugLog(@"%@",responseString);
    [appDelegate.hud hide:YES];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        //    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == false) {
        
        [appDelegate.WLS_LISTING_ARRAY removeAllObjects];
        
        NSArray *tempArray = [[responseString JSONValue] objectForKey:WLS_LISTING_RESPONSE_NAME];
        [appDelegate.WLS_LISTING_ARRAY setArray:tempArray];
        
        [locationField becomeFirstResponder];
    }
    
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
    
    [appDelegate.hud hide:YES];
}



# pragma mark - UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (isShwoingLocations) {
        return appDelegate.WLS_LISTING_ARRAY.count;
    }
    else if (isShowingIDType) {
        return idTypeArray.count;
    }
    
    return 0;
}


# pragma mark - UIPickerViewDelegate Methods

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    UILabel *sitesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 25)];
    sitesLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:17.0];
    sitesLabel.backgroundColor = [UIColor clearColor];
    sitesLabel.textAlignment = NSTextAlignmentCenter;
    if (isShwoingLocations) {
        sitesLabel.text = [[appDelegate.WLS_LISTING_ARRAY objectAtIndex:row] objectForKey:@"name"];
    }
    else if (isShowingIDType) {
        sitesLabel.text = [idTypeArray objectAtIndex:row];
    }
    sitesLabel.textColor = [UIColor blackColor];
    
    return sitesLabel;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    pickerSelectedIndex = row;
}



# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField==idTypeField) {
        
        isShowingIDType = YES;
        isShwoingLocations = NO;
        
        [nameField resignFirstResponder];
        [identificationNumberField resignFirstResponder];
        [emailField resignFirstResponder];
        [mobileField resignFirstResponder];
        [postalCodeField resignFirstResponder];
        
//        [UIView beginAnimations:@"topMenu" context:NULL];
//        [UIView setAnimationDuration:0.5];
//        CGPoint pos = uiBackgroundView.center;
//        pos.y = 239;
//        uiBackgroundView.center = pos;
//        [UIView commitAnimations];
        
        [self animateOptionsPicker];
        
        return NO;
    }
    else if (textField==locationField) {
        
        isShowingIDType = NO;
        isShwoingLocations = YES;
        
        [nameField resignFirstResponder];
        [identificationNumberField resignFirstResponder];
        [emailField resignFirstResponder];
        [mobileField resignFirstResponder];
        [postalCodeField resignFirstResponder];
        
//        [UIView beginAnimations:@"topMenu" context:NULL];
//        [UIView setAnimationDuration:0.5];
//        CGPoint pos = uiBackgroundView.center;
//        pos.y = 239;
//        uiBackgroundView.center = pos;
//        [UIView commitAnimations];
        
        if (appDelegate.WLS_LISTING_ARRAY.count==0) {
            [self fetchWLSListing];
        }
        else {
            [self animateOptionsPicker];
        }
        
        return NO;
        
    }
    
    if (textField==emailField || textField==mobileField || textField==postalCodeField) {
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint pos = uiBackgroundView.center;
//        if (IS_IPHONE_4_OR_LESS)
            pos.y = 110;
        uiBackgroundView.center = pos;
        [UIView commitAnimations];
        
        return YES;
    }
    
    
    if (textField==nameField || textField==identificationNumberField) {
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint pos = uiBackgroundView.center;
        if (IS_IPHONE_4_OR_LESS)
            pos.y = 239;
        uiBackgroundView.center = pos;
        [UIView commitAnimations];
    }
    
    [self dismissDropdownPicker];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField==nameField) {
        [idTypeField becomeFirstResponder];
    }
    else if (textField==identificationNumberField) {
        [locationField becomeFirstResponder];
    }
    else if (textField==emailField) {
        [mobileField becomeFirstResponder];
    }
    else if (textField==mobileField) {
        [postalCodeField becomeFirstResponder];
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
    
    
    idTypeArray = [[NSArray alloc] initWithObjects:@"NRIC",@"FIN",@"Other", nil];
    
    [self createSubscriptionUI];
}

- (void) viewWillAppear:(BOOL)animated {
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(52,158,240) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];

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
