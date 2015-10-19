//
//  ABCWaterDetailViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ABCWaterDetailViewController.h"
#import "ARViewController.h"

@interface UIDevice (MyPrivateNameThatAppleWouldNeverUseGoesHere)
- (void) setOrientation:(UIInterfaceOrientation)orientation;
@end

@implementation ABCWaterDetailViewController
@synthesize abcSiteId,imageUrl,titleString,descriptionString,latValue,longValue,phoneNoString,addressString,imageName,isCertified;


//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwaters_detail_options.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
}


//*************** Method To Close Top Menu For Outside Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    
    UITouch *touch = [touches anyObject];
    
    if(touch.view!=topMenu) {
        if (isShowingTopMenu) {
            [self animateTopMenu];
        }
    }
}


- (void) hideTopMenu {
    
    if (isShowingTopMenu) {
        [self animateTopMenu];
    }
}


//*************** Method To Move To Map Direction View

- (void) moveToDirectionView {
    
    if (isShowingTopMenu) {
        
        [self animateTopMenu];
    }
    
    DirectionViewController *viewObj = [[DirectionViewController alloc] init];
    viewObj.destinationLat = latValue;
    viewObj.destinationLong = longValue;
    [self.navigationController pushViewController:viewObj animated:YES];
}


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



//*************** Method To Call PUB For ABC Water Site

- (void) callPUB {
    
    if (isShowingTopMenu) {
        [self animateTopMenu];
    }
    
    DebugLog(@"%ld",[phoneNoString length]);
    if ([phoneNoString length] != 0) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNoString]]];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Sorry" msg:@"No contact available for this site." cancel:@"Ok" otherButton:nil];
    }
}



//*************** Method To Add Photo To Site

- (void) moveToGalleryView {
    
    if (isShowingTopMenu) {
        [self animateTopMenu];
    }
    
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    appDelegate.hud.labelText = @"Loading...";
    
    isFetchingGalleryImages = YES;
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ABCWaterSitesID", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:abcSiteId, nil];
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,ABC_WATERS_POI]];
}


//*************** Method To Add Photo To Site

- (void) addPhotoToSite {
    
    [self animateTopMenu];
    
    [CommonFunctions showActionSheet:self containerView:self.view.window title:@"Select Source" msg:nil cancel:nil tag:1 destructive:nil otherButton:@"Take Photo",@"Photo Library",@"Cancel",nil];
}


//*************** Method To Share Site

- (void) shareSiteOnSocialNetwork {
    
    [self animateTopMenu];
    
    [CommonFunctions showActionSheet:self containerView:self.view.window title:@"Share on" msg:nil cancel:nil tag:2 destructive:nil otherButton:@"Facebook",@"Twitter",@"Cancel",nil];
}



//*************** Method To Animate Top Menu

- (void) animateTopMenu {
    
    if (isShowingTopMenu) {
        
        isShowingTopMenu = NO;
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint topMenuPos = topMenu.center;
        topMenuPos.y = -30;
        topMenu.center = topMenuPos;
        [UIView commitAnimations];
    }
    else {
        
        isShowingTopMenu = YES;
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint topMenuPos = topMenu.center;
        topMenuPos.y = 22;
        topMenu.center = topMenuPos;
        [UIView commitAnimations];
    }
}


//*************** Method To Create Detail Page UI

- (void) createUI {
    
    float h2 = 0;
    
    if ([dataDict objectForKey:@"image_size"] !=(id)[NSNull null]) {
        NSArray *tempArray = [[dataDict objectForKey:@"image_size"] componentsSeparatedByString: @","];
        
        float w1 = [[tempArray objectAtIndex:0] floatValue];
        float h1 = [[tempArray objectAtIndex:1] floatValue];
        h2 = (h1*self.view.bounds.size.width)/w1;
    }
    
    
    
    eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgScrollView.bounds.size.width, 249)];
    [bgScrollView addSubview:eventImageView];
    
    NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
    NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ABCWaters"]];
    
    NSString *localFile = [destinationPath stringByAppendingPathComponent:imageName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
        if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]] != nil)
            eventImageView.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]];
    }
    else {
        
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,imageName];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(eventImageView.bounds.size.width/2, eventImageView.bounds.size.height/2);
        [eventImageView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                
                eventImageView.image = image;
                
                NSFileManager *fileManger=[NSFileManager defaultManager];
                NSError* error;
                
                if (![fileManger fileExistsAtPath:destinationPath]){
                    
                    if([[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:&error])
                        ;// success
                    else
                    {
                        DebugLog(@"[%@] ERROR: attempting to write create MyTasks directory", [self class]);
                        NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
                    }
                }
                
                NSData *data = UIImageJPEGRepresentation(image, 0.8);
                [data writeToFile:[destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]] atomically:YES];
            }
            else {
                DebugLog(@"Image Loading Failed..!!");
                eventImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
            }
            [activityIndicator stopAnimating];
        }];
    }
    
    
    
    UIImageView *certifiedLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 59, 25)];
    [certifiedLogo setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwater_certified_logo.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [eventImageView addSubview:certifiedLogo];
    if (!isCertified) {
        certifiedLogo.hidden = YES;
    }
    
    UIButton *temperatureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    temperatureButton.frame = CGRectMake(eventImageView.bounds.size.width-50, eventImageView.bounds.size.height-40, 30, 30);
    [temperatureButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_weather_abcwater.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [eventImageView addSubview:temperatureButton];
    
    directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    directionButton.frame = CGRectMake(0, eventImageView.frame.origin.y+eventImageView.bounds.size.height, bgScrollView.bounds.size.width, 40);
    [directionButton setBackgroundColor:[UIColor whiteColor]];
    [directionButton addTarget:self action:@selector(moveToDirectionView) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:directionButton];
    
    directionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
    [directionIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_directions_blue.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [directionButton addSubview:directionIcon];
    
    
    abcWaterTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, directionButton.bounds.size.width-140, 40)];
    abcWaterTitle.backgroundColor = [UIColor whiteColor];
    abcWaterTitle.textAlignment = NSTextAlignmentLeft;
    abcWaterTitle.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    abcWaterTitle.text = titleString;
    abcWaterTitle.numberOfLines = 0;
    [directionButton addSubview:abcWaterTitle];
    
    
    //----- Change Current Location With Either Current Location Value or Default Location Value
    
    
    CLLocationCoordinate2D currentLocation;
    CLLocationCoordinate2D desinationLocation;
    
    currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
    currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
    
    desinationLocation.latitude = latValue;
    desinationLocation.longitude = longValue;
    
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(directionButton.bounds.size.width-130, 0, 100, 40)];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    distanceLabel.text = [NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
    [directionButton addSubview:distanceLabel];
    
    arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(directionButton.bounds.size.width-20, 12.5, 15, 15)];
    [arrowIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_arrow_grey.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [directionButton addSubview:arrowIcon];
    
    
    
    eventInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, directionButton.frame.origin.y+directionButton.bounds.size.height+5, self.view.bounds.size.width, 40)];
    eventInfoLabel.backgroundColor = [UIColor whiteColor];
    eventInfoLabel.textAlignment = NSTextAlignmentLeft;
    eventInfoLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    eventInfoLabel.text = @"            ABC Waters Info";
    [bgScrollView addSubview:eventInfoLabel];
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, eventInfoLabel.bounds.size.width, 0.5)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [eventInfoLabel addSubview:seperatorImage];
    
    
    infoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 19, 19)];
    [infoIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_info_blue.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [eventInfoLabel addSubview:infoIcon];
    
    
    
    descriptionLabel = [[UILabel___Extension alloc] initWithFrame:CGRectMake(0, eventInfoLabel.frame.origin.y+eventInfoLabel.bounds.size.height, bgScrollView.bounds.size.width, 40)];
    descriptionLabel.backgroundColor = [UIColor whiteColor];
    descriptionLabel.text = [NSString stringWithFormat:@"%@",descriptionString];
    descriptionLabel.textColor = [UIColor darkGrayColor];
    descriptionLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect newDescriptionLabelFrame = descriptionLabel.frame;
    newDescriptionLabelFrame.size.height = [CommonFunctions heightForText:descriptionString font:descriptionLabel.font withinWidth:bgScrollView.bounds.size.width-40];//expectedDescriptionLabelSize.height;
    descriptionLabel.frame = newDescriptionLabelFrame;
    [bgScrollView addSubview:descriptionLabel];
    
    bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, eventImageView.bounds.size.height+directionButton.bounds.size.height+eventInfoLabel.bounds.size.height+descriptionLabel.bounds.size.height+50);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTopMenu)];
    // prevents the scroll view from swallowing up the touch event of child buttons
    tapGesture.cancelsTouchesInView = NO;
    [bgScrollView addGestureRecognizer:tapGesture];
}


//*************** Method To Move To AR View

- (void) moveToARView {
    
    if (isShowingTopMenu) {
        [self animateTopMenu];
    }
    
    ARViewController *viewObj = [[ARViewController alloc] init];
    viewObj.abcWaterSiteID = abcSiteId;
    [self.navigationController pushViewController:viewObj animated:NO];
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    [appDelegate.hud hide:YES];
    
    DebugLog(@"%@",responseString);
    
    if (isFetchingGalleryImages) {
        
        isFetchingGalleryImages = NO;
        
        if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
            
            [abcGalleryImages removeAllObjects];
            NSArray *tempArray = [[responseString JSONValue] objectForKey:ABC_GALLERY_RESPONSE_NAME];
            
            if (tempArray.count!=0) {
                
                for (int i=0; i<tempArray.count; i++) {
                    NSString *galleryImageName = [[tempArray objectAtIndex:i] objectForKey:@"Image"];
                    [abcGalleryImages addObject:galleryImageName];
                }
                
                GalleryViewController *viewObj = [[GalleryViewController alloc] init];
                viewObj.isABCGallery = YES;
                viewObj.isUserGallery = NO;
                viewObj.galleryImages = abcGalleryImages;
                [self.navigationController pushViewController:viewObj animated:YES];
                
            }
            else {
                [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"Ok" otherButton:nil];
            }
        }
        else {
            [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
        }
    }
    else {
        if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
            
            [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
        }
        else {
            [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
        }
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"Ok" otherButton:nil];
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Device does not have camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Photo library does not exists." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
    else if (actionSheet.tag==2) {
        if (buttonIndex==0) {
            NSString *appUrl;
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"iOSShareURL"]) {
                    appUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            [CommonFunctions sharePostOnFacebook:imageUrl appUrl:appUrl title:titleString desc:descriptionString view:self];
        }
        else if (buttonIndex==1) {
            
            NSString *appUrl;
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"iOSShareURL"]) {
                    appUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            [CommonFunctions sharePostOnTwitter:appUrl title:titleString view:self];
        }
    }
}


#pragma mark - FBSDKSharingDelegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults :(NSDictionary *)results {
    NSLog(@"FB: SHARE RESULTS=%@\n",[results debugDescription]);
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSLog(@"FB: ERROR=%@\n",[error debugDescription]);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSLog(@"FB: CANCELED SHARER=%@\n",[sharer debugDescription]);
}



# pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    NSData* data = UIImageJPEGRepresentation(chosenImage, 0.5f);
    NSString *base64ImageString = [Base64 encode:data];
    
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    appDelegate.hud.labelText = @"Loading...";
    
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    [parameters addObject:@"ABCPOIImage.Image"];
    [values addObject:base64ImageString];
    
    [parameters addObject:@"ABCPOIImage.ABCID"];
    [values addObject:abcSiteId];
    
    [parameters addObject:@"ABCPOIImage.UserProfileID"];
    [values addObject:[[appDelegate.USER_PROFILE_DICTIONARY objectForKey:@"UserProfile"] objectForKey:@"ID"]];
    
    [parameters addObject:@"ABCPOIImage.UserProfileName"];
    [values addObject:[[appDelegate.USER_PROFILE_DICTIONARY objectForKey:@"UserProfile"] objectForKey:@"Name"]];
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,ABC_WATERS_UPLOAD_USER_IMAGE]];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    self.view.backgroundColor = RGB(242, 242, 242);
    self.title = @"ABC Waters Info";
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateTopMenu) withIconName:@"icn_3dots"]];
    
    //[self createDemoAppControls];
    
    abcGalleryImages = [[NSMutableArray alloc] init];
    
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-124)];
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    bgScrollView.backgroundColor = [UIColor whiteColor];
    
    
    [self createUI];
    
    
    
    //***** Bottom Control Parameters
    
    arViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    arViewButton.frame = CGRectMake((self.view.bounds.size.width/3-30)/2, bgScrollView.frame.origin.y+bgScrollView.bounds.size.height+10, 30, 30);
    [arViewButton addTarget:self action:@selector(moveToARView) forControlEvents:UIControlEventTouchUpInside];
    [arViewButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_ARview.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [self.view addSubview:arViewButton];
    
    arViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, arViewButton.frame.origin.y+arViewButton.bounds.size.height+3, self.view.bounds.size.width/3, 15)];
    arViewLabel.backgroundColor = [UIColor clearColor];
    arViewLabel.textAlignment = NSTextAlignmentCenter;
    arViewLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
    arViewLabel.text = @"AR View";
    [self.view addSubview:arViewLabel];
    
    
    bookingFormButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bookingFormButton.frame = CGRectMake(((self.view.bounds.size.width/3)+(self.view.bounds.size.width/3-30)/2), bgScrollView.frame.origin.y+bgScrollView.bounds.size.height+10, 30, 30);
    [bookingFormButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_bookingform.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [self.view addSubview:bookingFormButton];
    
    bookingFormLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/3), bookingFormButton.frame.origin.y+bookingFormButton.bounds.size.height+3, self.view.bounds.size.width/3, 15)];
    bookingFormLabel.backgroundColor = [UIColor clearColor];
    bookingFormLabel.textAlignment = NSTextAlignmentCenter;
    bookingFormLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
    bookingFormLabel.text = @"Booking Form";
    [self.view addSubview:bookingFormLabel];
    
    contactUsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contactUsButton.frame = CGRectMake(((self.view.bounds.size.width/3)*2+(self.view.bounds.size.width/3-30)/2), bgScrollView.frame.origin.y+bgScrollView.bounds.size.height+12, 25, 25);
    [contactUsButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_call_blue.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [contactUsButton addTarget:self action:@selector(callPUB) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:contactUsButton];
    
    contactUsLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/3)*2, contactUsButton.frame.origin.y+contactUsButton.bounds.size.height+6, self.view.bounds.size.width/3, 15)];
    contactUsLabel.backgroundColor = [UIColor clearColor];
    contactUsLabel.textAlignment = NSTextAlignmentCenter;
    contactUsLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
    contactUsLabel.text = @"Contact Us";
    [self.view addSubview:contactUsLabel];
    
    
    //Top Menu Item
    
    topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, -60, self.view.bounds.size.width, 45)];
    topMenu.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:topMenu];
    
    addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoButton.frame = CGRectMake((topMenu.bounds.size.width/3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 5, 20, 20);
    [addPhotoButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_camera.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [addPhotoButton addTarget:self action:@selector(addPhotoToSite) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:addPhotoButton];
    
    galleryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    galleryButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*2)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 5, 20, 20);
    [galleryButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_gallery.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [galleryButton addTarget:self action:@selector(moveToGalleryView) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:galleryButton];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 5, 25, 20);
    [shareButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_share.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareSiteOnSocialNetwork) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:shareButton];
    
    addPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, topMenu.bounds.size.width/3, 10)];
    addPhotoLabel.backgroundColor = [UIColor clearColor];
    addPhotoLabel.textAlignment = NSTextAlignmentCenter;
    addPhotoLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    addPhotoLabel.text = @"Add Photo";
    addPhotoLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:addPhotoLabel];
    
    UIImageView *seperatorOne =[[UIImageView alloc] initWithFrame:CGRectMake(addPhotoLabel.frame.origin.x+addPhotoLabel.bounds.size.width-1, 0, 0.5, 45)];
    [seperatorOne setBackgroundColor:[UIColor lightGrayColor]];
    [topMenu addSubview:seperatorOne];
    
    
    galleryLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3), 32, topMenu.bounds.size.width/3, 10)];
    galleryLabel.backgroundColor = [UIColor clearColor];
    galleryLabel.textAlignment = NSTextAlignmentCenter;
    galleryLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    galleryLabel.text = @"Gallery";
    galleryLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:galleryLabel];
    
    UIImageView *seperatorTwo =[[UIImageView alloc] initWithFrame:CGRectMake(galleryLabel.frame.origin.x+galleryLabel.bounds.size.width-1, 0, 0.5, 45)];
    [seperatorTwo setBackgroundColor:[UIColor lightGrayColor]];
    [topMenu addSubview:seperatorTwo];
    
    
    shareLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3)*2, 32, topMenu.bounds.size.width/3, 10)];
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    shareLabel.text = @"Share";
    shareLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:shareLabel];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    appDelegate.IS_ARVIEW_CUSTOM_LABEL = NO;
    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
    self.navigationController.navigationBar.hidden = NO;
    
    // Enable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (void) viewDidAppear:(BOOL)animated {
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
    swipeGesture.numberOfTouchesRequired = 1;
    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
    
    [self.view addGestureRecognizer:swipeGesture];
    
    //    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    
}


-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    
    //    UIInterfaceOrientationMaskLandscape;
    //    24
    //
    //    UIInterfaceOrientationMaskLandscapeLeft;
    //    16
    //
    //    UIInterfaceOrientationMaskLandscapeRight;
    //    8
    //
    //    UIInterfaceOrientationMaskPortrait;
    //    2
    
    //    return UIInterfaceOrientationMaskPortrait;
    //    or
    return 2;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}


@end
