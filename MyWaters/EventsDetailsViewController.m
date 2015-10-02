//
//  EventsDetailsViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 29/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "EventsDetailsViewController.h"
#import "AppDelegate.h"

@implementation EventsDetailsViewController
@synthesize eventID,imageUrl,titleString,descriptionString,latValue,longValue,phoneNoString,addressString,startDateString,endDateString,websiteString,imageName;



//*************** Demo App UI

- (void) createDemoAppControls {
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/events_detail_options.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
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



//*************** Method To Add CCTV To Favourites

- (void) addEventsToFavourites {
    
    [self animateTopMenu];
    
    NSMutableDictionary *parametersDict = [[NSMutableDictionary alloc] init];
    
    [parametersDict setValue:eventID forKey:@"fav_id"];
    [parametersDict setValue:@"2" forKey:@"fav_type"];
    [parametersDict setValue:titleString forKey:@"name"];
    [parametersDict setValue:imageName forKey:@"image"];
    [parametersDict setValue:[NSString stringWithFormat:@"%f",latValue] forKey:@"lat"];
    [parametersDict setValue:[NSString stringWithFormat:@"%f",latValue] forKey:@"long"];
    
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
    
    if (startDateString != (id)[NSNull null] && [startDateString length] !=0)
        [parametersDict setValue:startDateString forKey:@"start_date_event"];
    else
        [parametersDict setValue:@"NA" forKey:@"start_date_event"];
    
    if (endDateString != (id)[NSNull null] && [endDateString length] !=0)
        [parametersDict setValue:endDateString forKey:@"end_date_event"];
    else
        [parametersDict setValue:@"NA" forKey:@"end_date_event"];
    
    if (websiteString != (id)[NSNull null] && [websiteString length] !=0)
        [parametersDict setValue:websiteString forKey:@"website_event"];
    else
        [parametersDict setValue:@"NA" forKey:@"website_event"];
    
    [parametersDict setValue:@"NA" forKey:@"isCertified_ABC"];
    [parametersDict setValue:@"NA" forKey:@"water_level_wls"];
    [parametersDict setValue:@"NA" forKey:@"drain_depth_wls"];
    [parametersDict setValue:@"NA" forKey:@"water_level_percentage_wls"];
    [parametersDict setValue:@"NA" forKey:@"water_level_type_wls"];
    [parametersDict setValue:@"NA" forKey:@"observation_time_wls"];
    
    
    [appDelegate insertFavouriteItems:parametersDict];
}



//*************** Method To Create Detail Page UI

- (void) createUI {
    
//    float h2 = 0;
//    
//    if ([dataDict objectForKey:@"image_size"] !=(id)[NSNull null]) {
//        NSArray *tempArray = [[dataDict objectForKey:@"image_size"] componentsSeparatedByString: @","];
//        
//        float w1 = [[tempArray objectAtIndex:0] floatValue];
//        float h1 = [[tempArray objectAtIndex:1] floatValue];
//        h2 = (h1*self.view.bounds.size.width)/w1;
//    }
    
    
    eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgScrollView.bounds.size.width, 249)];
    [bgScrollView addSubview:eventImageView];
    
    NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
    NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Events"]];
    
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

    
    directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    directionButton.frame = CGRectMake(0, eventImageView.frame.origin.y+eventImageView.bounds.size.height, bgScrollView.bounds.size.width, 40);
    [directionButton setBackgroundColor:[UIColor whiteColor]];
    [bgScrollView addSubview:directionButton];
    
    directionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
    [directionIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_directions.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [directionButton addSubview:directionIcon];
    
    
    eventTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, directionButton.bounds.size.width-140, 40)];
    eventTitle.backgroundColor = [UIColor whiteColor];
    eventTitle.textAlignment = NSTextAlignmentLeft;
    eventTitle.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    eventTitle.text = titleString;
    eventTitle.numberOfLines = 0;
    [directionButton addSubview:eventTitle];
    
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(directionButton.bounds.size.width-130, 0, 100, 40)];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    distanceLabel.text = @"";//@"1.03 KM";
    [directionButton addSubview:distanceLabel];
    
    arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(directionButton.bounds.size.width-20, 12.5, 15, 15)];
    [arrowIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_arrow_grey.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [directionButton addSubview:arrowIcon];
    

    
    eventInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, directionButton.frame.origin.y+directionButton.bounds.size.height+5, self.view.bounds.size.width, 40)];
    eventInfoLabel.backgroundColor = [UIColor whiteColor];
    eventInfoLabel.textAlignment = NSTextAlignmentLeft;
    eventInfoLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    eventInfoLabel.text = @"            Event Info";
    [bgScrollView addSubview:eventInfoLabel];
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, eventInfoLabel.bounds.size.width, 0.5)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [eventInfoLabel addSubview:seperatorImage];

    
    infoIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 19, 19)];
    [infoIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_info.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [eventInfoLabel addSubview:infoIcon];

    
    descriptionLabel = [[UILabel___Extension alloc] initWithFrame:CGRectMake(0, eventInfoLabel.frame.origin.y+eventInfoLabel.bounds.size.height, bgScrollView.bounds.size.width, 40)];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.text = [NSString stringWithFormat:@"%@",descriptionString];
    descriptionLabel.textColor = [UIColor darkGrayColor];
    descriptionLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect newDescriptionLabelFrame = descriptionLabel.frame;
    newDescriptionLabelFrame.size.height = [CommonFunctions heightForText:descriptionString font:descriptionLabel.font withinWidth:bgScrollView.bounds.size.width];//expectedDescriptionLabelSize.height;
    descriptionLabel.frame = newDescriptionLabelFrame;
    [bgScrollView addSubview:descriptionLabel];
    
    UILabel *startDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, descriptionLabel.frame.origin.y+descriptionLabel.bounds.size.height+20, bgScrollView.bounds.size.width-80, 15)];
    startDateLabel.textColor = [UIColor darkGrayColor];
    startDateLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    startDateLabel.backgroundColor = [UIColor clearColor];
    startDateLabel.text = @"Start Date:";
    [bgScrollView addSubview:startDateLabel];
    
    UILabel *startDateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, startDateLabel.frame.origin.y+startDateLabel.bounds.size.height+5, bgScrollView.bounds.size.width-80, 15)];
    startDateValueLabel.textColor = [UIColor darkGrayColor];
    startDateValueLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    startDateValueLabel.backgroundColor = [UIColor clearColor];
    startDateValueLabel.text = startDateString;
    [bgScrollView addSubview:startDateValueLabel];
    
    
    UILabel *endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, startDateValueLabel.frame.origin.y+startDateValueLabel.bounds.size.height+20, bgScrollView.bounds.size.width-80, 15)];
    endDateLabel.textColor = [UIColor darkGrayColor];
    endDateLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    endDateLabel.backgroundColor = [UIColor clearColor];
    endDateLabel.text = @"End Date:";
    [bgScrollView addSubview:endDateLabel];
    
    UILabel *endDateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, endDateLabel.frame.origin.y+endDateLabel.bounds.size.height+5, bgScrollView.bounds.size.width-80, 15)];
    endDateValueLabel.textColor = [UIColor darkGrayColor];
    endDateValueLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    endDateValueLabel.backgroundColor = [UIColor clearColor];
    endDateValueLabel.text = endDateString;
    [bgScrollView addSubview:endDateValueLabel];
    
    
    UILabel *locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, endDateValueLabel.frame.origin.y+endDateValueLabel.bounds.size.height+20, bgScrollView.bounds.size.width-80, 15)];
    locationLabel.textColor = [UIColor darkGrayColor];
    locationLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    locationLabel.backgroundColor = [UIColor clearColor];
    locationLabel.text = @"Location:";
    [bgScrollView addSubview:locationLabel];
    
    UILabel *locationValueLabel = [[UILabel___Extension alloc] initWithFrame:CGRectMake(0, locationLabel.frame.origin.y+locationLabel.bounds.size.height+5, bgScrollView.bounds.size.width, 40)];
    locationValueLabel.backgroundColor = [UIColor whiteColor];
    locationValueLabel.text = [NSString stringWithFormat:@"%@",addressString];
    locationValueLabel.textColor = [UIColor darkGrayColor];
    locationValueLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    locationValueLabel.numberOfLines = 0;
    locationValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    CGRect newLocationLabelFrame = locationValueLabel.frame;
    newLocationLabelFrame.size.height = [CommonFunctions heightForText:addressString font:locationValueLabel.font withinWidth:bgScrollView.bounds.size.width];//expectedDescriptionLabelSize.height;
    locationValueLabel.frame = newLocationLabelFrame;
    [bgScrollView addSubview:locationValueLabel];
    [locationValueLabel sizeToFit];
    
    bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, eventImageView.bounds.size.height+directionButton.bounds.size.height+eventInfoLabel.bounds.size.height+descriptionLabel.bounds.size.height+startDateLabel.bounds.size.height+startDateValueLabel.bounds.size.height+endDateLabel.bounds.size.height+endDateValueLabel.bounds.size.height+locationLabel.bounds.size.height+locationValueLabel.bounds.size.height+100);
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Event Info";
    self.view.backgroundColor = RGB(242, 242, 242);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateTopMenu) withIconName:@"icn_3dots"]];
    
    //    [self createDemoAppControls];
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(247,196,9) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];

    
    
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    bgScrollView.backgroundColor = [UIColor whiteColor];
    
    
    [self createUI];
    
//    callUsButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    callUsButton.frame = CGRectMake((self.view.bounds.size.width/2)-17.5, bgScrollView.frame.origin.y+bgScrollView.bounds.size.height+10, 25, 25);
//    [callUsButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_call_yellow.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
//    [self.view addSubview:callUsButton];
//    
//    
//    callUsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, callUsButton.frame.origin.y+callUsButton.bounds.size.height+4, self.view.bounds.size.width, 15)];
//    callUsLabel.backgroundColor = [UIColor clearColor];
//    callUsLabel.textAlignment = NSTextAlignmentCenter;
//    callUsLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
//    callUsLabel.text = @"Call Us";
//    [self.view addSubview:callUsLabel];
    
    
    //Top Menu Item
    
    topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, -60, self.view.bounds.size.width, 45)];
    topMenu.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:topMenu];
    
    notifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    notifyButton.frame = CGRectMake((topMenu.bounds.size.width/3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 5, 20, 20);
    [notifyButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_notifyme.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [notifyButton addTarget:self action:@selector(animateTopMenu) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:notifyButton];
    
    favouritesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favouritesButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*2)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 5, 20, 20);
    [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [favouritesButton addTarget:self action:@selector(addEventsToFavourites) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:favouritesButton];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 5, 20, 20);
    [shareButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_share.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(animateTopMenu) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:shareButton];
    
    notifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, topMenu.bounds.size.width/3, 10)];
    notifyLabel.backgroundColor = [UIColor clearColor];
    notifyLabel.textAlignment = NSTextAlignmentCenter;
    notifyLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    notifyLabel.text = @"Notify Me";
    notifyLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:notifyLabel];
    
    addToFavlabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3), 32, topMenu.bounds.size.width/3, 10)];
    addToFavlabel.backgroundColor = [UIColor clearColor];
    addToFavlabel.textAlignment = NSTextAlignmentCenter;
    addToFavlabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    addToFavlabel.text = @"Add To Favourite";
    addToFavlabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:addToFavlabel];
    
    shareLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3)*2, 32, topMenu.bounds.size.width/3, 10)];
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    shareLabel.text = @"Share";
    shareLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:shareLabel];
}

- (void) viewDidAppear:(BOOL)animated {
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
    swipeGesture.numberOfTouchesRequired = 1;
    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
    
    [self.view addGestureRecognizer:swipeGesture];
    
}


@end
