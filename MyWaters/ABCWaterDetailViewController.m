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
@synthesize isAlreadyFav,isHavingPOI;

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



//*************** Method To Get 12 Hour Weather XML Data

- (void) getTwelveHourWeatherData {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:TWELVE_HOUR_FORECAST] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *responseString  = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSDictionary *xmlDictionary = [NSDictionary dictionaryWithXMLString:responseString];
    
    twelveHourWeatherData = [[xmlDictionary objectForKey:@"channel"] objectForKey:@"item"];
    
    
    NSString *iconImageName;
    
    if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"FD"]) {
        iconImageName = @"FD.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"FN"]) {
        iconImageName = @"FN.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"PC"]) {
        iconImageName = @"PC.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"CD"]) {
        iconImageName = @"CD.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"HZ"]) {
        iconImageName = @"HZ.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"WD"]) {
        iconImageName = @"WD.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"RA"]) {
        iconImageName = @"RA.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"PS"]) {
        iconImageName = @"PS.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"SH"]) {
        iconImageName = @"SH.png";
    }
    else if ([[twelveHourWeatherData objectForKey:@"wxmain"] isEqualToString:@"TS"]) {
        iconImageName = @"TS.png";
    }
    [temperatureIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",appDelegate.RESOURCE_FOLDER_PATH,iconImageName]]];
    
    
    temperatureLabel.text = [NSString stringWithFormat:@"%@°",[[twelveHourWeatherData objectForKey:@"temperature"] objectForKey:@"_high"]];
    
}


- (void) hideTopMenu {
    
    if (isShowingTopMenu) {
        [self animateTopMenu];
    }
}



//*************** Method To Add CCTV To Favourites

- (void) addABCWaterToFavourites {
    
    [self animateTopMenu];
    
    NSMutableDictionary *parametersDict = [[NSMutableDictionary alloc] init];
    
    [parametersDict setValue:abcSiteId forKey:@"fav_id"];
    [parametersDict setValue:@"3" forKey:@"fav_type"];
    [parametersDict setValue:titleString forKey:@"name"];
    [parametersDict setValue:imageName forKey:@"image"];
    [parametersDict setValue:[NSString stringWithFormat:@"%f",latValue] forKey:@"lat"];
    [parametersDict setValue:[NSString stringWithFormat:@"%f",longValue] forKey:@"long"];
    
    if (addressString != (id)[NSNull null] && [addressString length] !=0)
        [parametersDict setValue:addressString forKey:@"address"];
    else
        [parametersDict setValue:@"NA" forKey:@"address"];
    
    if (phoneNoString != (id)[NSNull null] && [phoneNoString length] !=0)
        [parametersDict setValue:phoneNoString forKey:@"phoneno"];
    else
        [parametersDict setValue:@"NA" forKey:@"phoneno"];
    
    if (descriptionString != (id)[NSNull null] && [descriptionString length] !=0)
        [parametersDict setValue:descriptionString forKey:@"description"];
    else
        [parametersDict setValue:@"NA" forKey:@"description"];
    
    
    [parametersDict setValue:@"NA" forKey:@"website_event"];
    [parametersDict setValue:@"NA" forKey:@"end_date_event"];
    [parametersDict setValue:@"NA" forKey:@"start_date_event"];
    if (isHavingPOI) {
        [parametersDict setValue:@"1" forKey:@"isCertified_ABC"];;
    }
    else {
        [parametersDict setValue:@"0" forKey:@"isCertified_ABC"];;
    }
    [parametersDict setValue:@"NA" forKey:@"water_level_wls"];
    [parametersDict setValue:@"NA" forKey:@"drain_depth_wls"];
    [parametersDict setValue:@"NA" forKey:@"water_level_percentage_wls"];
    [parametersDict setValue:@"NA" forKey:@"water_level_type_wls"];
    [parametersDict setValue:@"NA" forKey:@"observation_time_wls"];
    [parametersDict setValue:@"0" forKey:@"isWlsSubscribed"];
    if (isHavingPOI) {
        [parametersDict setValue:@"1" forKey:@"hasPOI"];
    }
    else {
        [parametersDict setValue:@"0" forKey:@"hasPOI"];
    }
    
    [appDelegate insertFavouriteItems:parametersDict];
    
    isAlreadyFav = [appDelegate checkItemForFavourite:@"3" idValue:abcSiteId];
    
    if (isAlreadyFav) {
        [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_fav.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        favouriteLabel.text = @"Favourite";
    }
    else {
        [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        favouriteLabel.text = @"Favourite";
    }
}




//*************** Method To Move To Map Direction View

- (void) moveToDirectionView {
    
    if (isShowingTopMenu) {
        
        [self animateTopMenu];
    }
    
    QuickMapViewController *viewObj = [[QuickMapViewController alloc] init];
    viewObj.isShowingRoute = YES;
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
    
    phoneNoString = [phoneNoString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([phoneNoString length] != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNoString]]];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Sorry" msg:@"No contact available for this site." cancel:@"OK" otherButton:nil];
    }
}



//*************** Method To Add Photo To Site

- (void) moveToGalleryView {
    
    if (isShowingTopMenu) {
        [self animateTopMenu];
    }
    
    [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
    
    isFetchingGalleryImages = YES;
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ABCWaterSitesID", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:abcSiteId, nil];
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,ABC_WATERS_POI]];
    
}


//*************** Method To Add Photo To Site

- (void) addPhotoToSite {
    
    [self animateTopMenu];
    
    if (!appDelegate.IS_SKIPPING_USER_LOGIN) {
        [CommonFunctions showActionSheet:self containerView:self.view.window title:@"Select Source" msg:nil cancel:nil tag:1 destructive:nil otherButton:@"Take Photo",@"Photo Library",@"Cancel",nil];
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:@"To upload photo, Please login." cancel:nil otherButton:@"OK",nil];
    }
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
    
    
    
    eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 249)];
    [bgScrollView addSubview:eventImageView];
    
    
    temperatureBgView = [[UIImageView alloc] initWithFrame:CGRectMake(eventImageView.bounds.size.width-60, eventImageView.bounds.size.height-60, 50, 50)];
    temperatureBgView.backgroundColor = [UIColor whiteColor];
    temperatureBgView.alpha = 0.7;
    temperatureBgView.layer.cornerRadius = 25.0;
    [eventImageView addSubview:temperatureBgView];
    
    temperatureIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12.5, 5, 25, 25)];
    [temperatureBgView addSubview:temperatureIcon];
    
    temperatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 50, 20)];
    temperatureLabel.textAlignment = NSTextAlignmentCenter;
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor blackColor];
    temperatureLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [temperatureBgView addSubview:temperatureLabel];
    
    
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
    
//    UIButton *temperatureButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    temperatureButton.frame = CGRectMake(eventImageView.bounds.size.width-50, eventImageView.bounds.size.height-40, 30, 30);
//    [temperatureButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_weather_abcwater.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
//    [eventImageView addSubview:temperatureButton];
    
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
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        distanceLabel.text = @"";
        arrowIcon.hidden = YES;
        directionButton.enabled = NO;
    }
    
    
    eventInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, directionButton.frame.origin.y+directionButton.bounds.size.height+5, self.view.bounds.size.width, 40)];
    eventInfoLabel.backgroundColor = [UIColor whiteColor];
    eventInfoLabel.textAlignment = NSTextAlignmentLeft;
    eventInfoLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    eventInfoLabel.text = @"            Our Waters Info";
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
    descriptionLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
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
    
    [self getTwelveHourWeatherData];
}


//*************** Method To Move To AR View

- (void) moveToARView {
    
    
    if (isShowingTopMenu) {
        [self animateTopMenu];
    }
    //    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    //    if (currentOrientation == UIInterfaceOrientationPortrait || currentOrientation == UIInterfaceOrientationPortraitUpsideDown)
    //        [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
    
    ARViewController *viewObj = [[ARViewController alloc] init];
    viewObj.abcWaterSiteID = abcSiteId;
    [self.navigationController pushViewController:viewObj animated:NO];
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    [CommonFunctions dismissGlobalHUD];
//    [appDelegate.hud hide:YES];
    
    DebugLog(@"%@",responseString);
    
    if (isFetchingGalleryImages) {
        
        isFetchingGalleryImages = NO;
        
        if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
            
            [abcGalleryImages removeAllObjects];
            NSArray *tempArray = [[responseString JSONValue] objectForKey:ABC_GALLERY_RESPONSE_NAME];
            
            if (tempArray.count!=0) {
                
                for (int i=0; i<tempArray.count; i++) {
                    NSString *galleryImageName = [[tempArray objectAtIndex:i] objectForKey:@"Image"];
                    [abcGalleryImages addObject:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,galleryImageName]];
                }
                
                
                networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
                networkGallery.isComingFromARView = NO;
                networkGallery.abcSiteID = abcSiteId;
                [self.navigationController pushViewController:networkGallery animated:YES];
                //                GalleryViewController *viewObj = [[GalleryViewController alloc] init];
                //                viewObj.isABCGallery = YES;
                //                viewObj.isUserGallery = NO;
                //                viewObj.isPOIGallery = NO;
                //                viewObj.galleryImages = abcGalleryImages;
                //                [self.navigationController pushViewController:viewObj animated:YES];
                
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
            DebugLog(@"%@-----%@---%@",appUrl,titleString,descriptionString);
            [CommonFunctions sharePostOnFacebook:imageUrl appUrl:appUrl title:titleString desc:descriptionString view:self abcIDValue:abcSiteId];
        }
        else if (buttonIndex==1) {
            
            NSString *appUrl;
            for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
                if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"iOSShareURL"]) {
                    appUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
                    break;
                }
            }
            [CommonFunctions sharePostOnTwitter:appUrl title:titleString view:self abcIDValue:abcSiteId];
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

    [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
//        appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
//        appDelegate.hud.labelText = @"Loading...";
    
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    [parameters addObject:@"ABCPOIImage.Image"];
    [values addObject:base64ImageString];
    
    [parameters addObject:@"ABCPOIImage.ABCID"];
    [values addObject:abcSiteId];
    
    [parameters addObject:@"ABCPOIImage.UserProfileID"];
    [values addObject:[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userID"]];
    
    [parameters addObject:@"ABCPOIImage.UserProfileName"];
    [values addObject:[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userName"]];
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,ABC_WATERS_UPLOAD_USER_IMAGE]];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    //    if( gallery == localGallery ) {
    //        num = [localImages count];
    //    }
    //    else if( gallery == networkGallery ) {
    if( gallery == networkGallery ) {
        num = (int)[abcGalleryImages count];
    }
    return num;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    //    if( gallery == localGallery ) {
    //        return FGalleryPhotoSourceTypeLocal;
    //    }
    //    else
    return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    //    NSString *caption;
    //    if( gallery == localGallery ) {
    //        caption = [localCaptions objectAtIndex:index];
    //    }
    //    else if( gallery == networkGallery ) {
    //        caption = [networkCaptions objectAtIndex:index];
    //    }
    //    return caption;
    return nil;
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    //    return [localImages objectAtIndex:index];
    return nil;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [abcGalleryImages objectAtIndex:index];
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}


- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}





# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    isAlreadyFav = [appDelegate checkItemForFavourite:@"3" idValue:abcSiteId];
    
    [appDelegate.locationManager startUpdatingLocation];
    
    self.view.backgroundColor = RGB(242, 242, 242);
    self.title = @"Our Waters Info";
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateTopMenu) withIconName:@"icn_3dots"]];
    
    //[self createDemoAppControls];
    
    abcGalleryImages = [[NSMutableArray alloc] init];
    
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-124)];
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    bgScrollView.backgroundColor = [UIColor whiteColor];
    bgScrollView.userInteractionEnabled = YES;
    
    [self createUI];
    
    
    
    //***** Bottom Control Parameters
    
    arViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    arViewButton.frame = CGRectMake((self.view.bounds.size.width/3-30)/2, bgScrollView.frame.origin.y+bgScrollView.bounds.size.height+10, 30, 30);
    arViewButton.frame = CGRectMake((self.view.bounds.size.width/2)-(self.view.bounds.size.width/2)/2-15, bgScrollView.frame.origin.y+bgScrollView.bounds.size.height+10, 30, 30);
    [arViewButton addTarget:self action:@selector(moveToARView) forControlEvents:UIControlEventTouchUpInside];
    [arViewButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_ARview.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [self.view addSubview:arViewButton];
    
    arViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, arViewButton.frame.origin.y+arViewButton.bounds.size.height+3, self.view.bounds.size.width/2, 15)];
    arViewLabel.backgroundColor = [UIColor clearColor];
    arViewLabel.textAlignment = NSTextAlignmentCenter;
    arViewLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
    arViewLabel.text = @"AR View";
    [self.view addSubview:arViewLabel];
    
    if (!isHavingPOI) {
        arViewButton.alpha = 0.4;
        arViewLabel.alpha = 0.4;
        arViewButton.enabled = NO;
    }
    
    
    bookingFormButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bookingFormButton.frame = CGRectMake(self.view.bounds.size.width-(self.view.bounds.size.width/2)/2 -15, bgScrollView.frame.origin.y+bgScrollView.bounds.size.height+10, 30, 30);
    [bookingFormButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_abc_gallery.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [bookingFormButton addTarget:self action:@selector(moveToGalleryView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bookingFormButton];
    
    bookingFormLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, bookingFormButton.frame.origin.y+bookingFormButton.bounds.size.height+3, self.view.bounds.size.width/2, 15)];
    bookingFormLabel.backgroundColor = [UIColor clearColor];
    bookingFormLabel.textAlignment = NSTextAlignmentCenter;
    bookingFormLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
    bookingFormLabel.text = @"Gallery";
    [self.view addSubview:bookingFormLabel];
    
    // Old Code Supporting Three Menu Items
    /*
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
    
    if ([phoneNoString length]==0) {
        contactUsButton.alpha = 0.4;
        contactUsLabel.alpha = 0.4;
        contactUsButton.enabled = NO;
    }
    */
    
    //Top Menu Item
    
    topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, -60, self.view.bounds.size.width, 45)];
    topMenu.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:topMenu];
    
    
    // Old Code Supporting Three Menu Items
    /*
    addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoButton.frame = CGRectMake((topMenu.bounds.size.width/3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 5, 20, 20);
    //    addPhotoButton.frame = CGRectMake(topMenu.bounds.size.width/4-10, 5, 20, 20);
    [addPhotoButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_camera.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [addPhotoButton addTarget:self action:@selector(addPhotoToSite) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:addPhotoButton];
    
    favouritesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favouritesButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*2)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 5, 20, 20);
    if (isAlreadyFav)
        [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_fav.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    else
        [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [favouritesButton addTarget:self action:@selector(addABCWaterToFavourites) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:favouritesButton];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    shareButton.frame = CGRectMake((topMenu.bounds.size.width/2)+(topMenu.bounds.size.width/4)-10, 5, 20, 20);
    shareButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 5, 20, 20);
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
    
    favouriteLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3), 32, topMenu.bounds.size.width/3, 10)];
    favouriteLabel.backgroundColor = [UIColor clearColor];
    favouriteLabel.textAlignment = NSTextAlignmentCenter;
    favouriteLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    if (isAlreadyFav)
        favouriteLabel.text = @"Favourite";
    else
        favouriteLabel.text = @"Favourite";
    favouriteLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:favouriteLabel];
    
    shareLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3)*2, 32, topMenu.bounds.size.width/3, 10)];
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    shareLabel.text = @"Share";
    shareLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:shareLabel];
    
    UIButton *addPhotoOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoOverlayButton.frame = CGRectMake(0, 0, topMenu.bounds.size.width/3, 45);
    [addPhotoOverlayButton addTarget:self action:@selector(addPhotoToSite) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:addPhotoOverlayButton];
    
    UIButton *addFavOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addFavOverlayButton.frame = CGRectMake(topMenu.bounds.size.width/3, 0, topMenu.bounds.size.width/3, 45);
    [addFavOverlayButton addTarget:self action:@selector(addABCWaterToFavourites) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:addFavOverlayButton];
    
    UIButton *addShareOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addShareOverlayButton.frame = CGRectMake((topMenu.bounds.size.width/3)*2, 0, topMenu.bounds.size.width/3, 45);
    [addShareOverlayButton addTarget:self action:@selector(shareSiteOnSocialNetwork) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:addShareOverlayButton];
    */
    
    
    addPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoButton.frame = CGRectMake((topMenu.bounds.size.width/2)-(topMenu.bounds.size.width/2)/2 -10, 5, 20, 20);
    [addPhotoButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_call_abcwaters.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [addPhotoButton addTarget:self action:@selector(callPUB) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:addPhotoButton];
    
    favouritesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favouritesButton.frame = CGRectMake(topMenu.bounds.size.width-(topMenu.bounds.size.width/2)/2 -10, 5, 20, 20);
    if (isAlreadyFav)
        [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_fav.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    else
        [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [favouritesButton addTarget:self action:@selector(addABCWaterToFavourites) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:favouritesButton];

    
    addPhotoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, topMenu.bounds.size.width/2, 10)];
    addPhotoLabel.backgroundColor = [UIColor clearColor];
    addPhotoLabel.textAlignment = NSTextAlignmentCenter;
    addPhotoLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    addPhotoLabel.text = @"Contact Us";
    addPhotoLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:addPhotoLabel];
    
    
    favouriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(topMenu.bounds.size.width/2, 32, topMenu.bounds.size.width/2, 10)];
    favouriteLabel.backgroundColor = [UIColor clearColor];
    favouriteLabel.textAlignment = NSTextAlignmentCenter;
    favouriteLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    if (isAlreadyFav)
        favouriteLabel.text = @"Favourite";
    else
        favouriteLabel.text = @"Favourite";
    favouriteLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:favouriteLabel];

    
    UIButton *addPhotoOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addPhotoOverlayButton.frame = CGRectMake(0, 0, topMenu.bounds.size.width/2, 45);
    [addPhotoOverlayButton addTarget:self action:@selector(callPUB) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:addPhotoOverlayButton];
    
    UIButton *addFavOverlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addFavOverlayButton.frame = CGRectMake(topMenu.bounds.size.width/2, 0, topMenu.bounds.size.width/2, 45);
    [addFavOverlayButton addTarget:self action:@selector(addABCWaterToFavourites) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:addFavOverlayButton];
    
    
    if ([phoneNoString length]==0) {
        addPhotoButton.alpha = 0.4;
        addPhotoLabel.alpha = 0.4;
        addPhotoButton.enabled = NO;
        addPhotoOverlayButton.enabled = NO;
    }
}


- (void) viewWillAppear:(BOOL)animated {
    
    [appDelegate setShouldRotate:NO];
    
    [CommonFunctions googleAnalyticsTracking:@"Page: Our Waters Detail"];
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(76,175,238) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    appDelegate.IS_ARVIEW_CUSTOM_LABEL = NO;
    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
    [self.navigationController setNavigationBarHidden:NO];
    
    // Enable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


- (void) viewDidAppear:(BOOL)animated {
    
    //    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
    //    swipeGesture.numberOfTouchesRequired = 1;
    //    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
    //
    //    [self.view addGestureRecognizer:swipeGesture];
    
    //    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationPortrait] forKey:@"orientation"];
    
}


//-(BOOL)shouldAutorotate{
//    return YES;
//}
//
//-(NSUInteger)supportedInterfaceOrientations{
//    
//    //    UIInterfaceOrientationMaskLandscape;
//    //    24
//    //
//    //    UIInterfaceOrientationMaskLandscapeLeft;
//    //    16
//    //
//    //    UIInterfaceOrientationMaskLandscapeRight;
//    //    8
//    //
//    //    UIInterfaceOrientationMaskPortrait;
//    //    2
//    
//    //    return UIInterfaceOrientationMaskPortrait;
//    //    or
//    return 2;
//}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}


@end
