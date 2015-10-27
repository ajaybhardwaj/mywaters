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



//*************** Method To Handle Tap Gesture For Profile Pic

- (void) handleSingleTapGesture: (UITapGestureRecognizer*) sender {
    
    if (sender==profileImageTap) {
        [CommonFunctions showActionSheet:self containerView:self.view title:@"Profile Picture" msg:nil cancel:nil tag:1 destructive:nil otherButton:@"Camera",@"Photo Library",@"Cancel",nil];
    }
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
            appDelegate.hud.labelText = @"Loading...";
            
            NSMutableArray *parameters = [[NSMutableArray alloc] init];
            NSMutableArray *values = [[NSMutableArray alloc] init];
            
            [parameters addObject:@"Name"];
            [values addObject:nameField.text];
            
            [parameters addObject:@"Email"];
            [values addObject:emailField.text];
            
            if (isProfilePictureSelected) {
                
                NSData* data = UIImageJPEGRepresentation(profileImageView.image, 0.5f);
                NSString *base64ImageString = [Base64 encode:data];
                
                [parameters addObject:@"ImageBase64"];
                [values addObject:base64ImageString];
                
            }
            
            [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,PROFILE_API_URL]];
        }
    }
    else if (button.tag==2) {
        
        ChangePasswordViewController *viewObj = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}


# pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    isProfilePictureSelected = YES;
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    profileImageView.image=image;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    isProfilePictureSelected = NO;
    [picker dismissViewControllerAnimated:YES completion:NULL];
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


# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField==nameField) {
        [emailField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint pos = self.view.center;
        if (IS_IPHONE_4_OR_LESS)
            pos.y = 269;
        else
            pos.y = 315;
        self.view.center = pos;
        [UIView commitAnimations];
    }
    
    
    
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [UIView beginAnimations:@"topMenu" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = self.view.center;
    pos.y = 200;
    self.view.center = pos;
    [UIView commitAnimations];
    
    return YES;
}



# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    [appDelegate.hud hide:YES];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [[SharedObject sharedClass] savePUBUserData:[responseString JSONValue]];
        
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
    
    
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)-50, 15, 100, 100)];
    profileImageView.layer.cornerRadius = profileImageView.bounds.size.width/2;
    profileImageView.layer.masksToBounds = YES;
    [self.view addSubview:profileImageView];
    profileImageView.userInteractionEnabled = YES;
    
    profileImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    profileImageTap.numberOfTapsRequired = 1;
    profileImageTap.numberOfTouchesRequired = 1;
    [profileImageView addGestureRecognizer: profileImageTap];
    
    
    uploadAvatarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, profileImageView.frame.origin.y+profileImageView.bounds.size.height+2, self.view.bounds.size.width, 20)];
    uploadAvatarLabel.backgroundColor = [UIColor clearColor];
    uploadAvatarLabel.textAlignment = NSTextAlignmentCenter;
    uploadAvatarLabel.textColor = RGB(61, 71, 94);
    uploadAvatarLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    [self.view addSubview:uploadAvatarLabel];
    
    if ([[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userProfileImageName"] length] !=0) {
    
        uploadAvatarLabel.text = @"Tap To Change Avatar";
        
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userProfileImageName"]];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(profileImageView.bounds.size.width/2, profileImageView.bounds.size.height/2);
        [profileImageView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                profileImageView.image = image;
            }
            else {
                [profileImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/image_avatar.png",appDelegate.RESOURCE_FOLDER_PATH]]];
            }
            [activityIndicator stopAnimating];
        }];
    }
    else {
        [profileImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/image_avatar.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        uploadAvatarLabel.text = @"Tap To Upload Avatar";
    }
    
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, profileImageView.frame.origin.y+profileImageView.bounds.size.height+30, self.view.bounds.size.width-20, 40)];
    nameField.textColor = RGB(61, 71, 94);
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
    [nameField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    nameField.returnKeyType = UIReturnKeyNext;
    [nameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    nameField.tag = 1;
    nameField.text = [[SharedObject sharedClass] getPUBUserSavedDataValue:@"userName"];
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(10, nameField.frame.origin.y+nameField.bounds.size.height+10, self.view.bounds.size.width-20, 40)];
    emailField.textColor = RGB(61, 71, 94);
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
    [emailField setBackground:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/textfield_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    emailField.returnKeyType = UIReturnKeyDefault;
    [emailField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    emailField.tag = 2;
    emailField.text = [[SharedObject sharedClass] getPUBUserSavedDataValue:@"userEmail"];
    
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
