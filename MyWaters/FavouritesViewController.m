//
//  FavouritesViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "FavouritesViewController.h"
#import "ViewControllerHelper.h"


@interface FavouritesViewController ()

@end

@implementation FavouritesViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}



//*************** Method To ANimate Filter Table

- (void) animateFilterTable {
    
    [UIView beginAnimations:@"filterTable" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = filterTableView.center;
    
    if (isShowingFilter) {
        
        isShowingFilter = NO;
        pos.y = -120;
        
        favouritesListingTableView.alpha = 1.0;
        favouritesListingTableView.userInteractionEnabled = YES;
    }
    else {
        
        isShowingFilter = YES;
        pos.y = 80;
        
        favouritesListingTableView.alpha = 0.5;
        favouritesListingTableView.userInteractionEnabled = NO;
    }
    filterTableView.center = pos;
    [UIView commitAnimations];
    
}



# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==filterTableView) {
        return 40.0f;
    }
    return 80.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==filterTableView) {
    
        selectedFilterIndex = indexPath.row;
        [filterTableView reloadData];
        [self animateFilterTable];
    }
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==favouritesListingTableView) {
        return favouritesDataSource.count;
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
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/default_no_image.png",appDelegate.RESOURCE_FOLDER_PATH]];
        [cell.contentView addSubview:cellImage];
        
        //-----Temp Code
        if (indexPath.row==1  || indexPath.row==2) {
            cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/CCTV-2.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
        else if (indexPath.row==0) {
            cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwater_list.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, favouritesListingTableView.bounds.size.width-100, 40)];
        //    titleLabel.text = [[favouritesDataSource objectAtIndex:indexPath.row] objectForKey:@"favouriteTitle"];
        titleLabel.text = [favouritesDataSource objectAtIndex:indexPath.row];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        [cell.contentView addSubview:titleLabel];
        
        //    UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, favouritesListingTableView.bounds.size.width-100, 20)];
        //    distanceLabel.text = @"10 KM";
        //    distanceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
        //    distanceLabel.backgroundColor = [UIColor clearColor];
        //    distanceLabel.textColor = [UIColor lightGrayColor];
        //    distanceLabel.numberOfLines = 0;
        //    [cell.contentView addSubview:distanceLabel];
        
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79.5, favouritesListingTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
    }
    
    return cell;
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(247, 247, 247);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];
    
    favouritesListingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    favouritesListingTableView.delegate = self;
    favouritesListingTableView.dataSource = self;
    [self.view addSubview:favouritesListingTableView];
    favouritesListingTableView.backgroundColor = [UIColor clearColor];
    favouritesListingTableView.backgroundView = nil;
    favouritesListingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -160, self.view.bounds.size.width, 160) style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.backgroundView = nil;
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filterTableView.alpha = 0.8;
    
    favouritesDataSource = [[NSArray alloc] initWithObjects:@"Sembawang Park - ABC Waters",@"Boon Lay Way - CCTV",@"Boon Keng Road/Bendemeer Road - CCTV", nil];
    filtersArray = [[NSArray alloc] initWithObjects:@"All",@"CCTV",@"Event",@"Distance", nil];

}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
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
