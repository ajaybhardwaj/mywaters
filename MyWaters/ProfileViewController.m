//
//  ProfileViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ProfileViewController.h"
#import "ViewControllerHelper.h"


@interface ProfileViewController ()

@end

@implementation ProfileViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Demo App Controls Action Handler

- (void) handleDemoControls:(id) sender {
    
    RewardsListingViewController *viewObj = [[RewardsListingViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:NO];
}



//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/profile.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    
    rewardsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rewardsButton.tag = 1;
    rewardsButton.frame = CGRectMake(0, self.view.bounds.size.height-100, self.view.bounds.size.width, 50);
    [rewardsButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rewardsButton];
    
    
    
}



//*************** Method To Refresh My Photos ScrollView

- (void) refreshMyPhotosScrollView {
    
    for (UIView * view in photosScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    int xAxis = 20;
    
    for (int i=0; i<5; i++) {
        
        UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, 5, 70, 70)];
        [badgeImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/dummy_my_pic.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        badgeImageView.tag = i+1;
        [photosScrollView addSubview:badgeImageView];
        
        xAxis = xAxis + 90;
    }
    
    photosScrollView.contentSize = CGSizeMake(xAxis, 80);
}



//*************** Method To Refresh My Badges ScrollView

- (void) refreshBadgesScrollView {
    
    for (UIView * view in badgesScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    int xAxis = 20;
    
    for (int i=0; i<5; i++) {
        
        UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, 5, 55, 55)];
        [badgeImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%d_color.png",appDelegate.RESOURCE_FOLDER_PATH,i+1]]];
        badgeImageView.tag = i+1;
        [badgesScrollView addSubview:badgeImageView];
        
        xAxis = xAxis + 75;
    }
    
    badgesScrollView.contentSize = CGSizeMake(xAxis, 60);
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor = RGB(247, 247, 247);
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = editButton;
    editButton.tintColor = [UIColor whiteColor];
    
    bgContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    bgContentScrollView.showsHorizontalScrollIndicator = NO;
    bgContentScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:bgContentScrollView];
    
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    profileImageView.layer.cornerRadius = 35;
    profileImageView.layer.masksToBounds = YES;
    [profileImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_avatar_image.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [bgContentScrollView addSubview:profileImageView];
    
    
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, self.view.bounds.size.width-120, 70)];
    userNameLabel.text = @"George Tan";
    userNameLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    userNameLabel.textColor = RGB(85,49,118);
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.numberOfLines = 0;
    [bgContentScrollView addSubview:userNameLabel];
    
    
    myBadgesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, profileImageView.frame.origin.y+profileImageView.bounds.size.height+30, 70, 20)];
    myBadgesLabel.text = @"My Badges";
    myBadgesLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    myBadgesLabel.textColor = [UIColor blackColor];
    myBadgesLabel.backgroundColor = [UIColor clearColor];
    myBadgesLabel.numberOfLines = 0;
    [bgContentScrollView addSubview:myBadgesLabel];
    
    
    infoIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    infoIconButton.frame = CGRectMake(myBadgesLabel.frame.origin.x+myBadgesLabel.bounds.size.width+10, profileImageView.frame.origin.y+profileImageView.bounds.size.height+33, 16, 16);
    [infoIconButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_info_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [bgContentScrollView addSubview:infoIconButton];
    
    badgesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, myBadgesLabel.frame.origin.y+myBadgesLabel.bounds.size.height+5, self.view.bounds.size.width, 60)];
    badgesScrollView.showsHorizontalScrollIndicator = NO;
    badgesScrollView.showsVerticalScrollIndicator = NO;
    [bgContentScrollView addSubview:badgesScrollView];
    badgesScrollView.backgroundColor = [UIColor clearColor];
    badgesScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 60);
    
    myPointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, badgesScrollView.frame.origin.y+badgesScrollView.bounds.size.height+30, 120, 20)];
    myPointsLabel.text = @"My Points";
    myPointsLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    myPointsLabel.textColor = [UIColor blackColor];
    myPointsLabel.backgroundColor = [UIColor clearColor];
    myPointsLabel.numberOfLines = 0;
    [bgContentScrollView addSubview:myPointsLabel];
    
    myPointsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, myPointsLabel.frame.origin.y+myPointsLabel.bounds.size.height+5, self.view.bounds.size.width-40, 20)];
    myPointsValueLabel.text = @"150";
    myPointsValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    myPointsValueLabel.textColor = [UIColor darkGrayColor];
    myPointsValueLabel.backgroundColor = [UIColor clearColor];
    myPointsValueLabel.numberOfLines = 0;
    [bgContentScrollView addSubview:myPointsValueLabel];
    
    
    myPhotosLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, myPointsValueLabel.frame.origin.y+myPointsValueLabel.bounds.size.height+30, 120, 20)];
    myPhotosLabel.text = @"My Photos";
    myPhotosLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    myPhotosLabel.textColor = [UIColor blackColor];
    myPhotosLabel.backgroundColor = [UIColor clearColor];
    myPhotosLabel.numberOfLines = 0;
    [bgContentScrollView addSubview:myPhotosLabel];
    
    photosScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, myPhotosLabel.frame.origin.y+myPhotosLabel.bounds.size.height+5, self.view.bounds.size.width, 80)];
    photosScrollView.showsHorizontalScrollIndicator = NO;
    photosScrollView.showsVerticalScrollIndicator = NO;
    [bgContentScrollView addSubview:photosScrollView];
    
    
    joinFriendOfWatersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    joinFriendOfWatersButton.frame = CGRectMake(0, photosScrollView.frame.origin.y+photosScrollView.bounds.size.height+30, self.view.bounds.size.width, 30);
    [joinFriendOfWatersButton setTitleColor:RGB(20, 46, 74) forState:UIControlStateNormal];
    NSMutableAttributedString *buttonTitle = [[NSMutableAttributedString alloc] initWithString:@"JOIN FRIEND OF WATER"];
    [buttonTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [buttonTitle length])];
    [joinFriendOfWatersButton setAttributedTitle:buttonTitle forState:UIControlStateNormal];
    joinFriendOfWatersButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    [bgContentScrollView addSubview:joinFriendOfWatersButton];
    
    
    rewardsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rewardsButton.frame = CGRectMake(0, joinFriendOfWatersButton.frame.origin.y+joinFriendOfWatersButton.bounds.size.height+30, self.view.bounds.size.width, 50);
    rewardsButton.backgroundColor = RGB(85,49,118);
    [rewardsButton setTitle:@"REWARDS" forState:UIControlStateNormal];
    [rewardsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rewardsButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    [rewardsButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [bgContentScrollView addSubview:rewardsButton];

    
    
    bgContentScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 20+profileImageView.bounds.size.height+20+myBadgesLabel.bounds.size.height+10+badgesScrollView.bounds.size.height+10+myPointsLabel.bounds.size.height+10+myPointsValueLabel.bounds.size.height+10+myPhotosLabel.bounds.size.height+10+photosScrollView.bounds.size.height+30+joinFriendOfWatersButton.bounds.size.height+30+rewardsButton.bounds.size.height+100);

    
    float bgContentScrollViewHeight = 20+profileImageView.bounds.size.height+20+myBadgesLabel.bounds.size.height+10+badgesScrollView.bounds.size.height+10+myPointsLabel.bounds.size.height+10+myPointsValueLabel.bounds.size.height+10+myPhotosLabel.bounds.size.height+10+photosScrollView.bounds.size.height+30+joinFriendOfWatersButton.bounds.size.height+30+rewardsButton.bounds.size.height+100;
    
    NSLog(@"%f-----%f",bgContentScrollViewHeight,bgContentScrollView.bounds.size.height);
    
    if (bgContentScrollViewHeight < bgContentScrollView.bounds.size.height) {
        rewardsButton.frame = CGRectMake(0, bgContentScrollView.bounds.size.height-114, self.view.bounds.size.width, 50);
    }
    
    
    //[self createDemoAppControls];
}


- (void) viewWillAppear:(BOOL)animated {
    
    [self refreshBadgesScrollView];
    [self refreshMyPhotosScrollView];
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
