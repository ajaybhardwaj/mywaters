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
    else {
        
        if ([[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+17] isEqualToString:@"1"]) {
            
            CCTVDetailViewController *viewObj = [[CCTVDetailViewController alloc] init];
            
            viewObj.imageUrl = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+2];
            viewObj.titleString = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+1];
            viewObj.cctvID = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+18];
            viewObj.latValue = [[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+3] doubleValue];
            viewObj.longValue = [[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+4] doubleValue];
            
            [self.navigationController pushViewController:viewObj animated:YES];
            
        }
        else if ([[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+17] isEqualToString:@"2"]) {
            
            EventsDetailsViewController *viewObj = [[EventsDetailsViewController alloc] init];
            
            viewObj.eventID = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+18];
            viewObj.titleString = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+1];
            viewObj.descriptionString = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+7];
            viewObj.latValue = [[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+3] doubleValue];
            viewObj.longValue = [[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+4] doubleValue];
            viewObj.phoneNoString = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+6];
            viewObj.addressString = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+5];
            viewObj.startDateString = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+8];
            viewObj.endDateString = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+9];
            
            viewObj.imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+2]];
            viewObj.imageName = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+2];
            
            [self.navigationController pushViewController:viewObj animated:YES];
            
        }
        else if ([[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+17] isEqualToString:@"3"]) {
            
            ABCWaterDetailViewController *viewObj = [[ABCWaterDetailViewController alloc] init];
            
            viewObj.titleString = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+1];
            viewObj.descriptionString = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+7];
            viewObj.latValue = [[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+3] doubleValue];
            viewObj.longValue = [[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+4] doubleValue];
            viewObj.phoneNoString = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+6];
            viewObj.addressString = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+5];
            viewObj.imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+2]];
            viewObj.imageName = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+2];
            viewObj.isCertified = [[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+11] intValue];
            
            [self.navigationController pushViewController:viewObj animated:YES];
        }
        else if ([[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+17] isEqualToString:@"4"]) {
            
            WaterLevelSensorsDetailViewController *viewObj = [[WaterLevelSensorsDetailViewController alloc] init];
            
            viewObj.wlsID = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)];
            viewObj.wlsName = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+1];
            viewObj.drainDepthType = [[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+13] intValue];
            viewObj.latValue = [[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+3] doubleValue];
            viewObj.longValue = [[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+4] doubleValue];
            viewObj.observedTime = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+16];
            viewObj.waterLevelValue = [NSString stringWithFormat:@"%d",[[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+12] intValue]];
            viewObj.waterLevelPercentageValue = [NSString stringWithFormat:@"%d",[[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+14] intValue]];
            viewObj.waterLevelTypeValue = [NSString stringWithFormat:@"%d",[[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+15] intValue]];
            viewObj.drainDepthValue = [NSString stringWithFormat:@"%d",[[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+13] intValue]];
            
            [self.navigationController pushViewController:viewObj animated:YES];
        }
        
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        
        // Delete Data From Table
        [appDelegate deleteFavouriteItems:[[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)] intValue]];

        int count = 0;
        for (int i=18; i>=0; i--) {
           
            count = count +1;
            DebugLog(@"Count is %d",count);
            [appDelegate.USER_FAVOURITES_ARRAY removeObjectAtIndex:(indexPath.row*19)+i];
        }
        
        [favouritesListingTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}




# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==favouritesListingTableView) {
        return appDelegate.USER_FAVOURITES_ARRAY.count/19;
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
        [cell.contentView addSubview:cellImage];
        
        if ([[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+17] isEqualToString:@"1"]) {
            
            cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/CCTV-2.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
        else if ([[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+17] isEqualToString:@"2"]) {
            
            NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
            NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Events"]];
            
            NSString *localFile = [destinationPath stringByAppendingPathComponent:[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+2]];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
                if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+2]]] != nil)
                    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+2]]];
            }
        }
        else if ([[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+17] isEqualToString:@"4"]) {
            
            cellImage.frame = CGRectMake(15, 15, 50, 50);
            
            if ([[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+15] intValue] == 1) {
                cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_below75_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
            }
            else if ([[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+15] intValue] == 2) {
                cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_75-90_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
            }
            else if ([[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+15] intValue] == 3) {
                cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_90_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
            }
            else if ([[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+15] intValue] == 4){
                cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_maintenance.png",appDelegate.RESOURCE_FOLDER_PATH]];
            }
        }
        else if ([[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+17] isEqualToString:@"3"]) {
            
            NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
            NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ABCWaters"]];
            
            NSString *localFile = [destinationPath stringByAppendingPathComponent:[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+2]];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
                if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+2]]] != nil)
                    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:[appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+2]]];
            }
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, favouritesListingTableView.bounds.size.width-100, 40)];
        titleLabel.text = [appDelegate.USER_FAVOURITES_ARRAY objectAtIndex:(indexPath.row*19)+1];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79.5, favouritesListingTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    
    selectedFilterIndex = 0;
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(85,49,118) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    [appDelegate retrieveFavouriteItems:selectedFilterIndex];
    if (appDelegate.USER_FAVOURITES_ARRAY.count!=0) {
        [favouritesListingTableView reloadData];
    }

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
