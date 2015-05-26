//
//  NotificationsViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "NotificationsViewController.h"
#import "ViewControllerHelper.h"


@interface NotificationsViewController ()

@end

@implementation NotificationsViewController



//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
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
        
        notificationsTable.alpha = 1.0;
        notificationsTable.userInteractionEnabled = YES;
        
    }
    else {
        isShowingFilter = YES;
        pos.y = 135;
        
        notificationsTable.alpha = 0.5;
        notificationsTable.userInteractionEnabled = NO;
    }
    filterTableView.center = pos;
    [UIView commitAnimations];
    
}


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==filterTableView) {
        return 40.0f;
    }
    else if (tableView==notificationsTable) {
        return 80.0f;
    }
    
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==filterTableView) {
        selectedFilterIndex = indexPath.row;
        [filterTableView reloadData];
    }
    else {
        NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
        
        //    if (self.synthesizer.speaking == NO) {
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:[tableDataSource objectAtIndex:indexPath.row]];
        utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
        AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
        [synth speakUtterance:utterance];
    }
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==notificationsTable) {
        return tableDataSource.count;
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
        
        cell.backgroundColor = RGB(247, 247, 247);
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, notificationsTable.bounds.size.width-10, cell.bounds.size.height)];
        titleLabel.text = [filtersArray objectAtIndex:indexPath.row];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleLabel];
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39.5, notificationsTable.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        if (indexPath.row==selectedFilterIndex) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    else if (tableView==notificationsTable) {
        
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
        // ***** Temp Code For DEmo Only
        if (indexPath.row==0) {
            [cellImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_announcements_notification.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        }
        else if (indexPath.row==1) {
            [cellImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_floodinfo_notification.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        }
        else if (indexPath.row==2) {
            [cellImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_heavyrain_notification.png",appDelegate.RESOURCE_FOLDER_PATH]]];
        }
        [cell.contentView addSubview:cellImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, notificationsTable.bounds.size.width-80, 40)];
        //        titleLabel.text = [[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"notificationTitle"];
        titleLabel.text = [tableDataSource objectAtIndex:indexPath.row];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.numberOfLines = 0;
        [cell.contentView addSubview:titleLabel];
        
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 60, notificationsTable.bounds.size.width-80, 20)];
        //        dateLabel = [[tableDataSource objectAtIndex:indexPath.row] objectForKey:@"notificationDate"];
        dateLabel.text = @"Monday 27, March 2015 @ 8:13 AM";
        dateLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.numberOfLines = 0;
        dateLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:dateLabel];
        
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 79.5, notificationsTable.bounds.size.width, 0.5)];
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
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateFilterTable) withIconName:@"icn_filter"]];
    
    notificationsTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    notificationsTable.delegate = self;
    notificationsTable.dataSource = self;
    [self.view addSubview:notificationsTable];
    notificationsTable.backgroundColor = [UIColor clearColor];
    notificationsTable.backgroundView = nil;
    notificationsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    tableDataSource = [[NSArray alloc] initWithObjects:@"Sg Pandan Kechil (West Coast Highway): Water level falls below 75%. Moderate Flood Risk.",@"Sg Pandan Kechil (West Coast Highway): Water level rises above 75%. Moderate Flood Risk.",@"NEA: Moderate to heavy thundery showers & gusty winds expected over north, east & central SG btwn 14:30 to 15:30 hrs. Issued 13:48hrs.", nil];
    
    
    filterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -256, self.view.bounds.size.width, 256) style:UITableViewStylePlain];
    filterTableView.delegate = self;
    filterTableView.dataSource = self;
    [self.view addSubview:filterTableView];
    filterTableView.backgroundColor = [UIColor clearColor];
    filterTableView.backgroundView = nil;
    filterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    filtersArray = [[NSArray alloc] initWithObjects:@"Announcements",@"Events",@"Flood",@"Heavy Rain",@"iAlerts",@"Tips", nil];
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
