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
    RewardDetailsViewController *viewObj = [[RewardDetailsViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:NO];
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    return rewardsDataSource.count;
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = RGB(247, 247, 247);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 5, cell.bounds.size.width-100, 40)];
    //        titleLabel.text = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"rewardTitle"];
    titleLabel.text = [NSString stringWithFormat:@"Reward %ld",indexPath.row+1];
    titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    [cell.contentView addSubview:titleLabel];
    
    
    UILabel *pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 50, cell.bounds.size.width-100, 13)];
    //        pointsLabel = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"rewardPoints"];
    pointsLabel.text = @"100 Points";
    pointsLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    pointsLabel.backgroundColor = [UIColor clearColor];
    pointsLabel.textColor = [UIColor lightGrayColor];
    pointsLabel.numberOfLines = 0;
    [cell.contentView addSubview:pointsLabel];
    
    UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 65, cell.bounds.size.width-100, 35)];
    //        placeLabel = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"rewardPlace"];
    placeLabel.text = [NSString stringWithFormat:@"Place %ld",indexPath.row+1];
    placeLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    placeLabel.backgroundColor = [UIColor clearColor];
    placeLabel.textColor = [UIColor lightGrayColor];
    placeLabel.numberOfLines = 0;
    [cell.contentView addSubview:placeLabel];
    
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 99.5, cell.bounds.size.width, 0.5)];
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
    
    rewardsListingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    rewardsListingTableView.delegate = self;
    rewardsListingTableView.dataSource = self;
    [self.view addSubview:rewardsListingTableView];
    rewardsListingTableView.backgroundColor = [UIColor clearColor];
    rewardsListingTableView.backgroundView = nil;
    rewardsListingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //[self createDemoAppControls];
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
