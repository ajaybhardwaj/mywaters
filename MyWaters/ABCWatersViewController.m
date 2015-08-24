//
//  ABCWatersViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 23/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ABCWatersViewController.h"
#import "ViewControllerHelper.h"

@interface ABCWatersViewController ()

@end

@implementation ABCWatersViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
    [searchField resignFirstResponder];
}


//*************** Method To Handle Segmented Control Action

- (void) handleSegmentedControl:(UISegmentedControl*) sender {
    
    if (sender==gridListSegmentedControl) {
        
        if (sender.selectedSegmentIndex==0) {
            listTabeView.hidden = YES;
            abcWatersScrollView.hidden = NO;
            [self createGridView];
            
            self.navigationItem.rightBarButtonItem = nil;
        }
        else if (sender.selectedSegmentIndex==1) {
            listTabeView.hidden = NO;
            abcWatersScrollView.hidden = YES;
            //            [appDelegate retrieveABCWatersListing];
            [listTabeView reloadData];
            
            UIButton *btnSearch =  [UIButton buttonWithType:UIButtonTypeCustom];
            [btnSearch setImage:[UIImage imageNamed:@"icn_search"] forState:UIControlStateNormal];
            [btnSearch addTarget:self action:@selector(animateSearchBar) forControlEvents:UIControlEventTouchUpInside];
            [btnSearch setFrame:CGRectMake(0, 0, 32, 32)];
            
            UIButton *btnfilter =  [UIButton buttonWithType:UIButtonTypeCustom];
            [btnfilter setImage:[UIImage imageNamed:@"icn_filter"] forState:UIControlStateNormal];
            [btnfilter addTarget:self action:@selector(animateFilterTable) forControlEvents:UIControlEventTouchUpInside];
            [btnfilter setFrame:CGRectMake(44, 0, 32, 32)];
            
            UIView *rightBarButtonItems = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 76, 32)];
            [rightBarButtonItems addSubview:btnSearch];
            [rightBarButtonItems addSubview:btnfilter];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButtonItems];
            
        }
    }
}



//*************** Method To Animate Search Bar

- (void) animateSearchBar {
    
    [UIView beginAnimations:@"searchbar" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = searchField.center;
    
    if (isShowingSearchBar) {
        isShowingSearchBar = NO;
        pos.y = -70;
        
        listTabeView.alpha = 1.0;
        listTabeView.userInteractionEnabled = YES;
        
        [searchField resignFirstResponder];
    }
    else {
        isShowingSearchBar = YES;
        pos.y = 20;
        
        if (isShowingFilter) {
            [self animateFilterTable];
        }
        
        listTabeView.alpha = 0.5;
        listTabeView.userInteractionEnabled = NO;
        
        [searchField becomeFirstResponder];
    }
    searchField.center = pos;
    [UIView commitAnimations];
}

//*************** Method To Animate Filter Table

- (void) animateFilterTable {
    
    [UIView beginAnimations:@"filterTable" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = filterTableView.center;
    
    if (isShowingFilter) {
        isShowingFilter = NO;
        pos.y = -70;
        
        listTabeView.alpha = 1.0;
        listTabeView.userInteractionEnabled = YES;
        
    }
    else {
        isShowingFilter = YES;
        pos.y = 45;
        
        if (isShowingSearchBar) {
            [self animateSearchBar];
        }
        
        listTabeView.alpha = 0.5;
        listTabeView.userInteractionEnabled = NO;
    }
    filterTableView.center = pos;
    [UIView commitAnimations];
    
}

//*************** Method To Move To ABC Water Detail View

- (void) moveToDetailsView:(id) sender {
    
    UIButton *button = (id) sender;
    
    ABCWaterDetailViewController *viewObj = [[ABCWaterDetailViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:NO];
}



//*************** Method To Create Grid View For ABC Waters

- (void) createGridView {
    
    int gridCount = 0;
    float xAxis = 0;
    float yAxis = 0;
    
    //    for (UIView * view in abcWatersScrollView.subviews) {
    //        [view removeFromSuperview];
    //    }
    
    //    [appDelegate retrieveABCWatersListing];
    
    if (appDelegate.ABC_WATERS_LISTING_ARRAY.count !=0) {
        
        for (int i=0; i<appDelegate.ABC_WATERS_LISTING_ARRAY.count; i++) {
            
            AsyncImageView *gridImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(xAxis, yAxis, (segmentedControlBackground.bounds.size.width-2)/3, (segmentedControlBackground.bounds.size.width-2)/3)];
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"image"]];
            [gridImage setImageURL:[NSURL URLWithString:imageURLString]];
            gridImage.showActivityIndicator = YES;
            [abcWatersScrollView addSubview:gridImage];
            gridImage.userInteractionEnabled = YES;
            
            UIButton *gridButton = [UIButton buttonWithType:UIButtonTypeCustom];
            gridButton.frame = CGRectMake(0, 0, gridImage.bounds.size.width, gridImage.bounds.size.height);
            gridButton.tag = i;
            [gridButton addTarget:self action:@selector(moveToDetailsView) forControlEvents:UIControlEventTouchUpInside];
            [gridImage addSubview:gridButton];
            
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, gridButton.bounds.size.height-40, gridButton.bounds.size.width-10, 40)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.text = [NSString stringWithFormat:@"%@",[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"siteName"]];
            nameLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11];
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.numberOfLines = 0;
            [gridButton addSubview:nameLabel];
            
            gridCount = gridCount + 1;
            if (gridCount!=3) {
                xAxis = xAxis + (segmentedControlBackground.bounds.size.width)/3;
            }
            else {
                xAxis = 0;
                gridCount = 0;
                yAxis = yAxis +(segmentedControlBackground.bounds.size.width-2)/3;
            }
        }
    }
    
    [abcWatersScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, yAxis+(segmentedControlBackground.bounds.size.width-2)/3+(segmentedControlBackground.bounds.size.width-2)/3)];
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    if ([request.name localizedCaseInsensitiveCompare:ABC_WATERS_LISTING] == NSOrderedSame) {
        if ([[[responseString JSONValue] objectForKey:SERVER_ERRORCODE] intValue] == REQUEST_SUCCESS) {
            
            NSArray *tempArray = [[[responseString JSONValue] objectForKey:@"data"] objectForKey:@"sites"];
            abcWatersTotalCount = [[[[responseString JSONValue] objectForKey:@"data"] objectForKey:@"total"] intValue];
            
            if (tempArray.count==0) {
                abcWatersPageCount = 0;
            }
            else {
                if (appDelegate.ABC_WATERS_LISTING_ARRAY.count==0) {
                    [appDelegate.ABC_WATERS_LISTING_ARRAY setArray:tempArray];
                }
                else {
                    if (appDelegate.ABC_WATERS_LISTING_ARRAY.count!=abcWatersTotalCount) {
                        for (int i=0; i<tempArray.count; i++) {
                            [appDelegate.ABC_WATERS_LISTING_ARRAY addObject:[tempArray objectAtIndex:i]];
                        }
                    }
                }
            }
        }
        
        [self createGridView];
        //[listTabeView reloadData];
    }
    
    // Use when fetching binary data
    //    NSData *responseData = [request responseData];
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    abcWatersPageCount = 0;
}


# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self animateSearchBar];
    return YES;
}



# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==filterTableView) {
        return 40.0f;
    }
    else if (tableView==listTabeView) {
        return 80.0f;
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==filterTableView) {
        selectedFilterIndex = indexPath.row;
        [filterTableView reloadData];
        [self animateFilterTable];
    }
    else {
        ABCWaterDetailViewController *viewObj = [[ABCWaterDetailViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:NO];
    }
}


# pragma mark - UITableViewDataSource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==listTabeView) {
        if (appDelegate.ABC_WATERS_LISTING_ARRAY.count!=0) {
            return appDelegate.ABC_WATERS_LISTING_ARRAY.count;
        }
    }
    else if (tableView==filterTableView) {
        return filtersArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"abclisting"];
    
    
    if (tableView==filterTableView) {
        
        cell.backgroundColor = [UIColor blackColor];//RGB(247, 247, 247);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, filterTableView.bounds.size.width-10, cell.bounds.size.height)];
        titleLabel.text = [filtersArray objectAtIndex:indexPath.row];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:titleLabel];
        
        if (indexPath.row==selectedFilterIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39.5, filterTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
    }
    
    else {
        
        if (appDelegate.ABC_WATERS_LISTING_ARRAY.count!=0) {
            
            AsyncImageView *cellImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(5, 10, 60, 60)];
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"image"]];
            [cellImage setImageURL:[NSURL URLWithString:imageURLString]];
            cellImage.showActivityIndicator = YES;
            [cell.contentView addSubview:cellImage];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, listTabeView.bounds.size.width-100, 40)];
            titleLabel.text = [NSString stringWithFormat:@"%@",[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"siteName"]];
            titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.numberOfLines = 0;
            [cell.contentView addSubview:titleLabel];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79.5, listTabeView.bounds.size.width, 0.5)];
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
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
    segmentedControlBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    segmentedControlBackground.backgroundColor = RGB(52, 156, 249);
    [self.view addSubview:segmentedControlBackground];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"GRID", @"LIST", nil];
    
    gridListSegmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    if (IS_IPHONE_4_OR_LESS) {
        gridListSegmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-85, 12.5, 170, 25);
    }
    else if (IS_IPHONE_5) {
        gridListSegmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-90, 12.5, 180, 25);
    }
    else if (IS_IPHONE_6) {
        gridListSegmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-100, 12.5, 200, 25);
    }
    else if (IS_IPHONE_6P) {
        gridListSegmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-110, 12.5, 220, 25);
    }
    gridListSegmentedControl.selectedSegmentIndex = 0;
    [gridListSegmentedControl addTarget:self action:@selector(handleSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [segmentedControlBackground addSubview:gridListSegmentedControl];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:ROBOTO_MEDIUM size:13], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                nil];
    [gridListSegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:RGB(52, 156, 249) forKey:NSForegroundColorAttributeName];
    [gridListSegmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    segmentedControlBackground.tintColor = [UIColor whiteColor];
    
    
    abcWatersScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, segmentedControlBackground.frame.origin.y+segmentedControlBackground.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-segmentedControlBackground.bounds.size.height)];
    abcWatersScrollView.showsHorizontalScrollIndicator = NO;
    abcWatersScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:abcWatersScrollView];
    abcWatersScrollView.backgroundColor = [UIColor whiteColor];
    
    
    listTabeView = [[UITableView alloc] initWithFrame:CGRectMake(0, segmentedControlBackground.frame.origin.y+segmentedControlBackground.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-segmentedControlBackground.bounds.size.height-65) style:UITableViewStylePlain];
    listTabeView.delegate = self;
    listTabeView.dataSource = self;
    [self.view addSubview:listTabeView];
    listTabeView.backgroundColor = [UIColor clearColor];
    listTabeView.backgroundView = nil;
    listTabeView.hidden = YES;
    listTabeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -90, self.view.bounds.size.width, 90) style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.backgroundView = nil;
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    filterTableView.alpha = 0.8;
    
    filtersArray = [[NSArray alloc] initWithObjects:@"Name",@"Distance", nil];
    abcWatersPageCount = 0;
    
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
    searchField.keyboardType = UIKeyboardTypeEmailAddress;
    searchField.returnKeyType = UIReturnKeyDone;
    searchField.backgroundColor = [UIColor whiteColor];
    [searchField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [CommonFunctions grabGetRequest:ABC_WATERS_LISTING delegate:self isNSData:NO];
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    self.navigationController.navigationBar.hidden = NO;
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
