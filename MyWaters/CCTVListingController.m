//
//  CCTVListingController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 27/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "CCTVListingController.h"

@implementation CCTVListingController



//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
    [searchField resignFirstResponder];
}


//*************** Method To ANimate Filter Table

- (void) animateFilterTable {
    
    [UIView beginAnimations:@"filterTable" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = filterTableView.center;
    
    if (isShowingFilter) {
        isShowingFilter = NO;
        pos.y = -120;
        
        cctvListingTable.alpha = 1.0;
        cctvListingTable.userInteractionEnabled = YES;
        
    }
    else {
        isShowingFilter = YES;
        pos.y = 128;
        
        if (isShowingSearchBar) {
            [self animateSearchBar];
        }
        
        cctvListingTable.alpha = 0.5;
        cctvListingTable.userInteractionEnabled = NO;
    }
    filterTableView.center = pos;
    [UIView commitAnimations];
    
}


//*************** Method To Animate Search Bar

- (void) animateSearchBar {
    
    [UIView beginAnimations:@"searchbar" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = searchField.center;
    
    if (isShowingSearchBar) {
        isShowingSearchBar = NO;
        pos.y = -70;
        
        cctvListingTable.alpha = 1.0;
        cctvListingTable.userInteractionEnabled = YES;
        
        [searchField resignFirstResponder];
    }
    else {
        isShowingSearchBar = YES;
        pos.y = 20;
        
        if (isShowingFilter) {
            [self animateFilterTable];
        }
        
        cctvListingTable.alpha = 0.5;
        cctvListingTable.userInteractionEnabled = NO;
        
        [searchField becomeFirstResponder];
    }
    searchField.center = pos;
    [UIView commitAnimations];
}


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==filterTableView) {
        return 40.0f;
    }
    else if (tableView==cctvListingTable) {
        return 80.0f;
    }
    
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==filterTableView) {
        
        selectedFilterIndex = indexPath.row;
        [filterTableView reloadData];
        [self animateFilterTable];
    }
    
    else if (tableView==cctvListingTable) {
        CCTVDetailViewController *viewObj = [[CCTVDetailViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}


# pragma mark - UITableViewDataSource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==cctvListingTable) {
        return cctvDataSource.count;
    }
    else if (tableView==filterTableView) {
        return filtersArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = RGB(247, 247, 247);
    
    if (tableView==filterTableView) {
        
        cell.backgroundColor = [UIColor blackColor];//RGB(247, 247, 247);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, filterTableView.bounds.size.width-10, cell.bounds.size.height)];
        titleLabel.text = [filtersArray objectAtIndex:indexPath.row];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39.5, filterTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        if (indexPath.row==selectedFilterIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    else {
    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 70, 70)];
    //    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/w%ld.png",appDelegate.RESOURCE_FOLDER_PATH,indexPath.row+1]];
    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/CCTV-2.png",appDelegate.RESOURCE_FOLDER_PATH]];
    [cell.contentView addSubview:cellImage];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, cctvListingTable.bounds.size.width-100, 60)];
//    titleLabel.text = [[cctvDataSource objectAtIndex:indexPath.row] objectForKey:@"eventTitle"];
    titleLabel.text = [cctvDataSource objectAtIndex:indexPath.row];
    titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    [cell.contentView addSubview:titleLabel];
    
    
//    UILabel *cellDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, cctvListingTable.bounds.size.width-100, 20)];
//    cellDistanceLabel.text = @"10 KM";
//    cellDistanceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
//    cellDistanceLabel.backgroundColor = [UIColor clearColor];
//    cellDistanceLabel.textColor = [UIColor lightGrayColor];
//    cellDistanceLabel.numberOfLines = 0;
//    cellDistanceLabel.textAlignment = NSTextAlignmentLeft;
//    [cell.contentView addSubview:cellDistanceLabel];
    
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79.5, cctvListingTable.bounds.size.width, 0.5)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];
    }
    
    return cell;
}



# pragma mark - View Lifecycle Methods

- (void) viewDidLoad {
    
    self.title = @"CCTV";
    self.view.backgroundColor = RGB(247, 247, 247);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    
    
    UIButton *btnfilter =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnfilter setImage:[UIImage imageNamed:@"icn_filter"] forState:UIControlStateNormal];
    [btnfilter addTarget:self action:@selector(animateFilterTable) forControlEvents:UIControlEventTouchUpInside];
    [btnfilter setFrame:CGRectMake(0, 0, 32, 32)];
    
    UIButton *btnSearch =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch setImage:[UIImage imageNamed:@"icn_search"] forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(animateSearchBar) forControlEvents:UIControlEventTouchUpInside];
    [btnSearch setFrame:CGRectMake(36, 0, 32, 32)];
    
    UIButton *btnLocation =  [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLocation setImage:[UIImage imageNamed:@"icn_location_top"] forState:UIControlStateNormal];
//    [btnLocation addTarget:self action:@selector(animateSearchBar) forControlEvents:UIControlEventTouchUpInside];
    [btnLocation setFrame:CGRectMake(72, 0, 32, 32)];
    
    
    UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 105, 32)];
    [rightBarButtonItems addSubview:btnfilter];
    [rightBarButtonItems addSubview:btnSearch];
    [rightBarButtonItems addSubview:btnLocation];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
    
    
    cctvDataSource = [[NSArray alloc] initWithObjects:@"Balestier Point",@"Balestier Road/Prome Road",@"Boon Keng Road/Bendemeer Road",@"Boon Lay Way",@"Bt Timah Road",@"Cambridge Road",@"Chai Chee Road",@"Commonwealth Ave",@"CTE Exit 7A",@"Wheelock Place",@"Woodlands Ave 2", nil];
    
    cctvListingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    cctvListingTable.delegate = self;
    cctvListingTable.dataSource = self;
    [self.view addSubview:cctvListingTable];
    cctvListingTable.backgroundColor = [UIColor clearColor];
    cctvListingTable.backgroundView = nil;
    cctvListingTable.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -256, self.view.bounds.size.width, 256) style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.backgroundView = nil;
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filterTableView.alpha = 0.8;

    
    filtersArray = [[NSArray alloc] initWithObjects:@"Name",@"Distance", nil];
    
    searchField = [[UITextField alloc] initWithFrame:CGRectMake(0, -50, self.view.bounds.size.width, 40)];
    searchField.textColor = RGB(35, 35, 35);
    searchField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    searchField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.borderStyle = UITextBorderStyleNone;
    searchField.textAlignment=NSTextAlignmentLeft;
    [searchField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    searchField.placeholder = @"Search...";
    [self.view addSubview:searchField];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.delegate = self;
    searchField.returnKeyType = UIReturnKeyDone;
    searchField.keyboardType = UIKeyboardTypeEmailAddress;
    searchField.backgroundColor = [UIColor whiteColor];
    [searchField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
}



- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;

    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(71, 178, 182) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
}


@end
