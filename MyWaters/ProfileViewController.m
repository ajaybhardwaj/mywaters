//
//  ProfileViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ProfileViewController.h"
#import "ViewControllerHelper.h"
#import "RewardDetailsViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController


- (void) handleDemoAction: (id) sender {
    
    UIButton *button = (id) sender;
    
    if (button.tag==1) {
        rewardsDetailButton.hidden = YES;
        [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/profile_badges.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else if (button.tag==2) {
        rewardsDetailButton.hidden = YES;
        [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/profile_points.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else if (button.tag==3) {
        rewardsDetailButton.hidden = NO;
        [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/profile_rewards.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else if (button.tag==4) {
        rewardsDetailButton.hidden = YES;
        [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/profile_photos.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else if (button.tag==5) {
        RewardDetailsViewController *viewObj = [[RewardDetailsViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}


//*************** Method To Move To Edit Profile View

- (void) moveToEditProfile {
    
    EditProfileViewController *viewObj = [[EditProfileViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:YES];
}


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
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



//*************** Method To Handle Tab Button Actions

- (void) handleTabButtons:(id) sender {
    
    UIButton *button = (id) sender;
    
    if (button.tag==1) {
        
        badgesBackgroundView.hidden = NO;
        pointsTableView.hidden = YES;
        rewardsListingTableView.hidden = YES;
        photosBackgroundView.hidden = YES;
        
        badgesButton.userInteractionEnabled = NO;
        pointsButton.userInteractionEnabled = YES;
        rewardsButton.userInteractionEnabled = YES;
        photosButton.userInteractionEnabled = YES;
        
        [badgesButton setBackgroundColor:RGB(83, 83, 83)];
        [badgesIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_award_white.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        badgesLabel.textColor = RGB(255,255,255);
        
        [pointsButton setBackgroundColor:[UIColor clearColor]];
        [pointsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_money_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        pointsLabel.textColor = RGB(83, 83, 83);
        
        [rewardsButton setBackgroundColor:[UIColor clearColor]];
        [rewardsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_gift_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        rewardsLabel.textColor = RGB(83, 83, 83);
        
        [photosButton setBackgroundColor:[UIColor clearColor]];
        [photosIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_poloroid_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        photosLabel.textColor = RGB(83, 83, 83);

    }
    else if (button.tag==2) {
        
        badgesBackgroundView.hidden = YES;
        pointsTableView.hidden = NO;
        rewardsListingTableView.hidden = YES;
        photosBackgroundView.hidden = YES;
        
        badgesButton.userInteractionEnabled = YES;
        pointsButton.userInteractionEnabled = NO;
        rewardsButton.userInteractionEnabled = YES;
        photosButton.userInteractionEnabled = YES;
        
        [badgesButton setBackgroundColor:[UIColor clearColor]];
        [badgesIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_award_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        badgesLabel.textColor = RGB(83, 83, 83);
        
        [pointsButton setBackgroundColor:RGB(83, 83, 83)];
        [pointsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_money_white.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        pointsLabel.textColor = RGB(255,255,255);
        
        [rewardsButton setBackgroundColor:[UIColor clearColor]];
        [rewardsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_gift_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        rewardsLabel.textColor = RGB(83, 83, 83);
        
        [photosButton setBackgroundColor:[UIColor clearColor]];
        [photosIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_poloroid_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        photosLabel.textColor = RGB(83, 83, 83);

    }
    else if (button.tag==3) {
        
        badgesBackgroundView.hidden = YES;
        pointsTableView.hidden = YES;
        rewardsListingTableView.hidden = NO;
        photosBackgroundView.hidden = YES;
        
        badgesButton.userInteractionEnabled = YES;
        pointsButton.userInteractionEnabled = YES;
        rewardsButton.userInteractionEnabled = NO;
        photosButton.userInteractionEnabled = YES;
        
        [badgesButton setBackgroundColor:[UIColor clearColor]];
        [badgesIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_award_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        badgesLabel.textColor = RGB(83, 83, 83);
        
        [pointsButton setBackgroundColor:[UIColor clearColor]];
        [pointsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_money_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        pointsLabel.textColor = RGB(83, 83, 83);
        
        [rewardsButton setBackgroundColor:RGB(83, 83, 83)];
        [rewardsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_gift_white.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        rewardsLabel.textColor = RGB(255,255,255);
        
        [photosButton setBackgroundColor:[UIColor clearColor]];
        [photosIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_poloroid_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        photosLabel.textColor = RGB(83, 83, 83);

    }
    else if (button.tag==4) {
        
        badgesBackgroundView.hidden = YES;
        pointsTableView.hidden = YES;
        rewardsListingTableView.hidden = YES;
        photosBackgroundView.hidden = NO;
        
        badgesButton.userInteractionEnabled = YES;
        pointsButton.userInteractionEnabled = YES;
        rewardsButton.userInteractionEnabled = YES;
        photosButton.userInteractionEnabled = NO;
        
        [badgesButton setBackgroundColor:[UIColor clearColor]];
        [badgesIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_award_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        badgesLabel.textColor = RGB(83, 83, 83);
        
        [pointsButton setBackgroundColor:[UIColor clearColor]];
        [pointsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_money_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        pointsLabel.textColor = RGB(83, 83, 83);
        
        [rewardsButton setBackgroundColor:[UIColor clearColor]];
        [rewardsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_gift_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        rewardsLabel.textColor = RGB(83, 83, 83);
        
        [photosButton setBackgroundColor:RGB(83, 83, 83)];
        [photosIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_poloroid_white.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        photosLabel.textColor = RGB(255,255,255);

    }
}



//*************** Method To Refresh My Photos ScrollView

- (void) refreshMyPhotosScrollView {
    
    for (UIView * view in photosScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    int counter = 0;
    int heightCounter = 1;
    float xAxis = 0;
    float yAxis = 0;
    for (int i=0; i<5; i++) {
        
        DebugLog(@"Counter %d --- %d",counter,i);
        
        if (counter==3) {
            
            
            xAxis = 0;
            yAxis = yAxis + photosScrollView.bounds.size.width/3 + 0.5;
            
            DebugLog(@"If X-Axis %f --- Y-Axis %f",xAxis,yAxis);

            heightCounter = heightCounter + 1;
            counter = 0;
            
            UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, yAxis, photosScrollView.bounds.size.width/3 - 1, photosScrollView.bounds.size.width/3)];
            [badgeImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/dummy_my_pic_new.jpeg",appDelegate.RESOURCE_FOLDER_PATH]]];
            badgeImageView.tag = i+1;
            [photosScrollView addSubview:badgeImageView];

            
        }
        else {
            
            DebugLog(@"Else X-Axis %f --- Y-Axis %f",xAxis,yAxis);
            
            UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, yAxis, photosScrollView.bounds.size.width/3 - 1, photosScrollView.bounds.size.width/3)];
            [badgeImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/dummy_my_pic_new.jpeg",appDelegate.RESOURCE_FOLDER_PATH]]];
            badgeImageView.tag = i+1;
            [photosScrollView addSubview:badgeImageView];
            
            xAxis = xAxis + photosScrollView.bounds.size.width/3 + 0.5;
            counter = counter + 1;
        }
        
    }
    photosScrollView.contentSize = CGSizeMake(photosScrollView.bounds.size.width, (heightCounter*(photosScrollView.bounds.size.width)/3)+40);
}



//*************** Method To Refresh My Badges ScrollView

- (void) refreshBadgesScrollView {
    
    for (UIView * view in badgesScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    int counter = 0;
    int heightCounter = 1;
    float xAxis = 20;
    float yAxis = 5;
    
    for (int i=0; i<6; i++) {
        
        if (counter==3) {
            
            heightCounter = heightCounter + 1;
            counter = 1;
            
            UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, yAxis, (badgesScrollView.bounds.size.width-75)/4, (badgesScrollView.bounds.size.width-75)/4)];
            [badgeImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%d_color.png",appDelegate.RESOURCE_FOLDER_PATH,i+1]]];
            badgeImageView.tag = i+1;
            [badgesScrollView addSubview:badgeImageView];
            
            yAxis = yAxis + (badgesScrollView.bounds.size.width-100)/4;
            xAxis = 20;
        }
        else {
            
            UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, yAxis, (badgesScrollView.bounds.size.width-75)/4, (badgesScrollView.bounds.size.width-75)/4)];
            [badgeImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%d_color.png",appDelegate.RESOURCE_FOLDER_PATH,i+1]]];
            badgeImageView.tag = i+1;
            [badgesScrollView addSubview:badgeImageView];
            
            xAxis = xAxis + (badgesScrollView.bounds.size.width-100)/4 + 20;
            counter = counter + 1;
        }
        
    }
    
    badgesScrollView.contentSize = CGSizeMake(badgesScrollView.bounds.size.width, (heightCounter*(badgesScrollView.bounds.size.width)/4)+40);
}





# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==rewardsListingTableView) {
        return 100.0f;
    }
    else if (tableView==pointsTableView) {
        return 70.0f;
    }
    
    return 0.0f;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==pointsTableView) {
        return 90.0f;
    }
    
    return 0.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView==pointsTableView) {
        
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pointsTableView.bounds.size.width, 90)];
        sectionHeaderView.backgroundColor = RGB(255, 255, 255);
        
        UILabel *pointsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, sectionHeaderView.bounds.size.width, 16)];
        pointsTitleLabel.backgroundColor = [UIColor clearColor];
        pointsTitleLabel.textColor = RGB(58, 58, 58);
        pointsTitleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:13.0];
        pointsTitleLabel.text = @"Current points:";
        pointsTitleLabel.textAlignment = NSTextAlignmentCenter;
        [sectionHeaderView addSubview:pointsTitleLabel];
        
        
        UILabel *pointsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, sectionHeaderView.bounds.size.width, 30)];
        pointsValueLabel.backgroundColor = [UIColor clearColor];
        pointsValueLabel.textColor = RGB(82, 82, 82);
        pointsValueLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:28.0];
        pointsValueLabel.text = @"150";
        pointsValueLabel.textAlignment = NSTextAlignmentCenter;
        [sectionHeaderView addSubview:pointsValueLabel];
        
        return sectionHeaderView;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==rewardsListingTableView) {
        RewardDetailsViewController *viewObj = [[RewardDetailsViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (tableView==pointsTableView) {
        
    }
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    if (tableView==rewardsListingTableView) {
    //        return rewardsDataSource.count;
    //    }
    //    else if (tableView==pointsTableView) {
    //        return pointsDataSource.count;
    //    }
    
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==rewardsListingTableView) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rewardsCell"];
        cell.backgroundColor = RGB(247, 247, 247);
        
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 70, 70)];
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/w%ld.png",appDelegate.RESOURCE_FOLDER_PATH,indexPath.row+1]];
        [cell.contentView addSubview:cellImage];
        
        
        UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, rewardsListingTableView.bounds.size.width-100, 40)];
        //        titleLabel.text = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"rewardTitle"];
        cellTitleLabel.text = [NSString stringWithFormat:@"Reward %ld",indexPath.row+1];
        cellTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        cellTitleLabel.backgroundColor = [UIColor clearColor];
        cellTitleLabel.numberOfLines = 0;
        [cell.contentView addSubview:cellTitleLabel];
        
        
        UILabel *cellPointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, rewardsListingTableView.bounds.size.width-100, 13)];
        //        pointsLabel = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"rewardPoints"];
        cellPointsLabel.text = @"100 Points";
        cellPointsLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
        cellPointsLabel.backgroundColor = [UIColor clearColor];
        cellPointsLabel.textColor = [UIColor lightGrayColor];
        cellPointsLabel.numberOfLines = 0;
        [cell.contentView addSubview:cellPointsLabel];
        
        UILabel *cellPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 65, rewardsListingTableView.bounds.size.width-100, 35)];
        //        placeLabel = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"rewardPlace"];
        cellPlaceLabel.text = [NSString stringWithFormat:@"Place %ld",indexPath.row+1];
        cellPlaceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
        cellPlaceLabel.backgroundColor = [UIColor clearColor];
        cellPlaceLabel.textColor = [UIColor lightGrayColor];
        cellPlaceLabel.numberOfLines = 0;
        [cell.contentView addSubview:cellPlaceLabel];
        
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 99.5, rewardsListingTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        return cell;
    }
    else if (tableView==pointsTableView) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rewardsCell"];
        cell.backgroundColor = RGB(247, 247, 247);
        

        UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, pointsTableView.bounds.size.width-20, 45)];
        //        titleLabel.text = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"rewardTitle"];
        cellTitleLabel.text = [NSString stringWithFormat:@"%@",[pointsDataSource objectAtIndex:(indexPath.row*2)]];
        cellTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        cellTitleLabel.backgroundColor = [UIColor clearColor];
        cellTitleLabel.numberOfLines = 0;
        [cellTitleLabel sizeToFit];
        [cell.contentView addSubview:cellTitleLabel];
        
        
        UILabel *cellTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, pointsTableView.bounds.size.width-20, 15)];
        //        pointsLabel = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"rewardPoints"];
        cellTimeLabel.text = [NSString stringWithFormat:@"%@",[pointsDataSource objectAtIndex:(indexPath.row*2)+1]];
        cellTimeLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11.0];
        cellTimeLabel.backgroundColor = [UIColor clearColor];
        cellTimeLabel.textColor = [UIColor lightGrayColor];
        cellTimeLabel.numberOfLines = 0;
        cellTimeLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:cellTimeLabel];
        
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69.5, rewardsListingTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        return cell;
    }
    
    return nil;
}




# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor = RGB(247, 247, 247);
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(moveToEditProfile)];
    self.navigationItem.rightBarButtonItem = editButton;
    editButton.tintColor = [UIColor whiteColor];
    
    //    bgContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    //    bgContentScrollView.showsHorizontalScrollIndicator = NO;
    //    bgContentScrollView.showsVerticalScrollIndicator = NO;
    //    [self.view addSubview:bgContentScrollView];
    //
    //    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 80, 80)];
    //    profileImageView.layer.cornerRadius = 35;
    //    profileImageView.layer.masksToBounds = YES;
    //    [profileImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_avatar_image.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    //    [bgContentScrollView addSubview:profileImageView];
    //
    //
    //    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, self.view.bounds.size.width-120, 70)];
    //    userNameLabel.text = @"George Tan";
    //    userNameLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    //    userNameLabel.textColor = RGB(85,49,118);
    //    userNameLabel.backgroundColor = [UIColor clearColor];
    //    userNameLabel.numberOfLines = 0;
    //    [bgContentScrollView addSubview:userNameLabel];
    //
    //
    //    myBadgesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, profileImageView.frame.origin.y+profileImageView.bounds.size.height+30, 70, 20)];
    //    myBadgesLabel.text = @"My Badges";
    //    myBadgesLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    //    myBadgesLabel.textColor = [UIColor blackColor];
    //    myBadgesLabel.backgroundColor = [UIColor clearColor];
    //    myBadgesLabel.numberOfLines = 0;
    //    [bgContentScrollView addSubview:myBadgesLabel];
    //
    //
    //    infoIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    infoIconButton.frame = CGRectMake(myBadgesLabel.frame.origin.x+myBadgesLabel.bounds.size.width+10, profileImageView.frame.origin.y+profileImageView.bounds.size.height+33, 16, 16);
    //    [infoIconButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_info_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    //    [bgContentScrollView addSubview:infoIconButton];
    //
    //    badgesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, myBadgesLabel.frame.origin.y+myBadgesLabel.bounds.size.height+5, self.view.bounds.size.width, 100)];
    //    badgesScrollView.showsHorizontalScrollIndicator = NO;
    //    badgesScrollView.showsVerticalScrollIndicator = NO;
    //    [bgContentScrollView addSubview:badgesScrollView];
    //    badgesScrollView.backgroundColor = [UIColor clearColor];
    //    badgesScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 100);
    //
    //    myPointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, badgesScrollView.frame.origin.y+badgesScrollView.bounds.size.height+30, 120, 20)];
    //    myPointsLabel.text = @"My Points";
    //    myPointsLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    //    myPointsLabel.textColor = [UIColor blackColor];
    //    myPointsLabel.backgroundColor = [UIColor clearColor];
    //    myPointsLabel.numberOfLines = 0;
    //    [bgContentScrollView addSubview:myPointsLabel];
    //
    //    myPointsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, myPointsLabel.frame.origin.y+myPointsLabel.bounds.size.height+5, self.view.bounds.size.width-40, 20)];
    //    myPointsValueLabel.text = @"150";
    //    myPointsValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    //    myPointsValueLabel.textColor = [UIColor darkGrayColor];
    //    myPointsValueLabel.backgroundColor = [UIColor clearColor];
    //    myPointsValueLabel.numberOfLines = 0;
    //    [bgContentScrollView addSubview:myPointsValueLabel];
    //
    //
    //    myPhotosLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, myPointsValueLabel.frame.origin.y+myPointsValueLabel.bounds.size.height+30, 120, 20)];
    //    myPhotosLabel.text = @"My Photos";
    //    myPhotosLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    //    myPhotosLabel.textColor = [UIColor blackColor];
    //    myPhotosLabel.backgroundColor = [UIColor clearColor];
    //    myPhotosLabel.numberOfLines = 0;
    //    [bgContentScrollView addSubview:myPhotosLabel];
    //
    //    photosScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, myPhotosLabel.frame.origin.y+myPhotosLabel.bounds.size.height+5, self.view.bounds.size.width, 80)];
    //    photosScrollView.showsHorizontalScrollIndicator = NO;
    //    photosScrollView.showsVerticalScrollIndicator = NO;
    //    [bgContentScrollView addSubview:photosScrollView];
    //
    //
    ////    joinFriendOfWatersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ////    joinFriendOfWatersButton.frame = CGRectMake(0, photosScrollView.frame.origin.y+photosScrollView.bounds.size.height+30, self.view.bounds.size.width, 30);
    ////    [joinFriendOfWatersButton sxetTitleColor:RGB(20, 46, 74) forState:UIControlStateNormal];
    ////    NSMutableAttributedString *buttonTitle = [[NSMutableAttributedString alloc] initWithString:@"JOIN FRIEND OF WATER"];
    ////    [buttonTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [buttonTitle length])];
    ////    [joinFriendOfWatersButton setAttributedTitle:buttonTitle forState:UIControlStateNormal];
    ////    joinFriendOfWatersButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    ////    [bgContentScrollView addSubview:joinFriendOfWatersButton];
    //
    //
    //    rewardsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    rewardsButton.frame = CGRectMake(0, photosScrollView.frame.origin.y+photosScrollView.bounds.size.height+30, self.view.bounds.size.width, 50);
    //    rewardsButton.backgroundColor = RGB(85,49,118);
    //    [rewardsButton setTitle:@"REWARDS" forState:UIControlStateNormal];
    //    [rewardsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    rewardsButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    //    [rewardsButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    //    [bgContentScrollView addSubview:rewardsButton];
    //
    //
    //
    //    bgContentScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 20+profileImageView.bounds.size.height+20+myBadgesLabel.bounds.size.height+10+badgesScrollView.bounds.size.height+10+myPointsLabel.bounds.size.height+10+myPointsValueLabel.bounds.size.height+10+myPhotosLabel.bounds.size.height+10+photosScrollView.bounds.size.height+30+joinFriendOfWatersButton.bounds.size.height+30+rewardsButton.bounds.size.height+100);
    //
    //
    //    float bgContentScrollViewHeight = 20+profileImageView.bounds.size.height+20+myBadgesLabel.bounds.size.height+10+badgesScrollView.bounds.size.height+10+myPointsLabel.bounds.size.height+10+myPointsValueLabel.bounds.size.height+10+myPhotosLabel.bounds.size.height+10+photosScrollView.bounds.size.height+30+joinFriendOfWatersButton.bounds.size.height+30+rewardsButton.bounds.size.height+100;
    //
    //    DebugLog(@"%f-----%f",bgContentScrollViewHeight,bgContentScrollView.bounds.size.height);
    //
    //    if (bgContentScrollViewHeight < bgContentScrollView.bounds.size.height) {
    //        rewardsButton.frame = CGRectMake(0, bgContentScrollView.bounds.size.height-114, self.view.bounds.size.width, 50);
    //    }
    
    
    
    
    //----- Temp Dummy Image For Prototype
    //    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    //    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/profile_badges.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    //    [self.view addSubview:bgImageView];
    //    bgImageView.userInteractionEnabled = YES;
    //
    //
    //    UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    profileButton.tag = 1;
    //    profileButton.frame = CGRectMake(0, self.view.bounds.size.height-114, self.view.bounds.size.width/4, 50);
    //    [profileButton addTarget:self action:@selector(handleDemoAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:profileButton];
    //
    //    UIButton *pointsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    pointsButton.tag = 2;
    //    pointsButton.frame = CGRectMake(self.view.bounds.size.width/4, self.view.bounds.size.height-114, self.view.bounds.size.width/4, 50);
    //    [pointsButton addTarget:self action:@selector(handleDemoAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:pointsButton];
    //
    //    UIButton *rewardsLocalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rewardsLocalButton.tag = 3;
    //    rewardsLocalButton.frame = CGRectMake((self.view.bounds.size.width/4)*2 , self.view.bounds.size.height-114, self.view.bounds.size.width/4, 50);
    //    [rewardsLocalButton addTarget:self action:@selector(handleDemoAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:rewardsLocalButton];
    //
    //    UIButton *photosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    photosButton.tag = 4;
    //    photosButton.frame = CGRectMake((self.view.bounds.size.width/4)*3, self.view.bounds.size.height-114, self.view.bounds.size.width/4, 50);
    //    [photosButton addTarget:self action:@selector(handleDemoAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:photosButton];
    //
    //
    //
    //    rewardsDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rewardsDetailButton.tag = 5;
    //    rewardsDetailButton.frame = CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-214);
    //    [rewardsDetailButton addTarget:self action:@selector(handleDemoAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:rewardsDetailButton];
    //    rewardsDetailButton.hidden = YES;
    
    //    tabBarController = [[UITabBarController alloc] init];
    //
    //    BadgesViewController *badges = [[BadgesViewController alloc] init];
    //    badges.title=@"Badges";
    //    badges.tabBarItem.image = [UIImage imageNamed:@"icn_award_purple.png"];
    //    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:badges];
    //    nav1.navigationBar.tintColor = [UIColor colorWithRed:240.0/256.0 green:240.0/256.0 blue:240.0/256.0 alpha:1.0];
    //    nav1.navigationBar.hidden = YES;
    //
    //    PointsViewController *points = [[PointsViewController alloc] init];
    //    points.title=@"Points";
    //    points.tabBarItem.image = [UIImage imageNamed:@"icn_money_purple.png"];
    //    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:points];
    //    nav2.navigationBar.tintColor = [UIColor colorWithRed:240.0/256.0 green:240.0/256.0 blue:240.0/256.0 alpha:1.0];
    //    nav2.navigationBar.hidden = YES;
    //
    //    RewardsListingViewController *rewards = [[RewardsListingViewController alloc] init];
    //    rewards.title=@"Rewards";
    //    rewards.tabBarItem.image = [UIImage imageNamed:@"icn_gift_purple.png"];
    //    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:rewards];
    //    nav3.navigationBar.tintColor = [UIColor colorWithRed:240.0/256.0 green:240.0/256.0 blue:240.0/256.0 alpha:1.0];
    //    nav3.navigationBar.hidden = YES;
    //
    //    PhotosViewController *photos = [[PhotosViewController alloc] init];
    //    photos.title=@"Photos";
    //    photos.tabBarItem.image = [UIImage imageNamed:@"icn_poloroid_purple.png"];
    //    UINavigationController *nav4=[[UINavigationController alloc]initWithRootViewController:photos];
    //    nav4.navigationBar.tintColor = [UIColor colorWithRed:240.0/256.0 green:240.0/256.0 blue:240.0/256.0 alpha:1.0];
    //    nav4.navigationBar.hidden = YES;
    //
    //    [tabBarController setViewControllers:[NSArray arrayWithObjects:nav1,nav2,nav3,nav4,nil]];	//set all navigationControllers to tabbarcontroller
    //    tabBarController.view.frame = CGRectMake(0, 110, self.view.bounds.size.width, self.view.bounds.size.height-110);
    //    [self.view addSubview:tabBarController.view];
    //
    //
    //    UITabBar *tabBar = [tabBarController tabBar];
    //    if ([tabBar respondsToSelector:@selector(setBackgroundImage:)])
    //    {
    //        // ios 5 code here
    //        [tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];
    //
    //    }
    
    
    
    //===== Top Profile View
    UIImageView *profileBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120)];
    [profileBg setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/profile_image_background.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:profileBg];
    
    
    UIImageView *profileImageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(18, 9, 104, 104)];
    profileImageViewBg.layer.cornerRadius = 52;
    profileImageViewBg.layer.masksToBounds = YES;
    [profileImageViewBg setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/circle_background.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:profileImageViewBg];
    
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 100, 100)];
    profileImageView.layer.cornerRadius = 50;
    profileImageView.layer.masksToBounds = YES;
    [profileImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_avatar_image.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:profileImageView];
    
    
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, self.view.bounds.size.width-150, 70)];
    userNameLabel.text = @"George Tan";
    userNameLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:16];
    userNameLabel.textColor = RGB(85,49,118);
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.numberOfLines = 0;
    [self.view addSubview:userNameLabel];
    
    
    
    //===== For Tabs UI
    
    tabsBackground = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-114, self.view.bounds.size.width, 50)];
    [tabsBackground setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/tabbar_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]]];
    [self.view addSubview:tabsBackground];
    tabsBackground.userInteractionEnabled = YES;
    
    badgesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    badgesButton.frame = CGRectMake(0, 0, tabsBackground.bounds.size.width/4, 50);
    [badgesButton setBackgroundColor:RGB(83, 83, 83)];
    badgesButton.tag = 1;
    [badgesButton addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [tabsBackground addSubview:badgesButton];
    
    badgesIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    badgesIcon.frame = CGRectMake(badgesButton.bounds.size.width/2 - 15, 5, 30, 30);
    badgesIcon.tag = 1;
    [badgesIcon addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [badgesIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_award_white.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [badgesButton addSubview:badgesIcon];
    
    badgesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, badgesButton.bounds.size.width, 15)];
    badgesLabel.text = @"Badges";
    badgesLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11];
    badgesLabel.textColor = RGB(255,255,255);
    badgesLabel.backgroundColor = [UIColor clearColor];
    badgesLabel.numberOfLines = 0;
    badgesLabel.textAlignment = NSTextAlignmentCenter;
    [badgesButton addSubview:badgesLabel];
    
    pointsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pointsButton.frame = CGRectMake(tabsBackground.bounds.size.width/4, 0, tabsBackground.bounds.size.width/4, 50);
    pointsButton.tag = 2;
    [pointsButton addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [pointsButton setBackgroundColor:[UIColor clearColor]];
    [tabsBackground addSubview:pointsButton];
    
    pointsIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    pointsIcon.frame = CGRectMake(pointsButton.bounds.size.width/2 - 15, 5, 30, 30);
    pointsIcon.tag = 2;
    [pointsIcon addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [pointsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_money_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [pointsButton addSubview:pointsIcon];
    
    pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, pointsButton.bounds.size.width, 15)];
    pointsLabel.text = @"Points";
    pointsLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11];
    pointsLabel.textColor = RGB(83,83,83);
    pointsLabel.backgroundColor = [UIColor clearColor];
    pointsLabel.numberOfLines = 0;
    pointsLabel.textAlignment = NSTextAlignmentCenter;
    [pointsButton addSubview:pointsLabel];
    
    rewardsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rewardsButton.frame = CGRectMake((tabsBackground.bounds.size.width/4)*2, 0, tabsBackground.bounds.size.width/4, 50);
    rewardsButton.tag = 3;
    [rewardsButton addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [rewardsButton setBackgroundColor:[UIColor clearColor]];
    [tabsBackground addSubview:rewardsButton];
    
    rewardsIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    rewardsIcon.frame = CGRectMake(rewardsButton.bounds.size.width/2 - 15, 5, 30, 30);
    rewardsIcon.tag = 3;
    [rewardsIcon addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [rewardsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_gift_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [rewardsButton addSubview:rewardsIcon];
    
    rewardsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, rewardsButton.bounds.size.width, 15)];
    rewardsLabel.text = @"Rewards";
    rewardsLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11];
    rewardsLabel.textColor = RGB(83,83,83);
    rewardsLabel.backgroundColor = [UIColor clearColor];
    rewardsLabel.numberOfLines = 0;
    rewardsLabel.textAlignment = NSTextAlignmentCenter;
    [rewardsButton addSubview:rewardsLabel];
    
    photosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photosButton.frame = CGRectMake((tabsBackground.bounds.size.width/4)*3, 0, tabsBackground.bounds.size.width/4, 50);
    photosButton.tag = 4;
    [photosButton addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [photosButton setBackgroundColor:[UIColor clearColor]];
    [tabsBackground addSubview:photosButton];
    
    photosIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    photosIcon.frame = CGRectMake(photosButton.bounds.size.width/2 - 15, 5, 30, 30);
    [photosIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_poloroid_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    photosIcon.tag = 4;
    [photosIcon addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [photosButton addSubview:photosIcon];
    
    photosLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, photosButton.bounds.size.width, 15)];
    photosLabel.text = @"Photos";
    photosLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11];
    photosLabel.textColor = RGB(83,83,83);
    photosLabel.backgroundColor = [UIColor clearColor];
    photosLabel.numberOfLines = 0;
    photosLabel.textAlignment = NSTextAlignmentCenter;
    [photosButton addSubview:photosLabel];
    
    
    
    //===== For Badges SubViews
    
    badgesBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, profileImageViewBg.frame.origin.y+profileImageViewBg.bounds.size.height+5, self.view.bounds.size.width, self.view.bounds.size.height-(132+profileImageViewBg.bounds.size.height))];
    [badgesBackgroundView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:badgesBackgroundView];
    badgesBackgroundView.userInteractionEnabled = YES;
    
    myBadgesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 115, 20)];
    myBadgesLabel.text = @"What are badges?";
    myBadgesLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.5];
    myBadgesLabel.textColor = [UIColor blackColor];
    myBadgesLabel.backgroundColor = [UIColor clearColor];
    myBadgesLabel.numberOfLines = 0;
    [badgesBackgroundView addSubview:myBadgesLabel];
    
    infoIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    infoIconButton.frame = CGRectMake(myBadgesLabel.frame.origin.x+myBadgesLabel.bounds.size.width, 13, 16, 16);
    [infoIconButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_info_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [badgesBackgroundView addSubview:infoIconButton];
    
    badgesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, infoIconButton.frame.origin.y+infoIconButton.bounds.size.height+5, badgesBackgroundView.bounds.size.width, badgesBackgroundView.bounds.size.height)];
    badgesScrollView.showsHorizontalScrollIndicator = NO;
    badgesScrollView.showsVerticalScrollIndicator = NO;
    [badgesBackgroundView addSubview:badgesScrollView];
    badgesScrollView.backgroundColor = [UIColor clearColor];
    badgesScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 100);
    
    [self refreshBadgesScrollView];
    
    
    
    //===== For Rewards SubViews
    
    rewardsListingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, profileImageViewBg.frame.origin.y+profileImageViewBg.bounds.size.height+8, self.view.bounds.size.width, self.view.bounds.size.height-(132+profileImageViewBg.bounds.size.height))];
    rewardsListingTableView.delegate = self;
    rewardsListingTableView.dataSource = self;
    [self.view addSubview:rewardsListingTableView];
    rewardsListingTableView.backgroundColor = [UIColor clearColor];
    rewardsListingTableView.backgroundView = nil;
    rewardsListingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rewardsListingTableView.hidden = YES;
    
    
    
    //===== For Points SubViews
    
    pointsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, profileImageViewBg.frame.origin.y+profileImageViewBg.bounds.size.height+8, self.view.bounds.size.width, self.view.bounds.size.height-(132+profileImageViewBg.bounds.size.height))];
    pointsTableView.delegate = self;
    pointsTableView.dataSource = self;
    [self.view addSubview:pointsTableView];
    pointsTableView.backgroundColor = [UIColor clearColor];
    pointsTableView.backgroundView = nil;
    pointsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    pointsTableView.hidden = YES;
    
    // Temp Data
    pointsDataSource = [[NSArray alloc] initWithObjects:@"You were awarded 5 points for sharing an event on facebook!",@"08 Aug 2015 at 02:10 PM",@"You redeemed an ice cream cone worth 30 points.",@"10 Aug 2015 at 11:00 AM",@"You unlocked a badge!",@"11 Aug 2015 at 04:00 PM",@"You were awarded 2 points for booking a facility!",@"12 Aug 2015 at 09:00 AM", nil];
    
    
    //===== For Badges SubViews
    
    photosBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, profileImageViewBg.frame.origin.y+profileImageViewBg.bounds.size.height+5, self.view.bounds.size.width, self.view.bounds.size.height-(132+profileImageViewBg.bounds.size.height))];
    [photosBackgroundView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:photosBackgroundView];
    photosBackgroundView.userInteractionEnabled = YES;

    
    photosScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, photosBackgroundView.bounds.size.width, photosBackgroundView.bounds.size.height)];
    photosScrollView.showsHorizontalScrollIndicator = NO;
    photosScrollView.showsVerticalScrollIndicator = NO;
    [photosBackgroundView addSubview:photosScrollView];
    photosScrollView.backgroundColor = [UIColor clearColor];
    photosScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 100);
    photosBackgroundView.hidden = YES;
    
    [self refreshMyPhotosScrollView];
    
}


//- (void) viewDidAppear:(BOOL)animated {
//
//
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
//    swipeGesture.numberOfTouchesRequired = 1;
//    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
//
//    [self.view addGestureRecognizer:swipeGesture];
//
//}

- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
//    self.hidesBottomBarWhenPushed = NO;
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
