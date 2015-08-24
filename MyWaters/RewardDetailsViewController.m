//
//  RewardDetailsViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "RewardDetailsViewController.h"

@implementation RewardDetailsViewController


//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/profile_rewards_detail.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
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



//*************** Method To Create Detail Page UI

- (void) createUI {
    
    float h2 = 0;
    
    if ([dataDict objectForKey:@"image_size"] !=(id)[NSNull null]) {
        NSArray *tempArray = [[dataDict objectForKey:@"image_size"] componentsSeparatedByString: @","];
        
        float w1 = [[tempArray objectAtIndex:0] floatValue];
        float h1 = [[tempArray objectAtIndex:1] floatValue];
        h2 = (h1*self.view.bounds.size.width)/w1;
    }
    
    rewardImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgScrollView.bounds.size.width, 184)];
    [rewardImageView setImage:[UIImage imageNamed:@"reward_temp_image.png"]];
    [bgScrollView addSubview:rewardImageView];
    
//    directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    directionButton.frame = CGRectMake(0, rewardImageView.frame.origin.y+rewardImageView.bounds.size.height, bgScrollView.bounds.size.width, 40);
//    [directionButton setBackgroundColor:[UIColor whiteColor]];
//    [bgScrollView addSubview:directionButton];
//    
//    directionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
//    [directionIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_directions_purple.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//    [directionButton addSubview:directionIcon];
//    
//    
//    rewardTitle = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, directionButton.bounds.size.width-120, 40)];
//    rewardTitle.backgroundColor = [UIColor whiteColor];
//    rewardTitle.textAlignment = NSTextAlignmentLeft;
//    rewardTitle.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
//    rewardTitle.text = @"25% off Tree Top Course";
//    [directionButton addSubview:rewardTitle];
//    
//    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(directionButton.bounds.size.width-130, 0, 100, 40)];
//    distanceLabel.backgroundColor = [UIColor clearColor];
//    distanceLabel.textAlignment = NSTextAlignmentRight;
//    distanceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
//    distanceLabel.text = @"1.03 KM";
//    [directionButton addSubview:distanceLabel];
//    
//    arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(directionButton.bounds.size.width-20, 12.5, 15, 15)];
//    [arrowIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_arrow_grey.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//    [directionButton addSubview:arrowIcon];
    
    
    
//    rewardInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, directionButton.frame.origin.y+directionButton.bounds.size.height+5, self.view.bounds.size.width, 40)];
    rewardInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, rewardImageView.frame.origin.y+rewardImageView.bounds.size.height, self.view.bounds.size.width, 40)];
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
    descriptionLabel.backgroundColor = [UIColor whiteColor];
//    descriptionLabel.text = [NSString stringWithFormat:@"Dummy Description Text. Dummy Description Text. Dummy Description Text.\n\nDummy Description Text. Dummy Description Text. Dummy Description Text\nDummy Description Text. Dummy Description Text. Dummy Description Text. Dummy Description Text. Dummy Description Text\n\nDummy Description Text. Dummy Description Text. Dummy Description Text"];
    descriptionLabel.text = [NSString stringWithFormat:@"Forest adventure, first and ony tree top adventure course in Singapore. 58 obstacles, 5 giants zip lines. Simply a great day out at Bedok Reservoir Park.\n\nValid From\n3May 15 -31 Dec 15\n\nLocation\nBedok Reservoir\n\nPoints: 50\n50"];
    descriptionLabel.textColor = [UIColor darkGrayColor];
    descriptionLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    CGSize expectedDescriptionLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"description"]] sizeWithFont:descriptionLabel.font
    //                                                                                                              constrainedToSize:descriptionLabel.frame.size
    //                                                                                                                  lineBreakMode:NSLineBreakByWordWrapping];
    CGSize expectedDescriptionLabelSize = [[NSString stringWithFormat:@"Forest adventure, first and ony tree top adventure course in Singapore. 58 obstacles, 5 giants zip lines. Simply a great day out at Bedok Reservoir Park.\n\nValid From\n3May 15 -31 Dec 15\n\nLocation\nBedok Reservoir\n\nPoints - 50"]
                                           sizeWithFont:descriptionLabel.font
                                           constrainedToSize:descriptionLabel.frame.size
                                           lineBreakMode:NSLineBreakByWordWrapping];
    
    
    
    CGRect newDescriptionLabelFrame = descriptionLabel.frame;
    newDescriptionLabelFrame.size.height = expectedDescriptionLabelSize.height+100;
    descriptionLabel.frame = newDescriptionLabelFrame;
    [bgScrollView addSubview:descriptionLabel];
    [descriptionLabel sizeToFit];
    
    bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, rewardImageView.bounds.size.height+directionButton.bounds.size.height+rewardInfoLabel.bounds.size.height+descriptionLabel.bounds.size.height+100);
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
    [redeemNowButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:redeemNowButton];
    
    //[self createDemoAppControls];
}


- (void) viewDidAppear:(BOOL)animated {
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipeGesture.numberOfTouchesRequired = 1;
    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
    
    [self.view addGestureRecognizer:swipeGesture];
    
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
