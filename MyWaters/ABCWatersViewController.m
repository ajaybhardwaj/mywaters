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
    float yAxis = 10;
    
    for (UIView * view in abcWatersScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    [appDelegate retrieveABCWatersListing];
    
    if (appDelegate.ABC_WATERS_LISTING_ARRAY.count !=0) {
        
        for (int i=0; i<appDelegate.ABC_WATERS_LISTING_ARRAY.count; i++) {
            
            UIButton *gridButton = [UIButton buttonWithType:UIButtonTypeCustom];
            gridButton.frame = CGRectMake(xAxis, yAxis, (segmentedControlBackground.bounds.size.width-2)/3, (segmentedControlBackground.bounds.size.width-2)/3);
            [gridButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",appDelegate.RESOURCE_FOLDER_PATH,[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"image"]]] forState:UIControlStateNormal];
            [abcWatersScrollView addSubview:gridButton];
            
            
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, gridButton.bounds.size.height-40, gridButton.bounds.size.width, 40)];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.text = [NSString stringWithFormat:@"%@",[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:i] objectForKey:@"name"]];
            nameLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:12];
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
    
    [abcWatersScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, yAxis+20)];
}


// Temp Method

- (void) moveToABCWaterDetails {
    
    ABCWaterDetailViewController *viewObj = [[ABCWaterDetailViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:NO];
    
}

////*************** Demo App Controls Action Handler
//
//- (void) handleDemoControls:(id) sender {
//
//    UIButton *button = (id) sender;
//
//    if (button.tag==1) {
//        [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwaters_grid.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//        [self.navigationItem setRightBarButtonItem:nil];
//    }
//    else if (button.tag==2) {
//        [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwaters_list.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//        [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:nil withIconName:@"icn_filter"]];
//    }
//}
//
//
//
////*************** Demo App UI
//
//- (void) createDemoAppControls {
//
//    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
//    [self.view addSubview:bgImageView];
//    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/abcwaters_grid.png",appDelegate.RESOURCE_FOLDER_PATH]]];
//
//
//    gridButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    gridButton.tag = 1;
//    [gridButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:gridButton];
//
//    listButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    listButton.tag = 2;
//    [listButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:listButton];
//
//    if (IS_IPHONE_4_OR_LESS) {
//        gridButton.frame = CGRectMake(self.view.bounds.size.width/2-90, 5, 90, 25);
//        listButton.frame = CGRectMake(self.view.bounds.size.width/2, 5, 90, 25);
//    }
//    else if (IS_IPHONE_5) {
//        gridButton.frame = CGRectMake(self.view.bounds.size.width/2-85, 5, 85, 25);
//        listButton.frame = CGRectMake(self.view.bounds.size.width/2, 5, 85, 25);
//    }
//    else if (IS_IPHONE_6) {
//        gridButton.frame = CGRectMake(self.view.bounds.size.width/2-100, 5, 100, 35);
//        listButton.frame = CGRectMake(self.view.bounds.size.width/2, 5, 100, 35);
//    }
//    else if (IS_IPHONE_6P) {
//        gridButton.frame = CGRectMake(self.view.bounds.size.width/2-110, 5, 110, 45);
//        listButton.frame = CGRectMake(self.view.bounds.size.width/2, 5, 110, 45);
//    }
//
//
//    UIButton *moveToABCWaterDetailsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    moveToABCWaterDetailsButton.frame = CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height-40);
//    [moveToABCWaterDetailsButton addTarget:self action:@selector(moveToABCWaterDetails) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:moveToABCWaterDetailsButton];
//}



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
        
        cell.imageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",appDelegate.RESOURCE_FOLDER_PATH,[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"image"]]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[[appDelegate.ABC_WATERS_LISTING_ARRAY objectAtIndex:indexPath.row] objectForKey:@"name"]];
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    
    segmentedControlBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    segmentedControlBackground.backgroundColor = RGB(52, 156, 249);
    [self.view addSubview:segmentedControlBackground];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"GRID", @"LIST", nil];
    
    gridListSegmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    if (IS_IPHONE_4_OR_LESS) {
        gridListSegmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-85, 10, 170, 30);
    }
    else if (IS_IPHONE_5) {
        gridListSegmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-90, 10, 180, 30);
    }
    else if (IS_IPHONE_6) {
        gridListSegmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-100, 10, 200, 30);
    }
    else if (IS_IPHONE_6P) {
        gridListSegmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-110, 10, 220, 30);
    }
    gridListSegmentedControl.selectedSegmentIndex = 0;
    [gridListSegmentedControl addTarget:self action:@selector(handleSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [segmentedControlBackground addSubview:gridListSegmentedControl];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:ROBOTO_BOLD size:14], NSFontAttributeName,
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
    
    [self createGridView];
    //[self createDemoAppControls];
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = NO;
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
