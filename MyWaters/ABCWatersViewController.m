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
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Method To Handle Segmented Control Action

- (void) handleSegmentedControl:(UISegmentedControl*) sender {
    
    if (sender==gridListSegmentedControl) {
        if (sender.selectedSegmentIndex==0) {
            listTabeView.hidden = YES;
            abcWatersScrollView.hidden = NO;
            [self createGridView];
        }
        else if (sender.selectedSegmentIndex==1) {
            listTabeView.hidden = NO;
            abcWatersScrollView.hidden = YES;
            [appDelegate retrieveABCWatersListing];
            [listTabeView reloadData];
        }
    }
}


//*************** Method To Create Grid View For ABC Waters

- (void) createGridView {
    
    int gridCount = 0;
    float xAxis = 0;
    float yAxis = 00;
    
    for (UIView * view in abcWatersScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    [appDelegate retrieveABCWatersListing];
    
    if (appDelegate.ABC_WATERS_LISTING_ARRAY.count !=0) {
        
        for (int i=0; i<appDelegate.ABC_WATERS_LISTING_ARRAY.count; i++) {
            
            UIButton *gridButton = [UIButton buttonWithType:UIButtonTypeCustom];
            gridButton.frame = CGRectMake(xAxis, yAxis, (segmentedControlBackground.bounds.size.width-2)/3, (segmentedControlBackground.bounds.size.width-2)/3);
//            [gridButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",appDelegate.RESOURCE_FOLDER_PATH,[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"image"]]] forState:UIControlStateNormal];
            [gridButton setBackgroundImage:[UIImage imageNamed:@"abcwaters_grid_new.png"] forState:UIControlStateNormal];
            [abcWatersScrollView addSubview:gridButton];
            

            // Commented For The Temp
            
//            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gridButton.bounds.size.height-40, gridButton.bounds.size.width, 40)];
//            nameLabel.backgroundColor = [UIColor clearColor];
//            nameLabel.text = [NSString stringWithFormat:@"%@",[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"name"]];
//            nameLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:12];
//            nameLabel.textColor = [UIColor whiteColor];
//            nameLabel.textAlignment = NSTextAlignmentCenter;
//            nameLabel.numberOfLines = 0;
//            [gridButton addSubview:nameLabel];
            
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
    
    [abcWatersScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, yAxis+20)];
}


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ABCWaterDetailViewController *viewObj = [[ABCWaterDetailViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:NO];
}


# pragma mark - UITableViewDataSource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (appDelegate.ABC_WATERS_LISTING_ARRAY.count!=0) {
        return appDelegate.ABC_WATERS_LISTING_ARRAY.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"abclisting"];
    
    if (appDelegate.ABC_WATERS_LISTING_ARRAY.count!=0) {
        
        cell.imageView.image = [UIImage imageNamed:@"abcwater_list.png"];//[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",appDelegate.RESOURCE_FOLDER_PATH,[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"image"]]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"name"]];
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79.5, listTabeView.bounds.size.width, 0.5)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];

    
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
    
    [self createGridView];
    //[self createDemoAppControls];
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
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
