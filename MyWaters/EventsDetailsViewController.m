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
@synthesize descriptionTempString;



//*************** Demo App UI

- (void) createDemoAppControls {
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/events_detail_options.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
}


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
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
        topMenuPos.y = 28;
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
    
    eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgScrollView.bounds.size.width, 100)];
    eventImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/temp_event_image.jpg",appDelegate.RESOURCE_FOLDER_PATH]];
    [bgScrollView addSubview:eventImageView];
    
    directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    directionButton.frame = CGRectMake(0, eventImageView.frame.origin.y+eventImageView.bounds.size.height, bgScrollView.bounds.size.width, 40);
    [directionButton setBackgroundColor:[UIColor whiteColor]];
    [bgScrollView addSubview:directionButton];
    
    directionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
    [directionIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_directions.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [directionButton addSubview:directionIcon];
    
    
    eventTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, directionButton.bounds.size.width-120, 40)];
    eventTitle.backgroundColor = [UIColor whiteColor];
    eventTitle.textAlignment = NSTextAlignmentLeft;
    eventTitle.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    eventTitle.text = @"Geographical Investigation";
    [directionButton addSubview:eventTitle];
    
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(directionButton.bounds.size.width-130, 0, 100, 40)];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    distanceLabel.text = @"1.03 KM";
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
    descriptionLabel.backgroundColor = [UIColor whiteColor];
//    descriptionLabel.text = [NSString stringWithFormat:@"Dummy Description Text. Dummy Description Text. Dummy Description Text.\n\nDummy Description Text. Dummy Description Text. Dummy Description Text\nDummy Description Text. Dummy Description Text. Dummy Description Text. Dummy Description Text. Dummy Description Text\n\nDummy Description Text. Dummy Description Text. Dummy Description Text"];
    descriptionLabel.text = [NSString stringWithFormat:@"\n%@",descriptionTempString];
    descriptionLabel.textColor = [UIColor darkGrayColor];
    descriptionLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    CGSize expectedDescriptionLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"description"]] sizeWithFont:descriptionLabel.font
//                                                                                                              constrainedToSize:descriptionLabel.frame.size
//                                                                                                                  lineBreakMode:NSLineBreakByWordWrapping];
    CGSize expectedDescriptionLabelSize = [[NSString stringWithFormat:@"\n%@",descriptionTempString]
                                                                                                               sizeWithFont:descriptionLabel.font
                                                                                                               constrainedToSize:descriptionLabel.frame.size
                                                                                                                   lineBreakMode:NSLineBreakByWordWrapping];
    
    
    CGRect newDescriptionLabelFrame = descriptionLabel.frame;
    newDescriptionLabelFrame.size.height = expectedDescriptionLabelSize.height;
    descriptionLabel.frame = newDescriptionLabelFrame;
    [bgScrollView addSubview:descriptionLabel];
//    [descriptionLabel sizeToFit];
    
    bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, eventImageView.bounds.size.height+directionButton.bounds.size.height+eventInfoLabel.bounds.size.height+descriptionLabel.bounds.size.height+100);
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
    
    
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-124)];
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    bgScrollView.backgroundColor = [UIColor whiteColor];
    
    
    [self createUI];
    
    callUsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    callUsButton.frame = CGRectMake((self.view.bounds.size.width/2)-17.5, bgScrollView.frame.origin.y+bgScrollView.bounds.size.height+10, 25, 25);
    [callUsButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_call_yellow.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [self.view addSubview:callUsButton];
    
    
    callUsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, callUsButton.frame.origin.y+callUsButton.bounds.size.height+4, self.view.bounds.size.width, 15)];
    callUsLabel.backgroundColor = [UIColor clearColor];
    callUsLabel.textAlignment = NSTextAlignmentCenter;
    callUsLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
    callUsLabel.text = @"Call Us";
    [self.view addSubview:callUsLabel];
    
    
    //Top Menu Item
    
    topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, -60, self.view.bounds.size.width, 55)];
    topMenu.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topMenu];
    
    notifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    notifyButton.frame = CGRectMake((topMenu.bounds.size.width/3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 10, 25, 25);
    [notifyButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_notifyme.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [topMenu addSubview:notifyButton];
    
    favouritesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favouritesButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*2)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 10, 25, 25);
    [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [topMenu addSubview:favouritesButton];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 10, 25, 25);
    [shareButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_share.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [topMenu addSubview:shareButton];
    
    notifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, topMenu.bounds.size.width/3, 10)];
    notifyLabel.backgroundColor = [UIColor clearColor];
    notifyLabel.textAlignment = NSTextAlignmentCenter;
    notifyLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    notifyLabel.text = @"Notify Me";
    [topMenu addSubview:notifyLabel];
    
    addToFavlabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3), 40, topMenu.bounds.size.width/3, 10)];
    addToFavlabel.backgroundColor = [UIColor clearColor];
    addToFavlabel.textAlignment = NSTextAlignmentCenter;
    addToFavlabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    addToFavlabel.text = @"Add To Favourite";
    [topMenu addSubview:addToFavlabel];
    
    shareLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3)*2, 40, topMenu.bounds.size.width/3, 10)];
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    shareLabel.text = @"Share";
    [topMenu addSubview:shareLabel];
}

- (void) viewDidAppear:(BOOL)animated {
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
    swipeGesture.numberOfTouchesRequired = 1;
    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
    
    [self.view addGestureRecognizer:swipeGesture];
    
}


@end
