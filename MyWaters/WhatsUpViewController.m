//
//  WhatsUpViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "WhatsUpViewController.h"
#import "ViewControllerHelper.h"


@interface WhatsUpViewController ()

@end

@implementation WhatsUpViewController
@synthesize isNotWhatsUpController;


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Method To Handle Segmented Control Action

- (void) handleSegmentedControl:(UISegmentedControl*) sender {
    
    if (sender==segmentedControl) {
        if (sender.selectedSegmentIndex==0) {
            exploreTableView.hidden = YES;
            feedTableView.hidden = NO;
        }
        else if (sender.selectedSegmentIndex==1) {
            exploreTableView.hidden = NO;
            feedTableView.hidden = YES;
        }
    }
}


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==feedTableView) {
        return 90.0f;
    }
    else if (tableView==exploreTableView) {
        return 75.0f;
    }
    return 0.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView==exploreTableView) {

    }
    else if (tableView==feedTableView) {

    }
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==feedTableView) {
//        return feedDataSource.count;
        return 10;
    }
    else if (tableView==exploreTableView) {
//        return exploreDataSource.count;
        return 5;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = RGB(247, 247, 247);

    if (tableView==exploreTableView) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, cell.bounds.size.width-100, 40)];
        //                titleLabel.text = [[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"feedTitle"];
        titleLabel.text = [NSString stringWithFormat:@"Explore %ld",indexPath.row+1];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = RGB(247,196,9);
        titleLabel.numberOfLines = 0;
        [cell.contentView addSubview:titleLabel];
        
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, cell.bounds.size.width-100, 15)];
        //                dateLabel.text = [[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"feedSubtitle"];
        subtitleLabel.text = [NSString stringWithFormat:@"Explore Subtitle %ld",indexPath.row+1];
        subtitleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.textColor = [UIColor blackColor];
        subtitleLabel.numberOfLines = 0;
        [cell.contentView addSubview:subtitleLabel];
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 74.5, cell.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        
    }
    else if (tableView==feedTableView) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, cell.bounds.size.width-100, 40)];
//                titleLabel.text = [[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"feedTitle"];
        titleLabel.text = [NSString stringWithFormat:@"Feed %ld",indexPath.row+1];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = RGB(247,196,9);
        titleLabel.numberOfLines = 0;
        [cell.contentView addSubview:titleLabel];
        
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, cell.bounds.size.width-100, 30)];
//                subtitleLabel.text = [[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"feedSubtitle"];
        subtitleLabel.text = [NSString stringWithFormat:@"Feed Subtitle %ld",indexPath.row+1];
        subtitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.textColor = [UIColor blackColor];
        subtitleLabel.numberOfLines = 0;
        [cell.contentView addSubview:subtitleLabel];
        
        
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 89.5, cell.bounds.size.width, 0.5)];
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
    self.view.backgroundColor = RGB(247, 247, 247);
    
    segmentedControlBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    segmentedControlBackground.backgroundColor = RGB(247,196,9);
    [self.view addSubview:segmentedControlBackground];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"FEED", @"EXPLORE", nil];
    
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    if (IS_IPHONE_4_OR_LESS) {
        segmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-85, 12.5, 170, 25);
    }
    else if (IS_IPHONE_5) {
        segmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-90, 12.5, 180, 25);
    }
    else if (IS_IPHONE_6) {
        segmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-100, 12.5, 200, 25);
    }
    else if (IS_IPHONE_6P) {
        segmentedControl.frame = CGRectMake(segmentedControlBackground.bounds.size.width/2-110, 12.5, 220, 25);
    }
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(handleSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [segmentedControlBackground addSubview:segmentedControl];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:ROBOTO_MEDIUM size:13], NSFontAttributeName,
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                nil];
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:RGB(247,196,9) forKey:NSForegroundColorAttributeName];
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    segmentedControlBackground.tintColor = [UIColor whiteColor];
    
    
    feedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-114) style:UITableViewStylePlain];
    feedTableView.delegate = self;
    feedTableView.dataSource = self;
    [self.view addSubview:feedTableView];
    feedTableView.backgroundColor = [UIColor clearColor];
    feedTableView.backgroundView = nil;
    feedTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    exploreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-114) style:UITableViewStylePlain];
    exploreTableView.delegate = self;
    exploreTableView.dataSource = self;
    [self.view addSubview:exploreTableView];
    exploreTableView.backgroundColor = [UIColor clearColor];
    exploreTableView.backgroundView = nil;
    exploreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    exploreTableView.hidden = YES;

}


- (void) viewWillAppear:(BOOL)animated {
    
    if (!isNotWhatsUpController) {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    }
    else {
        UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(247,196,9) frame:CGRectMake(0, 0, 1, 1)];
        [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
        
        NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
        [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
        [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
        [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
        
        self.title = @"What's Up";
        
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
        
    }
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
