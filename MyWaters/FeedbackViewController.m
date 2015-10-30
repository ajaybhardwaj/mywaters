//
//  FeedbackViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "FeedbackViewController.h"
#import "ViewControllerHelper.h"


@interface FeedbackViewController ()

@end

@implementation FeedbackViewController
@synthesize isNotFeedbackController;
@synthesize tempLocationString,tempCommentString,tempNameString,tempPhoneString,tempEmailString;
@synthesize isReportingForChatter,chatterID,chatterText;

//*************** Method To Show UIActionSheet

- (void) showActionSheet {
    
    [nameField resignFirstResponder];
    [locationField resignFirstResponder];
    [commentField resignFirstResponder];
    [phoneField resignFirstResponder];
    [emailField resignFirstResponder];
    
    [CommonFunctions showActionSheet:self containerView:self.view.window title:@"Select Source" msg:nil cancel:nil tag:1 destructive:nil otherButton:@"Take Photo",@"Photo Library",@"Cancel",nil];
}


//*************** Method To PUB HelpDesk

- (void) callPUBHelpdesk {
    
    NSString *pubHelpdesk;
    for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
        if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"PUBTelpNo"]) {
            pubHelpdesk = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
            break;
        }
    }
    
    if ([pubHelpdesk length] != 0) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", pubHelpdesk]]];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Sorry" msg:@"No contact available." cancel:@"Ok" otherButton:nil];
    }
}


//*************** Method For Converting Lat & Long To Location Name

- (void) getAddressFromLatLon:(CLLocation *)bestLocation {
    
    DebugLog(@"%f %f", bestLocation.coordinate.latitude, bestLocation.coordinate.longitude);
    
    currentLocation.latitude = bestLocation.coordinate.latitude;
    currentLocation.longitude = bestLocation.coordinate.longitude;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:bestLocation
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error){
             DebugLog(@"Geocode failed with error: %@", error);
             return;
         }
         
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         DebugLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
         DebugLog(@"locality %@",placemark.locality);
         DebugLog(@"postalCode %@",placemark.postalCode);
         
         if (!tempLocationString)
             tempLocationString = [[NSString alloc] initWithFormat:@"%@",placemark.locality];
         else
             tempLocationString = placemark.locality;
         locationField.text = placemark.locality;
     }];
}


//*************** Method For Moving To Long Press User Location View

- (void) moveToLongPressUserLocationView {
    
    LongPressUserLocationViewController *viewObj = [[LongPressUserLocationViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:YES];
}



//*************** Method For Submitting Feedback

- (void) submitUserFeedback {
    
    if (!appDelegate.IS_SKIPPING_USER_LOGIN) {
        if ([CommonFunctions hasConnectivity]) {
            
            if (!isReportingForChatter) {
                if ([locationField.text length] == 0) {
                    [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Location is mandatory." cancel:@"OK" otherButton:nil];
                    return;
                }
            }
            if ([commentField.text length] == 0) {
                [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Comment is mandatory." cancel:@"OK" otherButton:nil];
                return;
            }
            
            if ([nameField.text length] == 0) {
                [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Name is mandatory." cancel:@"OK" otherButton:nil];
                return;
            }
            
            if ([CommonFunctions characterSet1Found:nameField.text]) {
                [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Please provide a valid name." cancel:@"OK" otherButton:nil];
                return;
            }
            
            if ([phoneField.text length] !=0) {
                if ([CommonFunctions characterSet2Found:phoneField.text]) {
                    [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Please provide a valid phone number." cancel:@"OK" otherButton:nil];
                    return;
                }
            }
            
            if ([emailField.text length] !=0) {
                if (![CommonFunctions NSStringIsValidEmail:emailField.text]) {
                    [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Please provide a valid email." cancel:@"OK" otherButton:nil];
                    return;
                }
            }
            
            NSMutableArray *parameters = [[NSMutableArray alloc] init];
            NSMutableArray *values = [[NSMutableArray alloc] init];
            
            if ([nameField.text length] != 0) {
                [parameters addObject:@"Feedback.name"];
                [values addObject:nameField.text];
            }
            if ([emailField.text length] !=0) {
                [parameters addObject:@"Feedback.email"];
                [values addObject:emailField.text];
            }
            if ([phoneField.text length] !=0) {
                [parameters addObject:@"Feedback.contactNo"];
                [values addObject:phoneField.text];
            }
            
            [parameters addObject:@"Feedback.comment"];
            [values addObject:commentField.text];
            
            if (!isReportingForChatter) {
                
                [parameters addObject:@"Feedback.locationName"];
                [values addObject:locationField.text];
                
                
                [parameters addObject:@"Feedback.locationLatitude"];
                [values addObject:[NSString stringWithFormat:@"%f",currentLocation.latitude]];
                
                [parameters addObject:@"Feedback.locationLongitude"];
                [values addObject:[NSString stringWithFormat:@"%f",currentLocation.longitude]];
                
                if (isFeedbackImageAvailable) {
                    
                    NSData* data = UIImageJPEGRepresentation(picUploadImageView.image, 0.5f);
                    NSString *base64ImageString = [Base64 encode:data];
                    
                    [parameters addObject:@"Feedback.images[0]"];
                    [values addObject:base64ImageString];
                    
                }
                else {
                    [CommonFunctions showAlertView:nil title:nil msg:@"Please provide image." cancel:@"OK" otherButton:nil];
                    return;
                }
            }
            
            if (isReportingForChatter) {
                
                [parameters addObject:@"Feedback.UserID"];
                [values addObject:[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userID"]];
                
                [parameters addObject:@"Feedback.MediaFeedID"];
                [values addObject:chatterID];
                
            }
            
            appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
            appDelegate.hud.labelText = @"Loading...";
            
            
            [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,FEEDBACK_API_URL]];
        }
        else {
            [CommonFunctions showAlertView:nil title:@"Sorry" msg:@"No internet connectivity." cancel:@"OK" otherButton:nil];
        }
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:@"Please login to submit the feedback." cancel:@"OK" otherButton:nil];
    }
}


//*************** Method To Animate To Show Picker View

- (void) showPickerView {
    
    if (isShowingPicker) {
        [feedbackPickerView reloadAllComponents];
        [feedbackPickerView selectRow:0 inComponent:0 animated:YES];
        
    }
    else {
        isShowingPicker = YES;
        
        [feedbackPickerView reloadAllComponents];
        [feedbackPickerView selectRow:0 inComponent:0 animated:YES];
        
        
        [UIView beginAnimations:@"feedbackPicker" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint pickerBgView = pickerbackground.center;
        pickerBgView.y = self.view.bounds.size.height-40;
        pickerbackground.center = pickerBgView;
        [UIView commitAnimations];
    }
}



//*************** Method To Hide Picker View

- (void) cancelPickerView {
    
    isShowingPicker = NO;
    
    [UIView beginAnimations:@"feedbackPicker" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pickerBgView = pickerbackground.center;
    pickerBgView.y = self.view.bounds.size.height+180;
    pickerbackground.center = pickerBgView;
    [UIView commitAnimations];
}


//*************** Method To Select Picker View Value

- (void) selectPickerViewValue {
    
    isShowingPicker = NO;
    
    if (fieldIndex==1) {
        feedbackTypeField.text = [feedbackTypeArray objectAtIndex:selectedPickerIndex];
        if (selectedPickerIndex==1) {
            isFloodSubmission = YES;
        }
        else {
            isFloodSubmission = NO;
        }
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [feedbackTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
    else if (fieldIndex==3) {
        commentField.text = [severityTypeArray objectAtIndex:selectedPickerIndex];
    }
    
    [UIView beginAnimations:@"feedbackPicker" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pickerBgView = pickerbackground.center;
    pickerBgView.y = self.view.bounds.size.height+180;
    pickerbackground.center = pickerBgView;
    [UIView commitAnimations];
    
}


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    [nameField resignFirstResponder];
    [emailField resignFirstResponder];
    [commentField resignFirstResponder];
    [phoneField resignFirstResponder];
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}



//*************** Method To Create Feedback Table Footer

- (void) createFeedbackTableHeader {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120)];
    [headerView setBackgroundColor:RGB(247, 247, 247)];
    
    
    picUploadImageView =[[UIImageView alloc] initWithFrame:CGRectMake((headerView.bounds.size.width/2)-40, 20, 100, 100)];
    [picUploadImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/feedback_table_header.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [headerView addSubview:picUploadImageView];
    picUploadImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheet)];
    [picUploadImageView addGestureRecognizer:tap];
    
    [feedbackTableView setTableHeaderView:headerView];
}


# pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (isReportingForChatter) {
        isReportingForChatter = NO;
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    DebugLog(@"%@",responseString);
    [appDelegate.hud hide:YES];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [CommonFunctions showAlertView:self title:[[responseString JSONValue] objectForKey:@"Message"] msg:nil cancel:@"OK" otherButton:nil];
        
        isFeedbackImageAvailable = NO;
        [picUploadImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/feedback_table_header.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        commentField.text = @"";
        emailField.text = @"";
        phoneField.text = @"";
        nameField.text = @"";
        locationField.text = @"";
        
        tempCommentString = @"";
        tempEmailString = @"";
        tempPhoneString = @"";
        tempLocationString = @"";
        tempNameString = @"";
        
        appDelegate.IS_USER_LOCATION_SELECTED_BY_LONG_PRESS = NO;
        appDelegate.LONG_PRESS_USER_LOCATION_LAT = 0.0;
        appDelegate.LONG_PRESS_USER_LOCATION_LONG = 0.0;
        
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


# pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag==1) {
        
        if (buttonIndex==0) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry..!!" message:@"Device does not have camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        else if (buttonIndex==1) {
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry..!!" message:@"Photo library does not exists." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

# pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picUploadImageView setImage:chosenImage];
    isFeedbackImageAvailable = YES;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    isFeedbackImageAvailable = NO;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

# pragma mark - UIPickerViewDataSource Method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (fieldIndex==1) {
        return feedbackTypeArray.count;
    }
    else if (fieldIndex==3) {
        return severityTypeArray.count;
    }
    
    return 0;
}



# pragma mark - UIPickerViewDelegate Method

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *rowTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    if (fieldIndex==1) {
        rowTitle.text = [feedbackTypeArray objectAtIndex:row];
    }
    else if (fieldIndex==3) {
        rowTitle.text = [severityTypeArray objectAtIndex:row];
    }
    rowTitle.font = [UIFont fontWithName:ROBOTO_MEDIUM size:17.0];
    rowTitle.textColor = RGB(35, 35, 35);
    rowTitle.textAlignment = NSTextAlignmentCenter;
    rowTitle.backgroundColor = [UIColor clearColor];
    
    return rowTitle;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    selectedPickerIndex = row;
}




# pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    nameField.text = tempNameString;
    phoneField.text = tempPhoneString;
    emailField.text = tempEmailString;
    locationField.text = tempLocationString;
    commentField.text = tempCommentString;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if ([nameField.text length]!=0) {
        if (!tempNameString)
            tempNameString = [[NSString alloc] initWithFormat:@"%@",nameField.text];
        else
            tempNameString = nameField.text;
    }
    
    if ([phoneField.text length]!=0) {
        if (!tempPhoneString)
            tempPhoneString = [[NSString alloc] initWithFormat:@"%@",phoneField.text];
        else
            tempPhoneString = phoneField.text;
    }
    
    if ([emailField.text length]!=0) {
        if (!tempEmailString)
            tempEmailString = [[NSString alloc] initWithFormat:@"%@",emailField.text];
        else
            tempEmailString = emailField.text;
    }
    
    if ([commentField.text length]!=0) {
        if (!tempCommentString)
            tempCommentString = [[NSString alloc] initWithFormat:@"%@",commentField.text];
        else
            tempCommentString = commentField.text;
    }
    
    if ([locationField.text length]!=0) {
        if (!tempLocationString)
            tempLocationString = [[NSString alloc] initWithFormat:@"%@",locationField.text];
        else
            tempLocationString = locationField.text;
    }
}



# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (isReportingForChatter) {
        if (indexPath.row==0) {
            return 120.0f;
        }
    }
    else {
        if (indexPath.row==1) {
            return 120.0f;
        }
    }
    return 45.0f;
}


# pragma mark - UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"feedback"];;
    
    cell.backgroundColor = RGB(247, 247, 247);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    cell.detailTextLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
    
    cell.textLabel.textColor = RGB(35, 35, 35);
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.numberOfLines = 0;
    
    if (isReportingForChatter) {
        
        if (indexPath.row==0) {
            
            commentField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, feedbackTableView.bounds.size.width, 120)];
            commentField.returnKeyType = UIReturnKeyDefault;
            commentField.delegate = self;
            commentField.text = @" Comments *";
            commentField.textColor = [UIColor lightGrayColor];
            commentField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
            commentField.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:commentField];
            if ([chatterText length]!=0) {
                commentField.text = chatterText;
                commentField.textColor = [UIColor blackColor];
            }
            
            UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, commentField.bounds.size.height-0.5, feedbackTableView.bounds.size.width, 0.5)];
            [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:cellSeperator];
            
            
        }
        else if (indexPath.row==1) {
            
            nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, feedbackTableView.bounds.size.width, cell.bounds.size.height-0.5)];
            nameField.textColor = RGB(35, 35, 35);
            nameField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
            nameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
            nameField.leftViewMode = UITextFieldViewModeAlways;
            nameField.borderStyle = UITextBorderStyleNone;
            nameField.textAlignment=NSTextAlignmentLeft;
            [nameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            nameField.placeholder=@"Name *";
            [cell.contentView addSubview:nameField];
            nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
            nameField.backgroundColor = [UIColor clearColor];
            nameField.delegate = self;
            [nameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            nameField.tag = 4;
            nameField.text = tempNameString;
            
            UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, nameField.bounds.size.height-0.5, feedbackTableView.bounds.size.width, 0.5)];
            [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:cellSeperator];
            
            
        }
        else if (indexPath.row==2) {
            
            phoneField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, feedbackTableView.bounds.size.width, cell.bounds.size.height-0.5)];
            phoneField.textColor = RGB(35, 35, 35);
            phoneField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
            phoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
            phoneField.leftViewMode = UITextFieldViewModeAlways;
            phoneField.borderStyle = UITextBorderStyleNone;
            phoneField.textAlignment=NSTextAlignmentLeft;
            [phoneField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            phoneField.placeholder=@"Contact No.";
            [cell.contentView addSubview:phoneField];
            phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
            phoneField.backgroundColor = [UIColor clearColor];
            phoneField.delegate = self;
            phoneField.keyboardType = UIKeyboardTypeNumberPad;
            [phoneField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            phoneField.tag = 5;
            
            UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, phoneField.bounds.size.height-0.5, feedbackTableView.bounds.size.width, 0.5)];
            [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:cellSeperator];
            
        }
        else if (indexPath.row==3) {
            
            emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, feedbackTableView.bounds.size.width, cell.bounds.size.height-0.5)];
            emailField.textColor = RGB(35, 35, 35);
            emailField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
            emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
            emailField.leftViewMode = UITextFieldViewModeAlways;
            emailField.borderStyle = UITextBorderStyleNone;
            emailField.textAlignment=NSTextAlignmentLeft;
            [emailField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            emailField.placeholder=@"Email";
            [cell.contentView addSubview:emailField];
            emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
            emailField.backgroundColor = [UIColor clearColor];
            emailField.delegate = self;
            [emailField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            emailField.tag = 5;
            emailField.keyboardType = UIKeyboardTypeEmailAddress;
            emailField.text = tempEmailString;
            
            UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, emailField.bounds.size.height-0.5, feedbackTableView.bounds.size.width, 0.5)];
            [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:cellSeperator];
            
            
        }
    }
    else {
        
        if (indexPath.row==0) {
            
            locationField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, feedbackTableView.bounds.size.width, cell.bounds.size.height-0.5)];
            locationField.textColor = RGB(35, 35, 35);
            locationField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
            locationField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
            locationField.leftViewMode = UITextFieldViewModeAlways;
            locationField.borderStyle = UITextBorderStyleNone;
            locationField.textAlignment=NSTextAlignmentLeft;
            [locationField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            locationField.placeholder=@"Location *";
            [cell.contentView addSubview:locationField];
            locationField.backgroundColor = [UIColor clearColor];
            locationField.delegate = self;
            [locationField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            locationField.tag = 2;
            
            
            UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
            locationButton.frame = CGRectMake(0, 0, 20, 20);
            [locationButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
            [locationButton addTarget:self action:@selector(moveToLongPressUserLocationView) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = locationButton;
            
            UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, locationField.bounds.size.height-0.5, feedbackTableView.bounds.size.width, 0.5)];
            [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:cellSeperator];
            
            
        }
        else if (indexPath.row==1) {
            
            commentField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, feedbackTableView.bounds.size.width, 120)];
            commentField.returnKeyType = UIReturnKeyDefault;
            commentField.delegate = self;
            commentField.text = @" Comments *";
            commentField.textColor = [UIColor lightGrayColor];
            commentField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
            commentField.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:commentField];
            
            UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, commentField.bounds.size.height-0.5, feedbackTableView.bounds.size.width, 0.5)];
            [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:cellSeperator];
            
            
        }
        else if (indexPath.row==2) {
            
            nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, feedbackTableView.bounds.size.width, cell.bounds.size.height-0.5)];
            nameField.textColor = RGB(35, 35, 35);
            nameField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
            nameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
            nameField.leftViewMode = UITextFieldViewModeAlways;
            nameField.borderStyle = UITextBorderStyleNone;
            nameField.textAlignment=NSTextAlignmentLeft;
            [nameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            nameField.placeholder=@"Name *";
            [cell.contentView addSubview:nameField];
            nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
            nameField.backgroundColor = [UIColor clearColor];
            nameField.delegate = self;
            [nameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            nameField.tag = 4;
            nameField.text = [[SharedObject sharedClass] getPUBUserSavedDataValue:@"userName"];
            
            UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, nameField.bounds.size.height-0.5, feedbackTableView.bounds.size.width, 0.5)];
            [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:cellSeperator];
            
            
        }
        else if (indexPath.row==3) {
            
            phoneField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, feedbackTableView.bounds.size.width, cell.bounds.size.height-0.5)];
            phoneField.textColor = RGB(35, 35, 35);
            phoneField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
            phoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
            phoneField.leftViewMode = UITextFieldViewModeAlways;
            phoneField.borderStyle = UITextBorderStyleNone;
            phoneField.textAlignment=NSTextAlignmentLeft;
            [phoneField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            phoneField.placeholder=@"Contact No.";
            [cell.contentView addSubview:phoneField];
            phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
            phoneField.backgroundColor = [UIColor clearColor];
            phoneField.delegate = self;
            phoneField.keyboardType = UIKeyboardTypeNumberPad;
            [phoneField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            phoneField.tag = 5;
            
            UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, phoneField.bounds.size.height-0.5, feedbackTableView.bounds.size.width, 0.5)];
            [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:cellSeperator];
            
        }
        else if (indexPath.row==4) {
            
            emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, feedbackTableView.bounds.size.width, cell.bounds.size.height-0.5)];
            emailField.textColor = RGB(35, 35, 35);
            emailField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
            emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
            emailField.leftViewMode = UITextFieldViewModeAlways;
            emailField.borderStyle = UITextBorderStyleNone;
            emailField.textAlignment=NSTextAlignmentLeft;
            [emailField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            emailField.placeholder=@"Email";
            [cell.contentView addSubview:emailField];
            emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
            emailField.backgroundColor = [UIColor clearColor];
            emailField.delegate = self;
            [emailField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
            emailField.tag = 5;
            emailField.keyboardType = UIKeyboardTypeEmailAddress;
            emailField.text = [[SharedObject sharedClass] getPUBUserSavedDataValue:@"userEmail"];
            
            UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, emailField.bounds.size.height-0.5, feedbackTableView.bounds.size.width, 0.5)];
            [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:cellSeperator];
            
            
        }
    }
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isReportingForChatter) {
        return 4;
    }
    return 5;
}



# pragma mark - UITextViewDelegate Methods

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    
    //    [commentField resignFirstResponder];
    if ([commentField.text length]!=0) {
        if (!tempCommentString)
            tempCommentString = [[NSString alloc] initWithFormat:@"%@",commentField.text];
        else
            tempCommentString = commentField.text;
    }
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        //        [commentField resignFirstResponder];
        if(commentField.text.length == 0){
            commentField.textColor = [UIColor lightGrayColor];
            //            commentField.text = @"Comments";
            //            [commentField resignFirstResponder];
        }
        else {
            commentField.text = [NSString stringWithFormat:@"%@\n",commentField.text];
        }
        return NO;
    }
    
    return YES;
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (commentField.textColor == [UIColor lightGrayColor]) {
        commentField.text = @"";
        commentField.textColor = RGB(35, 35, 35);
    }
    
    CGPoint origin = textView.frame.origin;
    CGPoint point = [textView.superview convertPoint:origin toView:self.view];
    float navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGPoint offset = feedbackTableView.contentOffset;
    
    // Adjust the below value as you need
    offset.y += (point.y - navBarHeight -50);
    [feedbackTableView setContentOffset:offset animated:YES];
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(commentField.text.length == 0){
        commentField.textColor = [UIColor lightGrayColor];
        //        commentField.text = @"Comments";
        [commentField resignFirstResponder];
    }
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    
    CGPoint offset;
    offset.x = 0.0;
    offset.y = 0.0;
    [feedbackTableView setContentOffset:offset animated:YES];
    
    if ([commentField.text length]!=0) {
        if (!tempCommentString)
            tempCommentString = [[NSString alloc] initWithFormat:@"%@",commentField.text];
        else
            tempCommentString = commentField.text;
    }
}


# pragma mark - UITextFieldDelegate Methods


- (void)textFieldDidEndEditing:(UITextField *)textField  {
    
    if (textField==nameField) {
        if ([nameField.text length]!=0) {
            if (!tempNameString)
                tempNameString = [[NSString alloc] initWithFormat:@"%@",nameField.text];
            else
                tempNameString = nameField.text;
        }
    }
    
    if (textField==phoneField) {
        if ([phoneField.text length]!=0) {
            if (!tempPhoneString)
                tempPhoneString = [[NSString alloc] initWithFormat:@"%@",phoneField.text];
            else
                tempPhoneString = phoneField.text;
        }
    }
    
    if (textField==emailField) {
        if ([emailField.text length]!=0) {
            if (!tempEmailString)
                tempEmailString = [[NSString alloc] initWithFormat:@"%@",emailField.text];
            else
                tempEmailString = emailField.text;
        }
    }
    
    if (textField==locationField) {
        if ([locationField.text length]!=0) {
            if (!tempLocationString)
                tempLocationString = [[NSString alloc] initWithFormat:@"%@",locationField.text];
            else
                tempLocationString = locationField.text;
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    fieldIndex = textField.tag;
    [commentField resignFirstResponder];
    
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:self.view];
    float navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGPoint offset = feedbackTableView.contentOffset;
    
    // Adjust the below value as you need
    offset.y += (point.y - navBarHeight -50);
    [feedbackTableView setContentOffset:offset animated:YES];
    
    if (isFloodSubmission) {
        //        if (textField == feedbackTypeField || textField == commentField) {
        if (textField == feedbackTypeField) {
            selectedPickerIndex = 0;
            [feedbackPickerView reloadComponent:0];
            [self showPickerView];
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        if (textField == feedbackTypeField) {
            selectedPickerIndex = 0;
            [feedbackPickerView reloadComponent:0];
            [self showPickerView];
            
            return NO;
        }
        else {
            return YES;
        }
    }
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    CGPoint offset;
    offset.x = 0.0;
    offset.y = 0.0;
    [feedbackTableView setContentOffset:offset animated:YES];
    [textField resignFirstResponder];
    return YES;
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (!isReportingForChatter)
        [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(callPUBHelpdesk) withIconName:@"icn_call"]];
    
    if (isReportingForChatter) {
        self.title = @"Report/Feedback";
    }
    
    fieldIndex = 1;
    
    isFloodSubmission = NO;
    feedbackTypeArray = [[NSArray alloc] initWithObjects:@"Dirty/Choked Drain",@"Flood Area Submission",@"Water Leak",@"Poor Water Pressure Quality",@"Reports Feeds",@"Sewer Choke/Overflow/Smell",@"Others", nil];
    severityTypeArray = [[NSArray alloc] initWithObjects:@"Light",@"Heavy",@"Severe", nil];
    
    feedbackTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-110) style:UITableViewStylePlain];
    feedbackTableView.delegate = self;
    feedbackTableView.dataSource = self;
    [self.view addSubview:feedbackTableView];
    feedbackTableView.backgroundColor = RGB(247, 247, 247);
    feedbackTableView.backgroundView = nil;
    feedbackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    feedbackTableView.scrollEnabled = NO;
    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, self.view.bounds.size.height-114, self.view.bounds.size.width, 50);
    [submitButton setBackgroundColor:RGB(82, 82, 82)];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:18];
    [submitButton addTarget:self action:@selector(submitUserFeedback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    if (!isReportingForChatter)
        [self createFeedbackTableHeader];
    
    
    pickerbackground = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 220)];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *cancelPicker = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPickerView)];
    UIBarButtonItem *selectPicker = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectPickerViewValue)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:cancelPicker,flexibleSpace,selectPicker, nil]];
    [pickerbackground addSubview:toolBar];
    
    
    feedbackPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 180)];
    feedbackPickerView.delegate=self;
    feedbackPickerView.dataSource=self;
    feedbackPickerView.backgroundColor = RGB(247, 247, 247);
    feedbackPickerView.showsSelectionIndicator=YES;
    
    [pickerbackground addSubview:feedbackPickerView];
    [appDelegate.window addSubview:pickerbackground];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    selectedPickerIndex = 0;
    [appDelegate setShouldRotate:NO];
    
    if (!isNotFeedbackController) {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    }
    else {
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(113, 75, 51) frame:CGRectMake(0, 0, 1, 1)];
        [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
        [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
        [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
        [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
        
        self.title = @"Report/Feedback";
        
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
        
    }
    
    if (isReportingForChatter) {
        tempCommentString = chatterText;
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    }
    
    tempNameString = [[SharedObject sharedClass] getPUBUserSavedDataValue:@"userName"];
    tempEmailString = [[SharedObject sharedClass] getPUBUserSavedDataValue:@"userEmail"];
    
    //    if (([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) || ![CLLocationManager locationServicesEnabled]) {
    //        [CommonFunctions checkForLocationSerives:@"Location Serives Disabled" message:@"Location is mandatory for feedback. Please turn on location serives from settings." view:self];
    //        return;
    //    }
    
    if (appDelegate.IS_USER_LOCATION_SELECTED_BY_LONG_PRESS) {
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:appDelegate.LONG_PRESS_USER_LOCATION_LAT longitude:appDelegate.LONG_PRESS_USER_LOCATION_LONG];
        [self getAddressFromLatLon:location];
    }
    else {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:appDelegate.CURRENT_LOCATION_LAT longitude:appDelegate.CURRENT_LOCATION_LONG];
        [self getAddressFromLatLon:location];
    }
    
}


- (void) viewWillDisappear:(BOOL)animated {
    
    for (ASIHTTPRequest *req in ASIHTTPRequest.sharedQueue.operations)
    {
        [req cancel];
        [req setDelegate:nil];
    }
    
    [self cancelPickerView];
}


- (void) viewDidAppear:(BOOL)animated {
    
    //    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
    //    swipeGesture.numberOfTouchesRequired = 1;
    //    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
    //
    //    [self.view addGestureRecognizer:swipeGesture];
    
    
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
