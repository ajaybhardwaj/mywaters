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
@synthesize isNotWhatsUpController,isDashboardChatter;


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}




//*************** Method To Handle Segmented Control Action

- (void) handleSegmentedControl:(UISegmentedControl*) sender {
    
    if (sender==segmentedControl) {
        if (sender.selectedSegmentIndex==0) {
            isShowingChatterTable = YES;
            isShowingFeedTable = NO;
            exploreTableView.hidden = YES;
            feedTableView.hidden = NO;
        }
        else if (sender.selectedSegmentIndex==1) {
            isShowingFeedTable = YES;
            isShowingChatterTable = NO;
            exploreTableView.hidden = NO;
            feedTableView.hidden = YES;
        }
    }
}


//*************** Method To Get WLS Listing

- (void) fetchFeedsAndChatterListing {
    
    NSArray *parameters = [[NSArray alloc] initWithObjects:@"ListGetMode[0]",@"version", nil];
    NSArray *values = [[NSArray alloc] initWithObjects:@"12",@"1.0", nil];
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,MODULES_API_URL]];
}



# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    [appDelegate.hud hide:YES];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        NSArray *tempArray = [[NSArray alloc] init];
        tempArray = [[responseString JSONValue] objectForKey:FEEDS_CHATTER_LISTING_RESPONSE_NAME];
        
        if (tempArray.count==0) {
            
        }
        else {
            
            [feedDataSource removeAllObjects];
            [chatterDataSource removeAllObjects];
            
            for (int i=0; i<tempArray.count; i++) {
                if ([[[tempArray objectAtIndex:i] objectForKey:@"Type"] intValue] == 1) {
                    [feedDataSource addObject:[tempArray objectAtIndex:i]];
                }
                if ([[[tempArray objectAtIndex:i] objectForKey:@"IsChatter"] intValue] == true) {
                    [chatterDataSource addObject:[tempArray objectAtIndex:i]];
                }
            }
        }
        
        if (chatterDataSource.count!=0) {
            
            NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"PostedAt" ascending:NO];
            [chatterDataSource sortUsingDescriptors:[NSArray arrayWithObjects:sortByDate,nil]];
            
            [exploreTableView reloadData];
        }
        if (feedDataSource.count!=0) {
            
            NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"PostedAt" ascending:NO];
            [feedDataSource sortUsingDescriptors:[NSArray arrayWithObjects:sortByDate,nil]];
            
            [feedTableView reloadData];
        }
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"Ok" otherButton:nil];
    }
}


- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"Ok" otherButton:nil];
    [appDelegate.hud hide:YES];
}


# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    float titleHeight = 0.0;
    float subTitleHeight = 0.0;
    float dateHeight = 0.0;
    int subtractComponent = 0;
    
    if (tableView==feedTableView) {
        
        if ([[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"FeedText"] != (id)[NSNull null]) {
            titleHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"FeedText"]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:14.0] withinWidth:feedTableView.bounds.size.width-100];
            subtractComponent = subtractComponent + 30;
        }
        
        if ([[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"HashTag"] != (id)[NSNull null]) {
            subTitleHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"HashTag"]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0] withinWidth:feedTableView.bounds.size.width-100];
            subtractComponent = subtractComponent + 30;
        }
        
        if ([[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"PostedAt"] != (id)[NSNull null]) {
            dateHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[CommonFunctions dateTimeFromString:[[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"PostedAt"]]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0] withinWidth:feedTableView.bounds.size.width-100];
            subtractComponent = subtractComponent + 30;
        }
        
        if ((titleHeight+subTitleHeight+dateHeight) < 90) {
            return 90.0f;
        }
        
        return titleHeight+subTitleHeight+dateHeight-subtractComponent;
    }
    else if (tableView==exploreTableView) {
        
        if ([[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"FeedText"] != (id)[NSNull null]) {
            titleHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"FeedText"]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:14.0] withinWidth:exploreTableView.bounds.size.width];
            subtractComponent = subtractComponent + 30;
        }
        
        if ([[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"HashTag"] != (id)[NSNull null]) {
            subTitleHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"HashTag"]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0] withinWidth:exploreTableView.bounds.size.width];
            subtractComponent = subtractComponent + 30;
        }
        
        if ([[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"PostedAt"] != (id)[NSNull null]) {
            dateHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[CommonFunctions dateTimeFromString:[[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"PostedAt"]]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0] withinWidth:exploreTableView.bounds.size.width];
            subtractComponent = subtractComponent + 30;
        }
        
        
        return titleHeight+subTitleHeight+dateHeight-subtractComponent;
    }
    
    return 0.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //    if (tableView==exploreTableView) {
    //
    //    }
    //    else if (tableView==feedTableView) {
    //
    //    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Report";
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==feedTableView) {
        return feedDataSource.count;
    }
    else if (tableView==exploreTableView) {
        return chatterDataSource.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.backgroundColor = RGB(247, 247, 247);
    
    if (tableView==exploreTableView) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, exploreTableView.bounds.size.width-20, 40)];
        if ([[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"FeedText"] != (id)[NSNull null])
            titleLabel.text = [NSString stringWithFormat:@"%@",[[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"FeedText"]];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = RGB(0,0,0);
        titleLabel.numberOfLines = 0;
        
        CGRect newTitleLabelLabelFrame = titleLabel.frame;
        newTitleLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"FeedText"]] font:titleLabel.font withinWidth:exploreTableView.bounds.size.width];//expectedDescriptionLabelSize.height;
        titleLabel.frame = newTitleLabelLabelFrame;
        [cell.contentView addSubview:titleLabel];
        [titleLabel sizeToFit];
        
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, titleLabel.frame.origin.y+titleLabel.bounds.size.height+5, exploreTableView.bounds.size.width-20, 15)];
        subtitleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:13.0];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.textColor = [UIColor darkGrayColor];
        subtitleLabel.numberOfLines = 0;
        if ([[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"HashTag"] != (id)[NSNull null])
            subtitleLabel.text = [[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"HashTag"];
        
        CGRect newSubTitleLabelLabelFrame = subtitleLabel.frame;
        newSubTitleLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"HashTag"]] font:subtitleLabel.font withinWidth:exploreTableView.bounds.size.width];//expectedDescriptionLabelSize.height;
        subtitleLabel.frame = newSubTitleLabelLabelFrame;
        [cell.contentView addSubview:subtitleLabel];
        [subtitleLabel sizeToFit];
        
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, subtitleLabel.frame.origin.y+subtitleLabel.bounds.size.height+5, exploreTableView.bounds.size.width-20, 15)];
        dateLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:13.0];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textColor = [UIColor darkGrayColor];
        dateLabel.numberOfLines = 0;
        if ([[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"PostedAt"] != (id)[NSNull null])
            dateLabel.text = [CommonFunctions dateTimeFromString:[[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"PostedAt"]];
        
        CGRect newDateLabelLabelFrame = dateLabel.frame;
        newDateLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[CommonFunctions dateTimeFromString:[[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"PostedAt"]]] font:subtitleLabel.font withinWidth:exploreTableView.bounds.size.width];//expectedDescriptionLabelSize.height;
        dateLabel.frame = newDateLabelLabelFrame;
        [cell.contentView addSubview:dateLabel];
        [dateLabel sizeToFit];
        
        
        UIButton *socialButton = [UIButton buttonWithType:UIButtonTypeCustom];
        socialButton.frame = CGRectMake(exploreTableView.bounds.size.width-25, subtitleLabel.frame.origin.y+subtitleLabel.bounds.size.height+5, 15, 15);
        if ([[[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"Media"] intValue] == 1) {
            [socialButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_facebook_whatsup.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else if ([[[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"Media"] intValue] == 2) {
            [socialButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_twitter_whatsup.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else if ([[[chatterDataSource objectAtIndex:indexPath.row] objectForKey:@"Media"] intValue] == 3) {
            [socialButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_instagram_whatsup.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        [cell.contentView addSubview:socialButton];
        
        
        float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, height-1, exploreTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:nil];
        leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
        [cell addGestureRecognizer:leftGesture];
    }
    else if (tableView==feedTableView) {
        
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 70, 70)];
        [cell.contentView addSubview:cellImage];
        
        
        NSString *imageName = [NSString stringWithFormat:@"wu%d.jpg",[[[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"ID"] intValue]];
        NSString *imageURLString = [[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"ImageURL"];
        
        
        NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
        NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Whatsup"]];
        
        NSString *localFile = [destinationPath stringByAppendingPathComponent:imageName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
            
            if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]] != nil)
                cellImage.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]];
            else
                cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
        }
        
        else {
            
            if (imageURLString != (id)[NSNull null]) {
                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator.center = CGPointMake(cellImage.bounds.size.width/2, cellImage.bounds.size.height/2);
                [cellImage addSubview:activityIndicator];
                [activityIndicator startAnimating];
                
                [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
                    if (succeeded) {
                        
                        cellImage.image = image;
                        
                        DebugLog(@"Path %@",destinationPath);
                        
                        NSFileManager *fileManger=[NSFileManager defaultManager];
                        NSError* error;
                        
                        if (![fileManger fileExistsAtPath:destinationPath]){
                            
                            if([[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:&error])
                                ;// success
                            else
                            {
                                DebugLog(@"[%@] ERROR: attempting to write create MyTasks directory", [self class]);
                                NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
                            }
                        }
                        
                        NSData *data = UIImageJPEGRepresentation(image, 0.8);
                        [data writeToFile:[destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]] atomically:YES];
                    }
                    else {
                        DebugLog(@"Image Loading Failed..!!");
                        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
                    }
                    [activityIndicator stopAnimating];
                }];
            }
            else {
                cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
            }
        }
        
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, feedTableView.bounds.size.width-100, 40)];
        if ([[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"FeedText"] != (id)[NSNull null])
            titleLabel.text = [NSString stringWithFormat:@"%@",[[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"FeedText"]];
        titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = RGB(0,0,0);
        titleLabel.numberOfLines = 0;
        [titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGRect newTitleLabelLabelFrame = titleLabel.frame;
        newTitleLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"FeedText"]] font:titleLabel.font withinWidth:exploreTableView.bounds.size.width-100];//expectedDescriptionLabelSize.height;
        titleLabel.frame = newTitleLabelLabelFrame;
        [cell.contentView addSubview:titleLabel];
        [titleLabel sizeToFit];
        
        [cell.contentView addSubview:titleLabel];
        [titleLabel sizeToFit];
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, titleLabel.frame.origin.y+titleLabel.bounds.size.height+5, exploreTableView.bounds.size.width-100, 15)];
        subtitleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:13.0];
        subtitleLabel.backgroundColor = [UIColor clearColor];
        subtitleLabel.textColor = [UIColor darkGrayColor];
        subtitleLabel.numberOfLines = 0;
        if ([[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"HashTag"] != (id)[NSNull null])
            subtitleLabel.text = [[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"HashTag"];
        
        CGRect newSubTitleLabelLabelFrame = subtitleLabel.frame;
        newSubTitleLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"HashTag"]] font:subtitleLabel.font withinWidth:exploreTableView.bounds.size.width-100];//expectedDescriptionLabelSize.height;
        subtitleLabel.frame = newSubTitleLabelLabelFrame;
        [cell.contentView addSubview:subtitleLabel];
        [subtitleLabel sizeToFit];
        
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, subtitleLabel.frame.origin.y+subtitleLabel.bounds.size.height+5, exploreTableView.bounds.size.width-100, 15)];
        dateLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:13.0];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textColor = [UIColor darkGrayColor];
        dateLabel.numberOfLines = 0;
        if ([[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"PostedAt"] != (id)[NSNull null])
            dateLabel.text = [CommonFunctions dateTimeFromString:[[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"PostedAt"]];
        
        CGRect newDateLabelLabelFrame = dateLabel.frame;
        newDateLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[CommonFunctions dateTimeFromString:[[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"PostedAt"]]] font:subtitleLabel.font withinWidth:exploreTableView.bounds.size.width-100];//expectedDescriptionLabelSize.height;
        dateLabel.frame = newDateLabelLabelFrame;
        [cell.contentView addSubview:dateLabel];
        [dateLabel sizeToFit];
        
        
        UIButton *socialButton = [UIButton buttonWithType:UIButtonTypeCustom];
        socialButton.frame = CGRectMake(exploreTableView.bounds.size.width-25, subtitleLabel.frame.origin.y+subtitleLabel.bounds.size.height+5, 15, 15);
        if ([[[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"Media"] intValue] == 1) {
            [socialButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_facebook_whatsup.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else if ([[[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"Media"] intValue] == 2) {
            [socialButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_twitter_whatsup.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else if ([[[feedDataSource objectAtIndex:indexPath.row] objectForKey:@"Media"] intValue] == 3) {
            [socialButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_instagram_whatsup.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        [cell.contentView addSubview:socialButton];
        
        
        float height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, height-1, exploreTableView.bounds.size.width, 0.5)];
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
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"FEED", @"CHATTER", nil];
    
    feedDataSource = [[NSMutableArray alloc] init];
    chatterDataSource = [[NSMutableArray alloc] init];
    
    
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
    
    isShowingFeedTable = YES;
    isShowingChatterTable = NO;
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    
    if (appDelegate.IS_COMING_FROM_DASHBOARD) {

        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
        
        appDelegate.IS_COMING_FROM_DASHBOARD = NO;
        
        if (isDashboardChatter) {
            isShowingChatterTable = YES;
            exploreTableView.hidden = NO;
            
            isShowingFeedTable = NO;
            feedTableView.hidden = YES;
            
            segmentedControl.selectedSegmentIndex = 1;
        }
        else {
            
            isShowingChatterTable = NO;
            exploreTableView.hidden = YES;
            
            isShowingFeedTable = YES;
            feedTableView.hidden = NO;
            
            segmentedControl.selectedSegmentIndex = 0;
        }
    }
    else {
        [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    }
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(247,196,9) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    self.title = @"What's Up";
    
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    appDelegate.hud.labelText = @"Loading...";
    
    [self fetchFeedsAndChatterListing];
    
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
