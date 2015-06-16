//
//  EventsViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "EventsViewController.h"
#import "ViewControllerHelper.h"


@interface EventsViewController ()

@end

@implementation EventsViewController
@synthesize isNotEventController;



//*************** Method To Animate Filter Table

- (void) animateFilterTable {
    
    [UIView beginAnimations:@"filterTable" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = filterTableView.center;
    
    if (isShowingFilter) {
        isShowingFilter = NO;
        pos.y = -70;
        
        eventsListingTableView.alpha = 1.0;
        eventsListingTableView.userInteractionEnabled = YES;
        
    }
    else {
        isShowingFilter = YES;
        pos.y = 64;
        
        eventsListingTableView.alpha = 0.5;
        eventsListingTableView.userInteractionEnabled = NO;
    }
    filterTableView.center = pos;
    [UIView commitAnimations];
    
}


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


// Temp Method

- (void) moveToEventDetails {
    
    EventsDetailsViewController *viewObj = [[EventsDetailsViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:NO];
    
}



//*************** Demo App UI

- (void) createDemoAppControls {
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/events_listing.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    
    UIButton *moveToEventDetails = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moveToEventDetails.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [moveToEventDetails addTarget:self action:@selector(moveToEventDetails) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moveToEventDetails];
    
    
    //    if (IS_IPHONE_4_OR_LESS) {
    //        quickMapButton.frame = CGRectMake(10, 75, (self.view.bounds.size.width-30)/2, 105);
    //        cctvButton.frame = CGRectMake(10, 300, (self.view.bounds.size.width-30)/2, 100);
    //        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 75, (self.view.bounds.size.width-30)/2, 210);
    //        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 300, (self.view.bounds.size.width-30)/2, 100);
    //    }
    //    else if (IS_IPHONE_5) {
    //        quickMapButton.frame = CGRectMake(10, 90, (self.view.bounds.size.width-30)/2, 125);
    //        cctvButton.frame = CGRectMake(10, 360, (self.view.bounds.size.width-30)/2, 130);
    //        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 90, (self.view.bounds.size.width-30)/2, 260);
    //        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 360, (self.view.bounds.size.width-30)/2, 130);
    //    }
    //    else if (IS_IPHONE_6) {
    //        quickMapButton.frame = CGRectMake(10, 110, (self.view.bounds.size.width-30)/2, 145);
    //        cctvButton.frame = CGRectMake(10, 430, (self.view.bounds.size.width-30)/2, 150);
    //        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 110, (self.view.bounds.size.width-30)/2, 305);
    //        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 430, (self.view.bounds.size.width-30)/2, 150);
    //    }
    //    else if (IS_IPHONE_6P) {
    //        quickMapButton.frame = CGRectMake(10, 125, (self.view.bounds.size.width-30)/2, 160);
    //        cctvButton.frame = CGRectMake(10, 480, (self.view.bounds.size.width-30)/2, 165);
    //        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 125, (self.view.bounds.size.width-30)/2, 335);
    //        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 480, (self.view.bounds.size.width-30)/2, 165);
    //    }
    
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==filterTableView) {
        return 40.0f;
    }
    else if (tableView==eventsListingTableView) {
        return 100.0f;
    }
    
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==filterTableView) {
        selectedFilterIndex = indexPath.row;
        [filterTableView reloadData];
    }
    else if (tableView==eventsListingTableView) {
        EventsDetailsViewController *viewObj = [[EventsDetailsViewController alloc] init];
        viewObj.descriptionTempString = [eventsTableDataSource objectAtIndex:(indexPath.row*5)+4];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==eventsListingTableView) {
        //        return eventsTableDataSource.count;
        return 5;
    }
    else if (tableView==filterTableView) {
        return filtersArray.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    if (tableView==filterTableView) {
        
        cell.backgroundColor = RGB(247, 247, 247);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, eventsListingTableView.bounds.size.width-10, cell.bounds.size.height)];
        titleLabel.text = [filtersArray objectAtIndex:indexPath.row];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39.5, eventsListingTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        if (indexPath.row==selectedFilterIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    else if (tableView==eventsListingTableView) {
        
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 70, 70)];
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/default_no_image.png",appDelegate.RESOURCE_FOLDER_PATH]];
        [cell.contentView addSubview:cellImage];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, eventsListingTableView.bounds.size.width-100, 40)];
        //        titleLabel.text = [[eventsTableDataSource objectAtIndex:indexPath.row] objectForKey:@"eventTitle"];
        titleLabel.text = [NSString stringWithFormat:@"%@",[eventsTableDataSource objectAtIndex:(indexPath.row*5)]];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        [cell.contentView addSubview:titleLabel];
        
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, 150, 20)];
        //        dateLabel.text = [[eventsTableDataSource objectAtIndex:indexPath.row] objectForKey:@"eventDate"];
        dateLabel.text = [NSString stringWithFormat:@"%@",[eventsTableDataSource objectAtIndex:(indexPath.row*5)+2]];
        dateLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11.0];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textColor = [UIColor darkGrayColor];
        dateLabel.numberOfLines = 0;
        [cell.contentView addSubview:dateLabel];
        
//        UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(eventsListingTableView.bounds.size.width-100, 80, 90, 20)];
        UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 80, 150, 20)];
        distanceLabel.text = [NSString stringWithFormat:@"@ %@",[eventsTableDataSource objectAtIndex:(indexPath.row*5)+3]];
//        distanceLabel.text = @"10 KM";
        distanceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:10.5];
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.textColor = [UIColor darkGrayColor];
        distanceLabel.numberOfLines = 0;
        distanceLabel.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:distanceLabel];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 99.5, eventsListingTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
    }
    
    return cell;
}

# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];

    
    self.view.backgroundColor = RGB(247, 247, 247);
    selectedFilterIndex = 0;
    
    eventsTableDataSource = [[NSMutableArray alloc] initWithObjects:@"Fireworks Display for SEA Games 2015 - CR4",@"Kallang Basin",@"16 May2015 - 16 May 2015",@"9:00pm - 10:00pm",@"Organised by SEA Games 2015 OCC Committee.",
                                                                    @"Mass Exercise",@"Mac Ritchie",@"21 May 2015 - 21 May 2015",@"4:30pm - 6:00pm",@"Organised by Mount Alvernia Hospital",
                                                                    @"Cross Country",@"MacRitchie Reservoir",@"22 May 2015 - 22 May 2015",@"7:30am - 12:00pm",@"Organised by St Gabriel's Secondry School",
                                                                    @"5 Km Reservoir Discovery Series",@"Jurong Lake",@"24 May 2015 - 24 May 2015",@"10:00am - 4:00pm",@"Organised by People's Association",
                                                                    @"Learning Trail",@"Sengkang Floating Wetland",@"26 May 2015 - 26 May 2015",@"9:00am - 11:00am",@"Organised by Pat's Schoolhouse - Prinsep",
                             nil];
    
    eventsListingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    eventsListingTableView.delegate = self;
    eventsListingTableView.dataSource = self;
    [self.view addSubview:eventsListingTableView];
    eventsListingTableView.backgroundColor = [UIColor clearColor];
    eventsListingTableView.backgroundView = nil;
    eventsListingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -128, self.view.bounds.size.width, 128) style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.backgroundView = nil;
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    filtersArray = [[NSArray alloc] initWithObjects:@"Date",@"Distance",@"Name", nil];
    
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];
    
    if (!isNotEventController) {
        
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    }
    else {
        
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(247,196,9) frame:CGRectMake(0, 0, 1, 1)];
        [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
        [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
        [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
        [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
        
        self.title = @"Events";
        
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
        
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
