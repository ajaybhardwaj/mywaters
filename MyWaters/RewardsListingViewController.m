//
//  RewardsListingViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "RewardsListingViewController.h"

@implementation RewardsListingViewController


//*************** Demo App Controls Action Handler

- (void) handleDemoControls:(id) sender {
    
    UIButton *button = (id) sender;
    
    if (button.tag==1) {
        RewardDetailsViewController *viewObj = [[RewardDetailsViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:NO];
    }
}



//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/profile_rewards.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    
    rewardsDetailsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rewardsDetailsButton.tag = 1;
    rewardsDetailsButton.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-100);
    [rewardsDetailsButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rewardsDetailsButton];
    
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



# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==rewardsListingTableView) {
        
        RewardDetailsViewController *viewObj = [[RewardDetailsViewController alloc] init];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"ID"] != (id)[NSNull null])
            viewObj.rewardID = [NSString stringWithFormat:@"%d",[[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"ID"] intValue]];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Name"] != (id)[NSNull null])
            viewObj.titleString = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Name"];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Description"] != (id)[NSNull null])
            viewObj.descriptionString = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Description"];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Lat"] != (id)[NSNull null])
            viewObj.latValue = [[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Lat"] doubleValue];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Lon"] != (id)[NSNull null])
            viewObj.longValue = [[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Lon"] doubleValue];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"ValidFrom"] != (id)[NSNull null]) {
            viewObj.validFromDateString = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"ValidFrom"];
            viewObj.validFromDateString = [CommonFunctions dateTimeFromString:viewObj.validFromDateString];
        }
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"ValidTo"] != (id)[NSNull null]) {
            viewObj.validTillDateString = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"ValidTo"];
            viewObj.validTillDateString = [CommonFunctions dateTimeFromString:viewObj.validTillDateString];
        }
        
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"PointsToRedeem"] != (id)[NSNull null])
            viewObj.pointsValueString = [NSString stringWithFormat:@"%d",[[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"PointsToRedeem"] intValue]];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Image"] != (id)[NSNull null]) {
            viewObj.imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Image"]];
            viewObj.imageName = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Image"];
        }
        
        
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return rewardsDataSource.count;
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = RGB(247, 247, 247);
    
    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 70, 70)];
    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/w%ld.png",appDelegate.RESOURCE_FOLDER_PATH,indexPath.row+1]];
    [cell.contentView addSubview:cellImage];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, rewardsListingTableView.bounds.size.width-100, 40)];
    //        titleLabel.text = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"rewardTitle"];
    titleLabel.text = [NSString stringWithFormat:@"Reward %ld",indexPath.row+1];
    titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    [cell.contentView addSubview:titleLabel];
    
    
    UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, rewardsListingTableView.bounds.size.width-100, 13)];
    //        pointsLabel = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"rewardPoints"];
    pointsLabel.text = @"100 Points";
    pointsLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    pointsLabel.backgroundColor = [UIColor clearColor];
    pointsLabel.textColor = [UIColor lightGrayColor];
    pointsLabel.numberOfLines = 0;
    [cell.contentView addSubview:pointsLabel];
    
    UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 65, rewardsListingTableView.bounds.size.width-100, 35)];
    //        placeLabel = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"rewardPlace"];
    placeLabel.text = [NSString stringWithFormat:@"Place %ld",indexPath.row+1];
    placeLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    placeLabel.backgroundColor = [UIColor clearColor];
    placeLabel.textColor = [UIColor lightGrayColor];
    placeLabel.numberOfLines = 0;
    [cell.contentView addSubview:placeLabel];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 99.5, rewardsListingTableView.bounds.size.width, 0.5)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];
    
    return cell;
}




# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Rewards";
    self.view.backgroundColor = RGB(247, 247, 247);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_info_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] style:UIBarButtonItemStylePlain target:self action:nil];
    infoButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = infoButton;
    
    rewardsListingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 25, self.view.bounds.size.width, self.view.bounds.size.height-250)];
    rewardsListingTableView.delegate = self;
    rewardsListingTableView.dataSource = self;
    [self.view addSubview:rewardsListingTableView];
    rewardsListingTableView.backgroundColor = [UIColor clearColor];
    rewardsListingTableView.backgroundView = nil;
    rewardsListingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //[self createDemoAppControls];
    
    
    // Disable iOS 7 back gesture
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        //        __weak id weakSelf = self;
        //        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}


- (void) viewWillAppear:(BOOL)animated {
    
    __weak id weakSelf = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    
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


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isEqual:self.navigationController.interactivePopGestureRecognizer]) {
        
        return NO;
        
    } else {
        
        return YES;
        
    }
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
