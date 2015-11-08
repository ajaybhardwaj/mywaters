//
//  ARViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 17/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ARViewController.h"
#import "MarkerView.h"

@interface ARViewController () <MarkerViewDelegate>

@property (nonatomic, strong) AugmentedRealityController *arController;
@property (nonatomic, strong) NSMutableArray *geoLocations;

@end

@interface UIDevice (MyPrivateNameThatAppleWouldNeverUseGoesHere)
- (void) setOrientation:(UIInterfaceOrientation)orientation;
@end

@implementation ARViewController
@synthesize abcWaterSiteID;


//*************** Method To Move To Photo Gallery

- (void) tapToMoveToPhotoGallery:(id) sender {
    
    
    if (pictureDataSourceForGallery.count!=0) {
        [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        [self.navigationController pushViewController:networkGallery animated:YES];
    }
    
    //    GalleryViewController *viewObj = [[GalleryViewController alloc] init];
    //    viewObj.galleryImages = photosDataSource;
    //    viewObj.isABCGallery = NO;
    //    viewObj.isUserGallery = YES;
    //    viewObj.isPOIGallery = NO;
    //    [self.navigationController pushViewController:viewObj animated:YES];
}

//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Animate Search Bar

- (void) animatePictureOptionsTable {
    
    [UIView beginAnimations:@"picOptions" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = imageUploadOptionsTable.center;
    
    if (isShowingPictureOptions) {
        isShowingPictureOptions = NO;
        pos.y = self.view.bounds.size.width;
        
    }
    else {
        isShowingPictureOptions = YES;
        pos.y = self.view.bounds.size.width-340;
        
    }
    imageUploadOptionsTable.center = pos;
    [UIView commitAnimations];
}


//*************** Method To Dismiss ARView

- (void) dismissARView {
    
//    [appDelegate setShouldRotate:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}


//*************** Method To Remove Overlay ScrollView

- (void) removeOverlayScrollview {
    
    for (UIView * view in overlayScrollview.subviews) {
        [view removeFromSuperview];
    }
    
    overlayScrollview.hidden = YES;
}


//*************** Method To Create POI Photos ScrollView

- (void) createPhotosScrollView {
    
    for (UIView * view in picturesScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    int xAxis = 20;
    
    NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
    NSString *destinationPath = [doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"POIGallery"]];
    
    
    DebugLog(@"Pictures Data %@",pictureDataSource);
    
    for (int i=0; i<pictureDataSource.count; i++) {
        
        UIImageView *galleryImage = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, 5, 70, 70)];
        [galleryImage setBackgroundColor:[UIColor whiteColor]];
        galleryImage.tag = i;
        [picturesScrollView addSubview:galleryImage];
        galleryImage.userInteractionEnabled = YES;
        
        UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        tapButton.frame = CGRectMake(0, 0, galleryImage.bounds.size.width, galleryImage.bounds.size.height);
        tapButton.tag = i;
        [tapButton addTarget:self action:@selector(tapToMoveToPhotoGallery:) forControlEvents:UIControlEventTouchUpInside];
        [galleryImage addSubview:tapButton];
        
        NSString *imageName = [[pictureDataSource objectAtIndex:i] objectForKey:@"Image"];
        
        NSString *localFile = [destinationPath stringByAppendingPathComponent:imageName];
        
        xAxis = xAxis + 90;

        
        if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
            if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]] != nil)
                galleryImage.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]];
        }
        else {
            
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[pictureDataSource objectAtIndex:i] objectForKey:@"Image"]];
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.center = CGPointMake(galleryImage.bounds.size.width/2, galleryImage.bounds.size.height/2);
            [galleryImage addSubview:activityIndicator];
            [activityIndicator startAnimating];
            
            
            
            [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    
                    galleryImage.image = image;
                    
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
                [activityIndicator stopAnimating];
                
            }];
            
        }

    }
    
    UIButton *addPictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addPictureButton.frame = CGRectMake(xAxis, 5, 70, 70);
    [addPictureButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_add.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [addPictureButton addTarget:self action:@selector(animatePictureOptionsTable) forControlEvents:UIControlEventTouchUpInside];
    [picturesScrollView addSubview:addPictureButton];
    
    picturesScrollView.contentSize = CGSizeMake((pictureDataSource.count*70 + pictureDataSource.count*20 + 100), 80);
    overlayScrollview.contentSize = CGSizeMake(self.view.bounds.size.height, 10+titleLabel.bounds.size.height+10+seperatorImageView.bounds.size.height+10+descriptionLabel.bounds.size.height+10+picturesScrollView.bounds.size.height+30);

    
}

//*************** Method To Call ABCWaterSites API

- (void) fetchABCWaterSitePOI {
    
    isFetchingImages = NO;
    isFetchingPOI = YES;
    isUploadingImage = NO;
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ABCWaterSitesID", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:abcWaterSiteID, nil];
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,ABC_WATERS_POI]];
}




//*************** Method To Call ABCWaterSites API

- (void) fetchABCWaterPOIImage:(NSInteger) tagValue {
    
//    [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
    isFetchingImages = YES;
    isFetchingPOI = NO;
    isUploadingImage = NO;
    
    poiID = [[[appDelegate.POI_ARRAY objectAtIndex:tagValue] objectForKey:@"ID"] intValue];
    poiType = [[[appDelegate.POI_ARRAY objectAtIndex:tagValue] objectForKey:@"Type"] intValue];
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ABCPOIID", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%ld",poiID], nil];
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,ABC_WATERS_POI]];
}




//*************** Method To Create AR View Pointers

- (void) generateGeoLocations {
    
    //    [appDelegate retrievePointOfInterests:1];
    
    DebugLog(@"%@",appDelegate.POI_ARRAY);
    
    if (appDelegate.POI_ARRAY.count!=0) {
        
        [self setGeoLocations:[NSMutableArray arrayWithCapacity:appDelegate.POI_ARRAY.count]];
        
        for (int i=0; i<appDelegate.POI_ARRAY.count; i++) {
            
            CLLocation *locationValue=[[CLLocation alloc] initWithLatitude:[[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"Lat"] doubleValue] longitude:[[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"Lon"] doubleValue]];
            
            ARGeoCoordinate *coordinate = [ARGeoCoordinate coordinateWithLocation:locationValue locationTitle:[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"Name"]];
            [coordinate calibrateUsingOrigin:[_userLocation location]];
            MarkerView *markerView = [[MarkerView alloc] initWithCoordinate:coordinate delegate:self image:[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"MainImage"]];
            DebugLog(@"Marker view %@", markerView);
            markerView.tag = i; //[[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"ID"] intValue];
            
            [coordinate setDisplayView:markerView];
            [_arController addCoordinate:coordinate];
            [_geoLocations addObject:coordinate];
        }
    }
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
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    NSData* data = UIImageJPEGRepresentation(chosenImage, 0.5f);
    NSString *base64ImageString = [Base64 encode:data];
    
    isFetchingImages = NO;
    isFetchingPOI = NO;
    isUploadingImage = YES;
    
//    [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
//    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
//    appDelegate.hud.labelText = @"Loading...";
    
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    [parameters addObject:@"ABCPOIImage.Image"];
    [values addObject:base64ImageString];
    
    [parameters addObject:@"ABCPOIImage.ABCPOIID"];
    [values addObject:[NSString stringWithFormat:@"%ld",poiID]];
    
    
    [parameters addObject:@"ABCPOIImage.Type"];
    [values addObject:[NSString stringWithFormat:@"%ld",poiType]];
    
    [parameters addObject:@"ABCPOIImage.UserProfileID"];
    [values addObject:[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userID"]];
    
    [parameters addObject:@"ABCPOIImage.UserProfileName"];
    [values addObject:[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userEmail"]];
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,ABC_WATERS_UPLOAD_USER_IMAGE]];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];

}



# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
//    [CommonFunctions dismissGlobalHUD];

    DebugLog(@"%@",responseString);
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        if (isFetchingPOI) {
            
            [appDelegate.POI_ARRAY removeAllObjects];
            
            NSArray *tempArray = [[responseString JSONValue] objectForKey:ABC_WATER_SITES_POI_RESPONSE_NAME];
            if (tempArray.count==0) {
                
            }
            else {
                
                if (appDelegate.POI_ARRAY.count==0) {
                    [appDelegate.POI_ARRAY setArray:tempArray];
                }
                else {
                    if (appDelegate.POI_ARRAY.count!=0) {
                        for (int i=0; i<tempArray.count; i++) {
                            [appDelegate.POI_ARRAY addObject:[tempArray objectAtIndex:i]];
                        }
                    }
                }
            }
            
            if (appDelegate.POI_ARRAY.count!=0) {
                [self generateGeoLocations];
            }
        }
        else if (isFetchingImages) {
            
            pictureDataSource = [[responseString JSONValue] objectForKey:ABC_WATER_SITES_POI_IMAGES];
            [pictureDataSourceForGallery removeAllObjects];
            for (int i=0; i<pictureDataSource.count; i++) {
                [pictureDataSourceForGallery addObject:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[pictureDataSource objectAtIndex:i] objectForKey:@"Image"]]];
            }
            [self createPhotosScrollView];
            
        }
        else if (isUploadingImage) {
            
            [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
            [self fetchABCWaterPOIImage:poiID];
        }
    }
//    [appDelegate.hud hide:YES];
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
//    [CommonFunctions dismissGlobalHUD];
//    [appDelegate.hud hide:YES];
}


#pragma mark - ARLocationDelegate

-(NSMutableArray *)geoLocations {
    
    if(!_geoLocations) {
        
        [self generateGeoLocations];
    }
    return _geoLocations;
}

- (void)locationClicked:(ARGeoCoordinate *)coordinate {
    DebugLog(@"Tapped location %@", coordinate);
}

#pragma mark - ARDelegate

-(void)didUpdateHeading:(CLHeading *)newHeading {
    
}

-(void)didUpdateLocation:(CLLocation *)newLocation {
    
}

-(void)didUpdateOrientation:(UIDeviceOrientation)orientation {
    
}

#pragma mark - ARMarkerDelegate

-(void)didTapMarker:(ARGeoCoordinate *)coordinate {
    
    
}


- (void)didTouchMarkerView:(MarkerView *)markerView {
    
    overlayScrollview.hidden = NO;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 50.0f, self.view.bounds.size.width-20.0f, 25.0f)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:18.0];
    titleLabel.text = [[appDelegate.POI_ARRAY objectAtIndex:markerView.tag] objectForKey:@"Name"];
    [overlayScrollview addSubview:titleLabel];
    
    CLLocation *locationValue=[[CLLocation alloc] initWithLatitude:[[[appDelegate.POI_ARRAY objectAtIndex:markerView.tag] objectForKey:@"Lat"] doubleValue] longitude:[[[appDelegate.POI_ARRAY objectAtIndex:markerView.tag] objectForKey:@"Lon"] doubleValue]];
    ARGeoCoordinate *coordinate = [ARGeoCoordinate coordinateWithLocation:locationValue locationTitle:[[appDelegate.POI_ARRAY objectAtIndex:markerView.tag] objectForKey:@"Name"]];
    [coordinate calibrateUsingOrigin:[_userLocation location]];
    
    
    CLLocationCoordinate2D currentLocation;
    CLLocationCoordinate2D desinationLocation;
    
    currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
    currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
    
    desinationLocation.latitude = [[[appDelegate.POI_ARRAY objectAtIndex:markerView.tag] objectForKey:@"Lat"] doubleValue];
    desinationLocation.longitude = [[[appDelegate.POI_ARRAY objectAtIndex:markerView.tag] objectForKey:@"Lon"] doubleValue];
    
    
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width-100.0f, 50.0f, 70.0f, 25.0f)];
    distanceLabel.textColor = [UIColor whiteColor];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:18.0];
//    distanceLabel.text = [NSString stringWithFormat:@"%.2f km", [coordinate distanceFromOrigin] / 1000.0f];
    distanceLabel.text = [NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    [overlayScrollview addSubview:distanceLabel];
    
    seperatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 80.0f, self.view.bounds.size.width-40.0f, 2.0f)];
    seperatorImageView.backgroundColor = [UIColor whiteColor];
    [overlayScrollview addSubview:seperatorImageView];
    
    
    descriptionLabel = [[UILabel___Extension alloc] initWithFrame:CGRectMake(20.0f, seperatorImageView.frame.origin.y+seperatorImageView.bounds.size.height+10.0f, self.view.bounds.size.width-40.0f, 40.0f)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.text = [NSString stringWithFormat:@"%@",[[appDelegate.POI_ARRAY objectAtIndex:markerView.tag] objectForKey:@"Description"]];
    descriptionLabel.textColor = [UIColor whiteColor];
    descriptionLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect newDescriptionLabelFrame = descriptionLabel.frame;
    newDescriptionLabelFrame.size.height = [CommonFunctions heightForText:[[appDelegate.POI_ARRAY objectAtIndex:markerView.tag] objectForKey:@"Description"] font:descriptionLabel.font withinWidth:overlayScrollview.bounds.size.width];
    descriptionLabel.frame = newDescriptionLabelFrame;
    [overlayScrollview addSubview:descriptionLabel];
    
    
    picturesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, descriptionLabel.frame.origin.y+descriptionLabel.bounds.size.height+10.0f, self.view.bounds.size.width, 80.0f)];
    picturesScrollView.showsHorizontalScrollIndicator = NO;
    picturesScrollView.showsVerticalScrollIndicator = NO;
    [overlayScrollview addSubview:picturesScrollView];
    picturesScrollView.backgroundColor = [UIColor clearColor];
    
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(overlayScrollview.bounds.size.width-45.0f, 10.0f, 25.0f, 25.0f);
    [closeButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_cross.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(removeOverlayScrollview) forControlEvents:UIControlEventTouchUpInside];
    [overlayScrollview addSubview:closeButton];
    
    NSLog(@"%ld",markerView.tag);
    
    [self fetchABCWaterPOIImage:markerView.tag];
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //    UIView *infoView = [[self view] viewWithTag:kInfoViewTag];
    //    [infoView removeFromSuperview];
}



# pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //1
    CLLocation *lastLocation = [locations lastObject];
    
    //2
    CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
    DebugLog(@"Received location %@ with accuracy %f", lastLocation, accuracy);
    
    //3
    if(accuracy < 1000.0) {
        MKCoordinateSpan span = MKCoordinateSpanMake(0.14, 0.14);
        MKCoordinateRegion region = MKCoordinateRegionMake([lastLocation coordinate], span);
        
        [_mapView setRegion:region animated:YES];
        
        NSMutableArray *temp = [NSMutableArray array];
        
        for (int i=0; i<appDelegate.POI_ARRAY.count; i++) {
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"Lat"] doubleValue] longitude:[[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"Lon"] doubleValue]];
            Place *currentPlace = [[Place alloc] initWithLocation:location reference:nil name:[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"Name"] address:[[appDelegate.POI_ARRAY objectAtIndex:i] objectForKey:@"Address"]];
            [temp addObject:currentPlace];
            
        }
        
        _locations = [temp copy];
        DebugLog(@"Locations: %@", _locations);
        
    }
    
    [manager stopUpdatingLocation];
    
}




# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    
    if (indexPath.row==0) {
        cell.textLabel.text = @"Take Photo";
    }
    else if (indexPath.row==1) {
        cell.textLabel.text = @"Photo Library";
    }
    else if (indexPath.row==2) {
        cell.textLabel.text = @"Cancel";
    }
    
    return cell;
}


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, imageUploadOptionsTable.bounds.size.width, 50)];
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.text = @"Select Source";
    headerLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    
    return headerLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [UIView beginAnimations:@"picOptions" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = imageUploadOptionsTable.center;
    
    if (isShowingPictureOptions) {
        isShowingPictureOptions = NO;
        pos.y = self.view.bounds.size.width;
        
    }
    else {
        isShowingPictureOptions = YES;
        pos.y = self.view.bounds.size.width-340;
        
    }
    imageUploadOptionsTable.center = pos;
    [UIView commitAnimations];
    
    if (indexPath.row==0) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            isShowingImagePicker = YES;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            [self.view addSubview:picker.view];
//            picker.view.frame = self.view.frame;
//            picker.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//            [picker didMoveToParentViewController:self];
            [self presentViewController:picker animated:YES completion:NULL];
        }
        else {
            [CommonFunctions showAlertView:nil title:@"Sorry..!!" msg:@"Device does not have camera." cancel:@"OK" otherButton:nil];
        }
        
    }
    else if (indexPath.row==1) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            isShowingImagePicker = YES;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

//            [self.view addSubview:picker.view];
//            picker.view.frame = self.view.frame;
//            picker.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//            [picker didMoveToParentViewController:self];

            [self presentViewController:picker animated:YES completion:NULL];
        }
        else {
            [CommonFunctions showAlertView:nil title:@"Sorry..!!" msg:@"Photo library does not exists." cancel:@"OK" otherButton:nil];
        }
    }
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
        num = (int)[pictureDataSourceForGallery count];
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
    return [pictureDataSourceForGallery objectAtIndex:index];
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}


- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}



- (void)didChangeOrientation:(NSNotification *)notification
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
//        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
    }
    else {
//        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
    }
    
   
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.IS_ARVIEW_CUSTOM_LABEL = YES;
    
//    [appDelegate setShouldRotate:YES];
//    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation:)
//                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [appDelegate setShouldRotate:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation:)
                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    
    pictureDataSourceForGallery = [[NSMutableArray alloc] init];
    
    _locations = [[NSArray alloc] init];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [_locationManager setDelegate:self];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyKilometer];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    //    [_locationManager requestAlwaysAuthorization];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startMonitoringSignificantLocationChanges];
    [_locationManager startUpdatingLocation];
    
    self.view.frame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);

    if(!_arController) {
        _arController = [[AugmentedRealityController alloc] initWithView:[self view] parentViewController:self withDelgate:self];
    }
    
    [_arController setMinimumScaleFactor:0.5];
    [_arController setScaleViewsBasedOnDistance:YES];
    [_arController setRotateViewsBasedOnPerspective:YES];
    [_arController setDebugMode:NO];
    
    toolBar = [[UIToolbar alloc]init];
    if (IS_IPHONE_4_OR_LESS) {
        toolBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    }
    else if (IS_IPHONE_5) {
        toolBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    }
    else if (IS_IPHONE_6) {
        toolBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    }
    else if (IS_IPHONE_6P) {
        toolBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
    }
    
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissARView)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:doneButton,flexibleSpace, nil]];
    [self.view addSubview:toolBar];
    
    
    
//    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
//    rotationTransform = CGAffineTransformRotate(rotationTransform, degreesToRadians(90));
//    toolBar.transform = rotationTransform;
    
    overlayScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    overlayScrollview.backgroundColor = [UIColor blackColor];
    overlayScrollview.showsHorizontalScrollIndicator = NO;
    overlayScrollview.showsVerticalScrollIndicator = NO;
    overlayScrollview.alpha = 0.8;
    [self.view addSubview:overlayScrollview];
    overlayScrollview.hidden = YES;
    
//    overlayScrollview.transform = rotationTransform;
    
    
    imageUploadOptionsTable = [[UITableView alloc] initWithFrame:CGRectMake(0.0, self.view.bounds.size.height, self.view.bounds.size.width, 200.0) style:UITableViewStyleGrouped];
    imageUploadOptionsTable.delegate = self;
    imageUploadOptionsTable.dataSource = self;
    [self.view addSubview:imageUploadOptionsTable];
    imageUploadOptionsTable.scrollEnabled = NO;
    imageUploadOptionsTable.alwaysBounceVertical = NO;

    
//    imageUploadOptionsTable.transform = rotationTransform;
    
    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
    
    [self fetchABCWaterSitePOI];
    


    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ActionDone",@"ActionID",@"ActionType",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"4",abcWaterSiteID,@"1",[CommonFunctions getAppVersionNumber], nil];
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:nil isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,USER_PROFILE_ACTIONS]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"Crashed here 1");
    self.view.frame = CGRectMake(0, 0, self.view.bounds.size.height+100, self.view.bounds.size.width);
    NSLog(@"Crashed here 2");
    
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
//    [appDelegate setShouldRotate:NO];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation:)
//                                                 name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
    [appDelegate setShouldRotate:NO];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeOrientation:)
//                                                 name:UIDeviceOrientationDidChangeNotification object:nil];

    [self.navigationController setNavigationBarHidden:YES];
//    self.view.frame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
}




- (void) viewWillDisappear:(BOOL)animated {
    
//    [appDelegate setShouldRotate:NO];
//    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];

    for (ASIHTTPRequest *req in ASIHTTPRequest.sharedQueue.operations)
    {
        [req cancel];
        [req setDelegate:nil];
    }
    
    [self.navigationController setNavigationBarHidden:NO];
}



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer) {
        return NO;
    }
    // add whatever logic you would otherwise have
    return YES;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
//    if (isShowingImagePicker) {
//        isShowingImagePicker = NO;
//        return UIInterfaceOrientationPortrait;
//    }
//    return UIInterfaceOrientationMaskLandscapeRight;
    
    return UIInterfaceOrientationMaskLandscapeRight;
}


- (BOOL)shouldAutorotate {
    return NO;
}

//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskLandscapeRight;
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
