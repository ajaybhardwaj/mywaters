//
//  RewardDetailsViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "RewardDetailsViewController.h"

@implementation RewardDetailsViewController
@synthesize rewardID,descriptionString,titleString,validFromDateString,validTillDateString,locationValueString,pointsValueString,imageName,imageUrl,currentPointsString;
@synthesize latValue,longValue;

//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/profile_rewards_detail.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
}


//*************** Method To Move To Map Direction View

- (void) moveToDirectionView {
        
    QuickMapViewController *viewObj = [[QuickMapViewController alloc] init];
    viewObj.isShowingRoute = YES;
    viewObj.destinationLat = latValue;
    viewObj.destinationLong = longValue;
    [self.navigationController pushViewController:viewObj animated:YES];
}



//*************** Method To Show Menu On Left To Right Swipe

- (void) swipedScreen:(UISwipeGestureRecognizer*)swipeGesture {
    // do stuff
    DebugLog(@"Swipe Detected");
    self.view.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
    
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Redeem Reward

- (void) redeemReward {
    

    [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
//    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
//    appDelegate.hud.labelText = @"Loading...";
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ActionDone",@"ActionID",@"ActionType",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"8",rewardID,@"2",[CommonFunctions getAppVersionNumber], nil];
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,USER_PROFILE_ACTIONS]];
    
}


//*************** Method To Create Detail Page UI

- (void) createUI {
    
    rewardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgScrollView.bounds.size.width, 249)];
    [bgScrollView addSubview:rewardImageView];
    
    
    NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
    NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Rewards"]];
    
    NSString *localFile = [destinationPath stringByAppendingPathComponent:imageName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
        if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]] != nil)
            rewardImageView.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]];
    }
    else {
        
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,imageName];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(rewardImageView.bounds.size.width/2, rewardImageView.bounds.size.height/2);
        [rewardImageView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                
                rewardImageView.image = image;
                
                NSFileManager *fileManger=[NSFileManager defaultManager];
                NSError* error;
                
                if (![fileManger fileExistsAtPath:destinationPath]){
                    
                    if([[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:&error])
                        ;// success
                    else
                    {
                        DebugLog(@"[%@] ERROR: attempting to write create MyTasks directory", [self class]);
//                        NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
                    }
                }
                
                NSData *data = UIImageJPEGRepresentation(image, 0.8);
                [data writeToFile:[destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]] atomically:YES];
            }
            else {
                DebugLog(@"Image Loading Failed..!!");
                rewardImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
            }
            [activityIndicator stopAnimating];
        }];
    }
    
    
    directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    directionButton.frame = CGRectMake(0, rewardImageView.frame.origin.y+rewardImageView.bounds.size.height, bgScrollView.bounds.size.width, 40);
    [directionButton setBackgroundColor:[UIColor whiteColor]];
    [directionButton addTarget:self action:@selector(moveToDirectionView) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:directionButton];
    
    directionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
    [directionIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_directions_purple.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [directionButton addSubview:directionIcon];
    
    
    rewardTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, directionButton.bounds.size.width-120, 40)];
    rewardTitle.backgroundColor = [UIColor whiteColor];
    rewardTitle.textAlignment = NSTextAlignmentLeft;
    rewardTitle.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    rewardTitle.text = titleString;
    [directionButton addSubview:rewardTitle];

    
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
        if (appDelegate.CURRENT_LOCATION_LAT == 0.0 && appDelegate.CURRENT_LOCATION_LONG == 0.0) {
            distanceLabel.text = @"";
            arrowIcon.hidden = YES;
            directionButton.enabled = NO;
        }
    }
    
    
    rewardInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, directionButton.frame.origin.y+directionButton.bounds.size.height+5, self.view.bounds.size.width, 40)];
    rewardInfoLabel.backgroundColor = [UIColor whiteColor];
    rewardInfoLabel.textAlignment = NSTextAlignmentLeft;
    rewardInfoLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    rewardInfoLabel.text = @"            Reward Info";
    [bgScrollView addSubview:rewardInfoLabel];
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, rewardInfoLabel.bounds.size.width, 0.5)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [rewardInfoLabel addSubview:seperatorImage];
    
    
    infoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 19, 19)];
    [infoIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_info_purple.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [rewardInfoLabel addSubview:infoIcon];
    
    
    descriptionLabel = [[UILabel___Extension alloc] initWithFrame:CGRectMake(0, rewardInfoLabel.frame.origin.y+rewardInfoLabel.bounds.size.height, bgScrollView.bounds.size.width, 40)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.text = [NSString stringWithFormat:@"%@",descriptionString];
    descriptionLabel.textColor = [UIColor darkGrayColor];
    descriptionLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect newDescriptionLabelFrame = descriptionLabel.frame;
    newDescriptionLabelFrame.size.height = [CommonFunctions heightForText:descriptionString font:descriptionLabel.font withinWidth:bgScrollView.bounds.size.width-40];//expectedDescriptionLabelSize.height;
    descriptionLabel.frame = newDescriptionLabelFrame;
    [bgScrollView addSubview:descriptionLabel];
    
    validFromLabel = [[UILabel___Extension alloc] initWithFrame:CGRectMake(0, descriptionLabel.frame.origin.y+descriptionLabel.bounds.size.height+10, bgScrollView.bounds.size.width, 20)];
    validFromLabel.backgroundColor = [UIColor clearColor];
    validFromLabel.text = @"Valid From";
    validFromLabel.textColor = [UIColor darkGrayColor];
    validFromLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    validFromLabel.numberOfLines = 0;
    validFromLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [bgScrollView addSubview:validFromLabel];
    
    validFromValueLabel = [[UILabel___Extension alloc] initWithFrame:CGRectMake(0, validFromLabel.frame.origin.y+validFromLabel.bounds.size.height, bgScrollView.bounds.size.width, 20)];
    validFromValueLabel.backgroundColor = [UIColor clearColor];
    validFromValueLabel.text = [NSString stringWithFormat:@"%@",validFromDateString];
    validFromValueLabel.textColor = [UIColor darkGrayColor];
    validFromValueLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    validFromValueLabel.numberOfLines = 0;
    validFromValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [bgScrollView addSubview:validFromValueLabel];
    
    validToLabel = [[UILabel___Extension alloc] initWithFrame:CGRectMake(0, validFromValueLabel.frame.origin.y+validFromValueLabel.bounds.size.height+10, bgScrollView.bounds.size.width, 20)];
    validToLabel.backgroundColor = [UIColor clearColor];
    validToLabel.text = @"Valid Till";
    validToLabel.textColor = [UIColor darkGrayColor];
    validToLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    validToLabel.numberOfLines = 0;
    validToLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [bgScrollView addSubview:validToLabel];
    
    validToValueLabel = [[UILabel___Extension alloc] initWithFrame:CGRectMake(0, validToLabel.frame.origin.y+validToLabel.bounds.size.height, bgScrollView.bounds.size.width, 20)];
    validToValueLabel.backgroundColor = [UIColor clearColor];
    validToValueLabel.text = [NSString stringWithFormat:@"%@",validTillDateString];
    validToValueLabel.textColor = [UIColor darkGrayColor];
    validToValueLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    validToValueLabel.numberOfLines = 0;
    validToValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [bgScrollView addSubview:validToValueLabel];
    
    locationLabel = [[UILabel___Extension alloc] initWithFrame:CGRectMake(0, validToValueLabel.frame.origin.y+validToValueLabel.bounds.size.height+10, bgScrollView.bounds.size.width, 20)];
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.text = @"Location";
    locationLabel.textColor = [UIColor darkGrayColor];
    locationLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    locationLabel.numberOfLines = 0;
    locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [bgScrollView addSubview:locationLabel];
    
    
    locationValueLabel = [[UILabel___Extension alloc] initWithFrame:CGRectMake(0, locationLabel.frame.origin.y+locationLabel.bounds.size.height, bgScrollView.bounds.size.width, 20)];
    locationValueLabel.backgroundColor = [UIColor clearColor];
    locationValueLabel.text = [NSString stringWithFormat:@"%@",locationValueString];
    locationValueLabel.textColor = [UIColor darkGrayColor];
    locationValueLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    locationValueLabel.numberOfLines = 0;
    locationValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [bgScrollView addSubview:locationValueLabel];

    
    pointsLabel = [[UILabel___Extension alloc] initWithFrame:CGRectMake(0, locationValueLabel.frame.origin.y+locationValueLabel.bounds.size.height+10, bgScrollView.bounds.size.width, 20)];
    pointsLabel.backgroundColor = [UIColor clearColor];
    pointsLabel.text = [NSString stringWithFormat:@"Points: %@",pointsValueString];
    pointsLabel.textColor = [UIColor darkGrayColor];
    pointsLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    pointsLabel.numberOfLines = 0;
    pointsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [bgScrollView addSubview:pointsLabel];
    
    bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, rewardImageView.bounds.size.height+directionButton.bounds.size.height+rewardInfoLabel.bounds.size.height+descriptionLabel.bounds.size.height+validFromLabel.bounds.size.height+validFromValueLabel.bounds.size.height+validToLabel.bounds.size.height+validToValueLabel.bounds.size.height+locationLabel.bounds.size.height+locationValueLabel.bounds.size.height+pointsLabel.bounds.size.height+100);
}



# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    [CommonFunctions dismissGlobalHUD];
//    [appDelegate.hud hide:YES];

    DebugLog(@"%@",responseString);
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
    
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
    [CommonFunctions dismissGlobalHUD];
//    [appDelegate.hud hide:YES];
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Reward Info";
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
    
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-114)];
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    bgScrollView.backgroundColor = [UIColor whiteColor];
    
    
    [self createUI];
    
    
    redeemNowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    redeemNowButton.frame = CGRectMake(0, bgScrollView.frame.origin.y+bgScrollView.bounds.size.height, self.view.bounds.size.width, 50);
    redeemNowButton.backgroundColor = RGB(85,49,118);
    [redeemNowButton setTitle:@"REDEEM NOW" forState:UIControlStateNormal];
    [redeemNowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    redeemNowButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    [redeemNowButton addTarget:self action:@selector(redeemReward) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redeemNowButton];
    
//    if ([pointsValueString intValue] > [currentPointsString intValue]) {
//        redeemNowButton.userInteractionEnabled = NO;
//    }
    
}


- (void) viewDidAppear:(BOOL)animated {
    
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
//    swipeGesture.numberOfTouchesRequired = 1;
//    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
//    
//    [self.view addGestureRecognizer:swipeGesture];
    
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
