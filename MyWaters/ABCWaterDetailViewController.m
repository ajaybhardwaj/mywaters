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
@synthesize imageUrl,titleString,descriptionString,latValue,longValue,phoneNoString,addressString;


//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwaters_detail_options.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
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


//*************** Method To Create Detail Page UI

- (void) createUI {
    
    float h2 = 0;
    
    if ([dataDict objectForKey:@"image_size"] !=(id)[NSNull null]) {
        NSArray *tempArray = [[dataDict objectForKey:@"image_size"] componentsSeparatedByString: @","];
        
        float w1 = [[tempArray objectAtIndex:0] floatValue];
        float h1 = [[tempArray objectAtIndex:1] floatValue];
        h2 = (h1*self.view.bounds.size.width)/w1;
    }
    

    
    eventImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, bgScrollView.bounds.size.width, 249)];
    [eventImageView setImageURL:[NSURL URLWithString:imageUrl]];
    eventImageView.showActivityIndicator = YES;
    [bgScrollView addSubview:eventImageView];

    
    UIImageView *certifiedLogo = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 59, 25)];
    [certifiedLogo setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwater_certified_logo.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [eventImageView addSubview:certifiedLogo];

    
    UIButton *temperatureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    temperatureButton.frame = CGRectMake(eventImageView.bounds.size.width-50, eventImageView.bounds.size.height-40, 30, 30);
    [temperatureButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_weather_abcwater.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [eventImageView addSubview:temperatureButton];
    
    directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    directionButton.frame = CGRectMake(0, eventImageView.frame.origin.y+eventImageView.bounds.size.height, bgScrollView.bounds.size.width, 40);
    [directionButton setBackgroundColor:[UIColor whiteColor]];
    [bgScrollView addSubview:directionButton];
    
    directionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
    [directionIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_directions_blue.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [directionButton addSubview:directionIcon];
    
    
    abcWaterTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, directionButton.bounds.size.width-120, 40)];
    abcWaterTitle.backgroundColor = [UIColor whiteColor];
    abcWaterTitle.textAlignment = NSTextAlignmentLeft;
    abcWaterTitle.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    abcWaterTitle.text = titleString;
    [directionButton addSubview:abcWaterTitle];
    
    
    //----- Change Current Location With Either Current Location Value or Default Location Value
    
    CLLocationCoordinate2D currentLocation;
    CLLocationCoordinate2D desinationLocation;
    
    currentLocation.latitude = 1.2912500;
    currentLocation.longitude = 103.7870230;
    
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
    newDescriptionLabelFrame.size.height = [CommonFunctions heightForText:descriptionString font:descriptionLabel.font withinWidth:bgScrollView.bounds.size.width];//expectedDescriptionLabelSize.height;
    descriptionLabel.frame = newDescriptionLabelFrame;
    [bgScrollView addSubview:descriptionLabel];
    
    bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, eventImageView.bounds.size.height+directionButton.bounds.size.height+eventInfoLabel.bounds.size.height+descriptionLabel.bounds.size.height+50);
}


- (void) moveToARView {
    
    ARViewController *viewObj = [[ARViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:NO];
//    [self.navigationController presentViewController:viewObj animated:NO completion:nil];
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    self.view.backgroundColor = RGB(242, 242, 242);
    self.title = @"ABC Waters";
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateTopMenu) withIconName:@"icn_3dots"]];

    //[self createDemoAppControls];
    
    
    
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
    [self.view addSubview:contactUsButton];
    if ([phoneNoString length]==0) {
        contactUsButton.userInteractionEnabled = NO;
    }
    
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
    [addPhotoButton addTarget:self action:@selector(animateTopMenu) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:addPhotoButton];
    
    galleryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    galleryButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*2)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 5, 20, 20);
    [galleryButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_gallery.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [galleryButton addTarget:self action:@selector(animateTopMenu) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:galleryButton];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 5, 25, 20);
    [shareButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_share.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(animateTopMenu) forControlEvents:UIControlEventTouchUpInside];
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
