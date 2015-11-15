//
//  UserFloodSubmissionViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 22/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import "UserFloodSubmissionViewController.h"

@interface UserFloodSubmissionViewController ()

@end

@implementation UserFloodSubmissionViewController
@synthesize tempLocationString,tempCommentString,floodSubmissionLat,floodSubmissionLon;;

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
             tempLocationString = [[NSString alloc] initWithFormat:@"%@ %@, %@",subThoroughFareString,thoroughFareString,localityString];
         else
             tempLocationString = [NSString stringWithFormat:@"%@ %@, %@",subThoroughFareString,thoroughFareString,localityString];
         
         locationField.text = [NSString stringWithFormat:@"%@ %@, %@",subThoroughFareString,thoroughFareString,localityString];
     }];
}


//*************** Method For Submitting Feedback

- (void) submitUserFloodSubmissionFeedback {
    
    if ([CommonFunctions hasConnectivity]) {
    if ([locationField.text length] == 0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Location is mandatory." cancel:@"OK" otherButton:nil];
        return;
    }
    
    if ([commentField.text length] == 0) {
        [CommonFunctions showAlertView:nil title:@"Sorry!" msg:@"Comment is mandatory." cancel:@"OK" otherButton:nil];
        return;
    }
    
        
    [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
    
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    
    [parameters addObject:@"FloodSubmission.Comment"];
    [values addObject:commentField.text];
    
    [parameters addObject:@"FloodSubmission.LocationName"];
    [values addObject:locationField.text];
    
    [parameters addObject:@"FloodSubmission.Lat"];
    [values addObject:[NSString stringWithFormat:@"%f",floodSubmissionLat]];
    
    [parameters addObject:@"FloodSubmission.Lon"];
    [values addObject:[NSString stringWithFormat:@"%f",floodSubmissionLon]];
    
    
    if (isFeedbackImageAvailable) {
        
        NSData* data = UIImageJPEGRepresentation(picUploadImageView.image, 0.5f);
        NSString *base64ImageString = [Base64 encode:data];
        
        [parameters addObject:@"FloodSubmission.Image"];
        [values addObject:base64ImageString];
        
    }
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,USER_FLOOD_SUBMISSION]];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"No internet connectivity." msg:nil cancel:@"OK" otherButton:nil];
    }
    
}


//*************** Method To Show UIActionSheet

- (void) showActionSheet {
    
    [locationField resignFirstResponder];
    [commentField resignFirstResponder];
    
    [CommonFunctions showActionSheet:self containerView:self.view.window title:@"Select Source" msg:nil cancel:nil tag:1 destructive:nil otherButton:@"Take Photo",@"Photo Library",@"Cancel",nil];
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [floodSubmissionTableView setTableHeaderView:headerView];
}


//*************** Method To Detect Touch In UITextView

-(void) handleSingleTap:(UITapGestureRecognizer *)gesture {
    
    hideKeyPadsButton.hidden = NO;
    [commentField becomeFirstResponder];
}

//*************** Method For Removing Key Pads

- (void) hideKeyPads {
    
    hideKeyPadsButton.hidden = YES;
    
    [commentField resignFirstResponder];
    [locationField resignFirstResponder];
}


# pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    DebugLog(@"%@",responseString);
    [backgroundScrollView setContentOffset:CGPointZero animated:NO];
    
    [CommonFunctions dismissGlobalHUD];
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [CommonFunctions showAlertView:self title:[[responseString JSONValue] objectForKey:@"Message"] msg:nil cancel:@"OK" otherButton:nil];
        
        isFeedbackImageAvailable = NO;
        [picUploadImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_feedback_new.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        commentField.text = @"";
        
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



# pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    locationField.text = tempLocationString;
    commentField.text = tempCommentString;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
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
    
    if (indexPath.row==1) {
        return 120.0f;
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
    
    
    if (indexPath.row==0) {
        
        locationField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, floodSubmissionTableView.bounds.size.width, cell.bounds.size.height-0.5)];
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
        
        
        UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, locationField.bounds.size.height-0.5, locationField.bounds.size.width, 0.5)];
        [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:cellSeperator];
        
        
    }
    else if (indexPath.row==1) {
        
        commentField = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, floodSubmissionTableView.bounds.size.width, 120)];
        commentField.returnKeyType = UIReturnKeyDefault;
        commentField.delegate = self;
        commentField.text = @" Comments *";
        commentField.textColor = [UIColor lightGrayColor];
        commentField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
        commentField.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:commentField];
        
        UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, commentField.bounds.size.height-0.5, commentField.bounds.size.width, 0.5)];
        [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:cellSeperator];
        
        
    }
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}



# pragma mark - UITextFieldDelegate Methods


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    hideKeyPadsButton.hidden = NO;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField  {
    
    hideKeyPadsButton.hidden = YES;
    
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:self.view];
    float navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGPoint offset = backgroundScrollView.contentOffset;
    
    // Adjust the below value as you need
    offset.y += (point.y - navBarHeight -50);
    [backgroundScrollView setContentOffset:offset animated:NO];
    
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
    
    hideKeyPadsButton.hidden = NO;
    [commentField resignFirstResponder];
    
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:self.view];
    float navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGPoint offset = backgroundScrollView.contentOffset;
    
    // Adjust the below value as you need
    offset.y += (point.y - navBarHeight -50);
    [backgroundScrollView setContentOffset:offset animated:YES];
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    CGPoint offset;
    offset.x = 0.0;
    offset.y = 0.0;
    [backgroundScrollView setContentOffset:offset animated:YES];
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
    self.title = @"Flood Submission";
    self.view.backgroundColor = RGB(242, 242, 242);
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];

    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];

    
//    floodSubmissionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60) style:UITableViewStylePlain];
//    floodSubmissionTableView.delegate = self;
//    floodSubmissionTableView.dataSource = self;
//    [self.view addSubview:floodSubmissionTableView];
//    floodSubmissionTableView.backgroundColor = RGB(247, 247, 247);
//    floodSubmissionTableView.backgroundView = nil;
//    floodSubmissionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-114)];
    backgroundScrollView.backgroundColor = RGB(247, 247, 247);
    backgroundScrollView.showsHorizontalScrollIndicator = NO;
    backgroundScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backgroundScrollView];
    backgroundScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    backgroundScrollView.userInteractionEnabled = YES;
    
    
    picUploadImageView =[[UIImageView alloc] initWithFrame:CGRectMake((backgroundScrollView.bounds.size.width/2)-50, 20, 100, 100)];
    [picUploadImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_feedback_new.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [backgroundScrollView addSubview:picUploadImageView];
    picUploadImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheet)];
    [picUploadImageView addGestureRecognizer:tap];
    
    
    
    locationField = [[UITextField alloc] initWithFrame:CGRectMake(10, picUploadImageView.frame.origin.y+picUploadImageView.bounds.size.height+30, backgroundScrollView.bounds.size.width-20, 40)];
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
    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, self.view.bounds.size.height-114, self.view.bounds.size.width, 50);
    [submitButton setBackgroundColor:RGB(82, 82, 82)];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:18];
    [submitButton addTarget:self action:@selector(submitUserFloodSubmissionFeedback) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
//    [self createFeedbackTableHeader];
    
    hideKeyPadsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hideKeyPadsButton.frame = CGRectMake(0, 0, backgroundScrollView.bounds.size.width, backgroundScrollView.bounds.size.height);
    [hideKeyPadsButton addTarget:self action:@selector(hideKeyPads) forControlEvents:UIControlEventTouchUpInside];
    [backgroundScrollView addSubview:hideKeyPadsButton];
    [backgroundScrollView sendSubviewToBack:hideKeyPadsButton];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:floodSubmissionLat longitude:floodSubmissionLon];
    [self getAddressFromLatLon:location];

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
