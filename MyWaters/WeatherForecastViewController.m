//
//  WeatherForecastViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 2/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "WeatherForecastViewController.h"

@interface WeatherForecastViewController ()

@end

@implementation WeatherForecastViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10.0f;
}


# pragma mark - UITableViewDataSource Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //    return weatherDataSource.count;
    return 5;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = [UIColor whiteColor];
    
    UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 15)];
    dayLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    dayLabel.text = @"TODAY";
    dayLabel.textColor = RGB(36,160,236);
    dayLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:dayLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 100, 30)];
    timeLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:22.0];
    timeLabel.text = @"08:15 PM";
    timeLabel.textColor = RGB(36,160,236);
    timeLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:timeLabel];
    
    UILabel *weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(weatherTableView.bounds.size.width-80, 10, 100, 15)];
    weatherLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    weatherLabel.text = @"CLOUDY";
    weatherLabel.textColor = [UIColor lightGrayColor];
    weatherLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:weatherLabel];
    
    UILabel *tempratureLabel = [[UILabel alloc] initWithFrame:CGRectMake(weatherTableView.bounds.size.width-80, 25, 100, 30)];
    tempratureLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:22.0];
    tempratureLabel.text = [NSString stringWithFormat:@"36/22%@",@"°"];
    tempratureLabel.textColor = [UIColor blackColor];
    tempratureLabel.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:tempratureLabel];
    
    UIImageView *weatherIcon = [[UIImageView alloc] initWithFrame:CGRectMake((weatherTableView.bounds.size.width/2)-15, 15, 30, 30)];
    [weatherIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_rainy_weather.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [cell.contentView addSubview:weatherIcon];
    
    return cell;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Weather Forecast";
    self.view.backgroundColor = RGB(247, 247, 247);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];

    weatherTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20, self.view.bounds.size.height-64) style:UITableViewStyleGrouped];
    weatherTableView.delegate = self;
    weatherTableView.dataSource = self;
    [self.view addSubview:weatherTableView];
    weatherTableView.backgroundColor = [UIColor clearColor];
    weatherTableView.backgroundView = nil;
    weatherTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];

}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(36,160,236) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];

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
