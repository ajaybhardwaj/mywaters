//
//  AboutMyWatersViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/3/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "AboutMyWatersViewController.h"

@interface AboutMyWatersViewController ()

@end

@implementation AboutMyWatersViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Create Table Header View

- (void) createTableHeader {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, aboutTableView.bounds.size.width, 380)];
    
//    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, aboutTableView.bounds.size.width-20, 20)];
//    aboutLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:15];
//    aboutLabel.text = @"About MyWaters";
//    aboutLabel.backgroundColor = [UIColor clearColor];
//    [headerView addSubview:aboutLabel];
    
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, aboutTableView.bounds.size.width-20, 380)];
    descriptionLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:13];
    descriptionLabel.text = [NSString stringWithFormat:@"As the national water agency. Public Utilities Board (PUB) is responsible for the collection, production, distribution and reclamation of water in Singapore.\n\nIn just five decades, Singapore has overcome water shortage despite its lack of natural water resources and pollution in its rivers.\n\nDriven by a vision of what it takes to be sustainable in water, Singapore has been investing inresearch and technology. Today, the nation has built a robust, diversified and sustainable water supply from four different sources known as the Four National Taps (water from local catchment areas, imported water, reclaimed water knows as NEWater and desalinated water).\n\nBy integrating the system and maximising the efficiency of each of the four taps. Singapore has ensured a stable, sustainable water supply that is weather resilient, capable of catering to the country's continued growth."];
    descriptionLabel.backgroundColor = [UIColor clearColor];
    descriptionLabel.numberOfLines = 0;
    [headerView addSubview:descriptionLabel];
    
    
    [aboutTableView setTableHeaderView:headerView];
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return tableTitleDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.backgroundColor = RGB(247, 247, 247);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [tableTitleDataSource objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    cell.textLabel.textColor = RGB(35, 35, 35);
    cell.textLabel.numberOfLines = 0;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row==0) {
        cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_web_settings.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if (indexPath.row==1) {
        cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_facebook_settings.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if (indexPath.row==2) {
        cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_twitter_settings.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if (indexPath.row==3) {
        cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_instagram_settings.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    
    
    UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-0.5, aboutTableView.bounds.size.width, 0.5)];
    [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:cellSeperator];
    
    return cell;
}


# pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        BookingWebViewController *viewObj = [[BookingWebViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    self.title = @"About PUB";
//    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];

    tableTitleDataSource = [[NSArray alloc] initWithObjects:@"Website",@"Facebook",@"Twitter",@"Instagram",@"Join Friends of Water", nil];
    
    aboutTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    aboutTableView.delegate = self;
    aboutTableView.dataSource = self;
    [self.view addSubview:aboutTableView];
    aboutTableView.backgroundColor = RGB(247, 247, 247);
    aboutTableView.backgroundView = nil;
    aboutTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self createTableHeader];
}

- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;

}

- (void) viewDidAppear:(BOOL)animated {
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
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
