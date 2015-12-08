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
@synthesize isReportingForChatter,chatterID,chatterText,isEditingComment;


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Show UIActionSheet

- (void) showActionSheet {
    
    [nameField resignFirstResponder];
    [locationField resignFirstResponder];
    [commentField resignFirstResponder];
    [phoneField resignFirstResponder];
    [emailField resignFirstResponder];
    
    if (uploadedImageCount!=3) {
        [CommonFunctions showActionSheet:self containerView:self.view.window title:@"Select Source" msg:nil cancel:nil tag:1 destructive:nil otherButton:@"Take Photo",@"Photo Library",@"Cancel",nil];
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:@"Max 3 pictures allowed." cancel:@"OK" otherButton:nil];
    }
    
}


//*************** Method To Clear Uploaded Image

- (void) clearUploadedImage:(id) sender {
    
    uploadedImageCount = uploadedImageCount - 1;
    UIButton *button = (id) sender;
    
    if (button.tag==1) {
        
        uploadedImageView1.image = nil;
        removeUploadImageButton1.hidden = YES;
        
        if (uploadedImageView2.image!=nil) {
            uploadedImageView1.image = uploadedImageView2.image;
            removeUploadImageButton1.hidden = NO;
            uploadedImageView2.image = nil;
            removeUploadImageButton2.hidden = YES;
        }
        if (uploadedImageView3.image!=nil) {
            uploadedImageView2.image = uploadedImageView3.image;
            removeUploadImageButton2.hidden = NO;
            uploadedImageView3.image = nil;
            removeUploadImageButton3.hidden = YES;
        }
    }
    else if (button.tag==2) {
        
        uploadedImageView2.image = nil;
        removeUploadImageButton2.hidden = YES;
        
        if (uploadedImageView3.image!=nil) {
            uploadedImageView2.image = uploadedImageView3.image;
            removeUploadImageButton2.hidden = NO;
            uploadedImageView3.image = nil;
            removeUploadImageButton3.hidden = YES;
        }
    }
    else if (button.tag==3) {
        
        uploadedImageView2.image = nil;
        removeUploadImageButton2.hidden = YES;
    }
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
        [CommonFunctions showAlertView:nil title:nil msg:@"No contact available." cancel:@"Ok" otherButton:nil];
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
         //         DebugLog(@"placemark --  %@",placemark);
         //         DebugLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
         //         DebugLog(@"locality %@",placemark.locality);
         //         DebugLog(@"postalCode %@",placemark.postalCode);
         
         NSString *subThoroughFareString,*thoroughFareString,*localityString;
         if (placemark.subThoroughfare != (id)[NSNull null] && [placemark.subThoroughfare length] !=0) {
             subThoroughFareString = placemark.subThoroughfare;
         }
         else {
             subThoroughFareString = @"";
         }
         if (placemark.thoroughfare != (id)[NSNull null] && [placemark.thoroughfare length] !=0) {
             thoroughFareString = placemark.thoroughfare;
         }
         else {
             thoroughFareString = @"";
         }
         if (placemark.locality != (id)[NSNull null] && [placemark.locality length] !=0) {
             localityString = placemark.locality;
         }
         else {
             localityString = @"";
         }
         //         if (placemark.postalCode != (id)[NSNull null] && [placemark.postalCode length] !=0) {
         //             postalString = placemark.postalCode;
         //         }
         //         else {
         //             postalString = @"";
         //         }
         
         if (!tempLocationString)
             tempLocationString = [[NSString alloc] initWithFormat:@"%@ %@ %@",subThoroughFareString,thoroughFareString,localityString];
         else
             tempLocationString = [NSString stringWithFormat:@"%@ %@ %@",subThoroughFareString,thoroughFareString,localityString];
         
         locationField.text = [NSString stringWithFormat:@"%@ %@ %@",subThoroughFareString,thoroughFareString,localityString];
     }];
}


//*************** Method For Moving To Long Press User Location View

- (void) moveToLongPressUserLocationView {
    
    LongPressUserLocationViewController *viewObj = [[LongPressUserLocationViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:YES];
}



//*************** Method For Submitting Feedback

- (void) submitUserFeedback {
    
    //    if (!appDelegate.IS_SKIPPING_USER_LOGIN) {
    if ([CommonFunctions hasConnectivity]) {
        
        if (!isReportingForChatter) {
            if ([locationField.text length] == 0) {
                [CommonFunctions showAlertView:nil title:nil msg:@"Required info missing." cancel:@"OK" otherButton:nil];
                return;
            }
        }
        if ([commentField.text length] == 0) {
            [CommonFunctions showAlertView:nil title:nil msg:@"Required info missing." cancel:@"OK" otherButton:nil];
            return;
        }
        
        if ([nameField.text length] == 0) {
            [CommonFunctions showAlertView:nil title:nil msg:@"Required info missing." cancel:@"OK" otherButton:nil];
            return;
        }
        
        if ([CommonFunctions characterSet1Found:nameField.text]) {
            [CommonFunctions showAlertView:nil title:nil msg:@"Provide valid name." cancel:@"OK" otherButton:nil];
            return;
        }
        
        if ([phoneField.text length] !=0) {
            if ([CommonFunctions characterSet2Found:phoneField.text]) {
                [CommonFunctions showAlertView:nil title:nil msg:@"Provide valid contact number." cancel:@"OK" otherButton:nil];
                return;
            }
        }
        
        if ([emailField.text length] !=0) {
            if (![CommonFunctions NSStringIsValidEmail:emailField.text]) {
                [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Provide  valid e-mail address." cancel:@"OK" otherButton:nil];
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
            [values addObject:[NSString stringWithFormat:@"%f",appDelegate.CURRENT_LOCATION_LAT]];
            
            [parameters addObject:@"Feedback.locationLongitude"];
            [values addObject:[NSString stringWithFormat:@"%f",appDelegate.CURRENT_LOCATION_LONG]];
            
            if (uploadedImageCount>0) {
                
                if (uploadedImageView1.image!=nil) {
                    NSData* data = UIImageJPEGRepresentation(uploadedImageView1.image, 0.5f);
                    NSString *base64ImageString = [Base64 encode:data];
                
                    [parameters addObject:@"Feedback.images[0]"];
                    [values addObject:base64ImageString];
                }
                if (uploadedImageView2.image!=nil) {
                    NSData* data = UIImageJPEGRepresentation(uploadedImageView2.image, 0.5f);
                    NSString *base64ImageString = [Base64 encode:data];
                    
                    [parameters addObject:@"Feedback.images[1]"];
                    [values addObject:base64ImageString];
                }
                if (uploadedImageView3.image!=nil) {
                    NSData* data = UIImageJPEGRepresentation(uploadedImageView3.image, 0.5f);
                    NSString *base64ImageString = [Base64 encode:data];
                    
                    [parameters addObject:@"Feedback.images[2]"];
                    [values addObject:base64ImageString];
                }
            }

        }
        
        if (isReportingForChatter) {
            
            if ([[SharedObject sharedClass] getPUBUserSavedDataValue:@"userID"] != (id)[NSNull null] && [[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userID"] length] != 0) {
                [parameters addObject:@"Feedback.UserID"];
                [values addObject:[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userID"]];
            }
            
            [parameters addObject:@"Feedback.MediaFeedID"];
            [values addObject:chatterID];
            
        }
        
        [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
        
        [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,FEEDBACK_API_URL]];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Connection error. Check your internet connection." msg:nil cancel:@"OK" otherButton:nil];
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 140)];
    [headerView setBackgroundColor:RGB(247, 247, 247)];
    
    
    picUploadImageView =[[UIImageView alloc] initWithFrame:CGRectMake((headerView.bounds.size.width/2)-35, 20, 70, 70)];
    [picUploadImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_feedback_new.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [headerView addSubview:picUploadImageView];
    picUploadImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheet)];
    [picUploadImageView addGestureRecognizer:tap];
    
    [feedbackTableView setTableHeaderView:headerView];
}


//*************** Method For Removing Key Pads

- (void) hideKeyPads {
    
    hideKeyPadsButton.hidden = YES;
    
    [commentField resignFirstResponder];
    [nameField resignFirstResponder];
    [locationField resignFirstResponder];
    [phoneField resignFirstResponder];
    [emailField resignFirstResponder];
}



//*************** Method To Detect Touch In UITextView

-(void) handleSingleTap:(UITapGestureRecognizer *)gesture {
    
    hideKeyPadsButton.hidden = NO;
    [commentField becomeFirstResponder];
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
    [CommonFunctions dismissGlobalHUD];
    //    [appDelegate.hud hide:YES];
    
    [backgroundScrollView setContentOffset:CGPointZero animated:NO];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [CommonFunctions showAlertView:self title:[[responseString JSONValue] objectForKey:@"Message"] msg:nil cancel:@"OK" otherButton:nil];
        
        [picUploadImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_feedback_new.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        
        uploadedImageView1.image = nil;
        uploadedImageView2.image = nil;
        uploadedImageView3.image = nil;
        uploadedImageCount = 0;
        
        removeUploadImageButton1.hidden = YES;
        removeUploadImageButton2.hidden = YES;
        removeUploadImageButton3.hidden = YES;
        
        commentField.text = @"";
//        emailField.text = @"";
//        phoneField.text = @"";
//        nameField.text = @"";
//        locationField.text = @"";
        
        tempCommentString = @"";
//        tempEmailString = @"";
//        tempPhoneString = @"";
//        tempLocationString = @"";
//        tempNameString = @"";
        
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
    [CommonFunctions dismissGlobalHUD];
    //    [appDelegate.hud hide:YES];
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry..!!" message:@"Camera not found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry..!!" message:@"Photo library not found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

# pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    uploadedImageCount = uploadedImageCount + 1;
    
    if (uploadedImageCount==1) {
        [uploadedImageView1 setImage:chosenImage];
        removeUploadImageButton1.hidden = NO;
    }
    else if (uploadedImageCount==2) {
        [uploadedImageView2 setImage:chosenImage];
        removeUploadImageButton2.hidden = NO;
    }
    else if (uploadedImageCount==3) {
        [uploadedImageView3 setImage:chosenImage];
        removeUploadImageButton3.hidden = NO;
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
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
            
            commentField = [[SAMTextView alloc] initWithFrame:CGRectMake(0, 0, feedbackTableView.bounds.size.width, 120)];
            commentField.returnKeyType = UIReturnKeyDefault;
            commentField.delegate = self;
            commentField.text = @" Comments *";
            commentField.textColor = [UIColor lightGrayColor];
            commentField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
            commentField.backgroundColor = [UIColor clearColor];
            //            [commentField setUserInteractionEnabled:YES];
            //            [commentField setScrollEnabled:YES];
            //            [commentField setSelectedRange:NSMakeRange(0, [[commentField textStorage] length])];
            //            [commentField insertText:@""];
            //            [commentField setText:@""];
            
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
            
            locationField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, feedbackTableView.bounds.size.width-50, cell.bounds.size.height-0.5)];
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
            
            commentField = [[SAMTextView alloc] initWithFrame:CGRectMake(0, 0, feedbackTableView.bounds.size.width, 120)];
            commentField.returnKeyType = UIReturnKeyDefault;
            commentField.delegate = self;
            commentField.text = @" Comments *";
            commentField.textColor = [UIColor lightGrayColor];
            commentField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
            commentField.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:commentField];
            //            [commentField setUserInteractionEnabled:YES];
            //            [commentField setScrollEnabled:YES];
            //            [commentField setSelectedRange:NSMakeRange(0, [[commentField textStorage] length])];
            //            [commentField insertText:@""];
            //            [commentField setText:@""];
            
            
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    hideKeyPadsButton.hidden = NO;
    return YES;
}

# pragma mark - UITextFieldDelegate Methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    hideKeyPadsButton.hidden = NO;
    
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:self.view];
    float navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGPoint offset = backgroundScrollView.contentOffset;
    
    // Adjust the below value as you need
    offset.y += (point.y - navBarHeight -50);
    [backgroundScrollView setContentOffset:offset animated:NO];
}

- (void)textFieldDidEndEditing:(UITextField *)textField  {
    
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:self.view];
    float navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGPoint offset = backgroundScrollView.contentOffset;
    
    // Adjust the below value as you need
    offset.y += (point.y - navBarHeight -50);
    [backgroundScrollView setContentOffset:offset animated:NO];
    
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
    //    [commentField resignFirstResponder];
    hideKeyPadsButton.hidden = NO;
    
    if (!tempCommentString) {
        tempCommentString = [[NSString alloc] initWithFormat:@"%@",commentField.text];
    }
    else {
        tempCommentString = commentField.text;
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    hideKeyPadsButton.hidden = YES;
    [textField resignFirstResponder];
    return YES;
}



# pragma mark - UIGestureDelegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    uploadedImageCount = 0;
    
    if (!isReportingForChatter)
        [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(callPUBHelpdesk) withIconName:@"icn_call"]];
    
    if (isReportingForChatter) {
        self.title = @"Report/Feedback";
    }
    
    fieldIndex = 1;
    
    isFloodSubmission = NO;
    //    feedbackTypeArray = [[NSArray alloc] initWithObjects:@"Dirty/Choked Drain",@"Flood Area Submission",@"Water Leak",@"Poor Water Pressure Quality",@"Reports Feeds",@"Sewer Choke/Overflow/Smell",@"Others", nil];
    //    severityTypeArray = [[NSArray alloc] initWithObjects:@"Light",@"Heavy",@"Severe", nil];
    
    //    feedbackTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-110) style:UITableViewStylePlain];
    //    feedbackTableView.delegate = self;
    //    feedbackTableView.dataSource = self;
    //    [self.view addSubview:feedbackTableView];
    //    feedbackTableView.backgroundColor = RGB(247, 247, 247);
    //    feedbackTableView.backgroundView = nil;
    //    feedbackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-114)];
    backgroundScrollView.backgroundColor = RGB(247, 247, 247);
    backgroundScrollView.showsHorizontalScrollIndicator = NO;
    backgroundScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backgroundScrollView];
    backgroundScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    backgroundScrollView.userInteractionEnabled = YES;
    
    
    picUploadImageView =[[UIImageView alloc] initWithFrame:CGRectMake((backgroundScrollView.bounds.size.width/2)-35, 10, 70, 70)];
    [picUploadImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_feedback_new.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [backgroundScrollView addSubview:picUploadImageView];
    picUploadImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheet)];
    [picUploadImageView addGestureRecognizer:tap];
    
    uploadedImageView1 =[[UIImageView alloc] initWithFrame:CGRectMake((backgroundScrollView.bounds.size.width-180)/4, picUploadImageView.frame.origin.y+picUploadImageView.bounds.size.height+20, 60, 60)];
    [uploadedImageView1 setBackgroundColor:[UIColor whiteColor]];
    [backgroundScrollView addSubview:uploadedImageView1];
    uploadedImageView1.userInteractionEnabled = YES;
    
    removeUploadImageButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
    removeUploadImageButton1.frame = CGRectMake(uploadedImageView1.bounds.size.width-9, -9, 18, 18);
    [removeUploadImageButton1 setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/remove_icon.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    removeUploadImageButton1.tag = 1;
    [removeUploadImageButton1 addTarget:self action:@selector(clearUploadedImage:) forControlEvents:UIControlEventTouchUpInside];
    [uploadedImageView1 addSubview:removeUploadImageButton1];
    [uploadedImageView1 bringSubviewToFront:removeUploadImageButton1];
    removeUploadImageButton1.hidden = YES;
    
    uploadedImageView2 =[[UIImageView alloc] initWithFrame:CGRectMake(((backgroundScrollView.bounds.size.width-180)/4)*2+60, picUploadImageView.frame.origin.y+picUploadImageView.bounds.size.height+20, 60, 60)];
    [uploadedImageView2 setBackgroundColor:[UIColor whiteColor]];
    [backgroundScrollView addSubview:uploadedImageView2];
    uploadedImageView2.userInteractionEnabled = YES;
    
    removeUploadImageButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    removeUploadImageButton2.frame = CGRectMake(uploadedImageView2.bounds.size.width-9, -9, 18, 18);
    [removeUploadImageButton2 setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/remove_icon.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    removeUploadImageButton2.tag = 2;
    [removeUploadImageButton2 addTarget:self action:@selector(clearUploadedImage:) forControlEvents:UIControlEventTouchUpInside];
    [uploadedImageView2 addSubview:removeUploadImageButton2];
    [uploadedImageView2 bringSubviewToFront:removeUploadImageButton2];
    removeUploadImageButton2.hidden = YES;
    
    uploadedImageView3 =[[UIImageView alloc] initWithFrame:CGRectMake(((backgroundScrollView.bounds.size.width-180)/4)*3+120, picUploadImageView.frame.origin.y+picUploadImageView.bounds.size.height+20, 60, 60)];
    [uploadedImageView3 setBackgroundColor:[UIColor whiteColor]];
    [backgroundScrollView addSubview:uploadedImageView3];
    uploadedImageView3.userInteractionEnabled = YES;
    
    removeUploadImageButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    removeUploadImageButton3.frame = CGRectMake(uploadedImageView3.bounds.size.width-9, -9, 18, 18);
    [removeUploadImageButton3 setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/remove_icon.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    removeUploadImageButton3.tag = 3;
    [removeUploadImageButton3 addTarget:self action:@selector(clearUploadedImage:) forControlEvents:UIControlEventTouchUpInside];
    [uploadedImageView3 addSubview:removeUploadImageButton3];
    [uploadedImageView3 bringSubviewToFront:removeUploadImageButton3];
    removeUploadImageButton3.hidden = YES;
    
    locationField = [[UITextField alloc] initWithFrame:CGRectMake(10, uploadedImageView1.frame.origin.y+uploadedImageView1.bounds.size.height+30, backgroundScrollView.bounds.size.width-20, 40)];
    locationField.textColor = RGB(35, 35, 35);
    locationField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    locationField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    locationField.leftViewMode = UITextFieldViewModeAlways;
    locationField.borderStyle = UITextBorderStyleNone;
    locationField.textAlignment=NSTextAlignmentLeft;
    [locationField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    locationField.placeholder=@"Location *";
    [backgroundScrollView addSubview:locationField];
    locationField.backgroundColor = [UIColor clearColor];
    [locationField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    locationField.delegate = self;
    [locationField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    locationField.tag = 2;
    
    
    UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    locationButton.frame = CGRectMake(backgroundScrollView.bounds.size.width-30, uploadedImageView1.frame.origin.y+uploadedImageView1.bounds.size.height+40, 20, 20);
    [locationButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_location.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(moveToLongPressUserLocationView) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:locationButton];
    
    
    commentField = [[SAMTextView alloc] initWithFrame:CGRectMake(10, locationField.frame.origin.y+locationField.bounds.size.height+10, backgroundScrollView.bounds.size.width-20, 120)];
    commentField.returnKeyType = UIReturnKeyDefault;
    commentField.placeholder = @"Enter comments here *";
    commentField.textColor = [UIColor blackColor];
    commentField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    commentField.backgroundColor = [UIColor whiteColor];
    commentField.layer.borderWidth = 1.0;
    commentField.layer.cornerRadius = 5.0;
    commentField.layer.borderColor = [[UIColor blackColor] CGColor];
    commentField.layer.masksToBounds = YES;
    [backgroundScrollView addSubview:commentField];
    [commentField setUserInteractionEnabled:YES];
    [commentField setScrollEnabled:YES];
    commentField.showsVerticalScrollIndicator = YES;
    
    UITapGestureRecognizer *commentTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    commentTapGesture.delegate = self;
    [commentField addGestureRecognizer:commentTapGesture];
    
    
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, commentField.frame.origin.y+commentField.bounds.size.height+10, backgroundScrollView.bounds.size.width-20, 40)];
    nameField.textColor = RGB(35, 35, 35);
    nameField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    nameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    nameField.leftViewMode = UITextFieldViewModeAlways;
    nameField.borderStyle = UITextBorderStyleNone;
    nameField.textAlignment=NSTextAlignmentLeft;
    [nameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    nameField.placeholder=@"Name *";
    [backgroundScrollView addSubview:nameField];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.backgroundColor = [UIColor clearColor];
    [nameField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    nameField.delegate = self;
    [nameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    nameField.tag = 4;
    nameField.text = [[SharedObject sharedClass] getPUBUserSavedDataValue:@"userName"];
    
    phoneField = [[UITextField alloc] initWithFrame:CGRectMake(10, nameField.frame.origin.y+nameField.bounds.size.height+10, backgroundScrollView.bounds.size.width-20, 40)];
    phoneField.textColor = RGB(35, 35, 35);
    phoneField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    phoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    phoneField.leftViewMode = UITextFieldViewModeAlways;
    phoneField.borderStyle = UITextBorderStyleNone;
    phoneField.textAlignment=NSTextAlignmentLeft;
    [phoneField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    phoneField.placeholder=@"Contact No.";
    [backgroundScrollView addSubview:phoneField];
    phoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneField.backgroundColor = [UIColor clearColor];
    [phoneField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    phoneField.delegate = self;
    phoneField.keyboardType = UIKeyboardTypeNumberPad;
    [phoneField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    phoneField.tag = 5;
    
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, phoneField.frame.origin.y+phoneField.bounds.size.height+10, backgroundScrollView.bounds.size.width-20, 40)];
    emailField.textColor = RGB(35, 35, 35);
    emailField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    emailField.leftViewMode = UITextFieldViewModeAlways;
    emailField.borderStyle = UITextBorderStyleNone;
    emailField.textAlignment=NSTextAlignmentLeft;
    [emailField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    emailField.placeholder=@"Email";
    [backgroundScrollView addSubview:emailField];
    emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailField.backgroundColor = [UIColor clearColor];
    [emailField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    emailField.delegate = self;
    [emailField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    emailField.tag = 5;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    emailField.text = [[SharedObject sharedClass] getPUBUserSavedDataValue:@"userEmail"];
    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, self.view.bounds.size.height-114, self.view.bounds.size.width, 50);
    [submitButton setBackgroundColor:RGB(82, 82, 82)];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:17];
    [submitButton addTarget:self action:@selector(submitUserFeedback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    hideKeyPadsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hideKeyPadsButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [hideKeyPadsButton addTarget:self action:@selector(hideKeyPads) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:hideKeyPadsButton];
    [backgroundScrollView sendSubviewToBack:hideKeyPadsButton];
    hideKeyPadsButton.hidden = YES;
    
    //    if (!isReportingForChatter)
    //        [self createFeedbackTableHeader];
    
    
    //    pickerbackground = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 220)];
    //
    //    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    //    toolBar.barStyle = UIBarStyleBlackOpaque;
    //
    //    UIBarButtonItem *cancelPicker = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPickerView)];
    //    UIBarButtonItem *selectPicker = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectPickerViewValue)];
    //    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //
    //    [toolBar setItems:[NSArray arrayWithObjects:cancelPicker,flexibleSpace,selectPicker, nil]];
    //    [pickerbackground addSubview:toolBar];
    //
    //
    //    feedbackPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 180)];
    //    feedbackPickerView.delegate=self;
    //    feedbackPickerView.dataSource=self;
    //    feedbackPickerView.backgroundColor = RGB(247, 247, 247);
    //    feedbackPickerView.showsSelectionIndicator=YES;
    //
    //    [pickerbackground addSubview:feedbackPickerView];
    //    [appDelegate.window addSubview:pickerbackground];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    selectedPickerIndex = 0;
    [appDelegate setShouldRotate:NO];
    
    [CommonFunctions googleAnalyticsTracking:@"Page: Feedback"];
    
    if (!isNotFeedbackController) {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    }
    else {
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(219, 22, 31) frame:CGRectMake(0, 0, 1, 1)];
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
