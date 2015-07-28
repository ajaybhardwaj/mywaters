//
//  SideMenuOptionsViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 21/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "SideMenuOptionsViewController.h"

@interface SideMenuOptionsViewController ()

@end

@implementation SideMenuOptionsViewController
@synthesize optionsTableView;



//*************** Method To Hide Menu

- (void) dismissOverlayMenu {
    
    //***** Animation Code Added to remove the menu form top view
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = optionsTableView.center;
    if (IS_IPHONE_4_OR_LESS) {
        pos.x = -110;
    }
    else if (IS_IPHONE_5) {
        pos.x = -110;
    }
    else if (IS_IPHONE_6) {
        pos.x = -115;
    }
    else if (IS_IPHONE_6P) {
        pos.x = -115;
    }
    optionsTableView.center = pos;
    [UIView commitAnimations];
    
    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
    appDelegate.left_deck_width = self.view.bounds.size.width-180;

    if (appDelegate.SELECTED_MENU_ID==0) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:HOME_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
    else if (appDelegate.SELECTED_MENU_ID==1) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:NOTIFICATIONS_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
    else if (appDelegate.SELECTED_MENU_ID==2) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:PROFILE_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
    else if (appDelegate.SELECTED_MENU_ID==3) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:FAVOURITES_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
    else if (appDelegate.SELECTED_MENU_ID==4) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:WHATSUP_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
    else if (appDelegate.SELECTED_MENU_ID==5) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:FLOODMAP_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
    else if (appDelegate.SELECTED_MENU_ID==6) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:ABCWATERS_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
    else if (appDelegate.SELECTED_MENU_ID==7) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:EVENTS_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
    else if (appDelegate.SELECTED_MENU_ID==8) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:CCTV_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
    else if (appDelegate.SELECTED_MENU_ID==9) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:WLS_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
    else if (appDelegate.SELECTED_MENU_ID==10) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:BOOKING_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
    else if (appDelegate.SELECTED_MENU_ID==11) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:FEEDBACK_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
    else if (appDelegate.SELECTED_MENU_ID==12) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:SETTINGS_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
    else if (appDelegate.SELECTED_MENU_ID==13) {
        [[ViewControllerHelper viewControllerHelper] enableThisController:ABOUT_PUB_CONTROLLER onCenter:TRUE withAnimate:NO];
    }
}


//*************** Custom Cell Method For Side Menu Options

- (UITableViewCell *) customizeTableCell:(UITableViewCell *)cell{
    
    UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [iconImg setTag:900];
//    [iconImg setBackgroundColor:RGB(210, 255, 77)];
    [iconImg setBackgroundColor:RGB(232, 233, 232)];
    [iconImg setContentMode:UIViewContentModeCenter];
    [iconImg setUserInteractionEnabled:YES];
    [cell.contentView addSubview:iconImg];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.view.bounds.size.width-40, 44)];
    [lbl setTag:901];
    [lbl setBackgroundColor:[UIColor clearColor]];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = [UIFont fontWithName:SIDE_MENU_CELL_FONT size:10.0f];
//    [lbl setShadowColor:[UIColor darkGrayColor]];
//    [lbl setShadowOffset:CGSizeMake(0, 1)];
    [lbl setNumberOfLines:1];
    [cell.contentView addSubview:lbl];
    
    return cell;
}


//*************** Method For Loading Table DataSource

- (void) load_TableData {
    
    NSMutableArray *_options_array = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSDictionary *section0 = [NSDictionary dictionaryWithObjectsAndKeys:@"Menu",CELL__SECTION_HEADER_TEXT,[NSArray arrayWithObjects:
                                                                                                           
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Home",CELL__MAIN_TXT,@"icn_home",CELL__IMG, nil],
                               
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Notifications",CELL__MAIN_TXT,@"icn_notifications",CELL__IMG, nil],
                                                                                                
                               [NSDictionary dictionaryWithObjectsAndKeys:@"My Profile",CELL__MAIN_TXT,@"icn_profile",CELL__IMG, nil],
                                
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Favourites",CELL__MAIN_TXT,@"icn_favourites",CELL__IMG, nil],

                               [NSDictionary dictionaryWithObjectsAndKeys:@"What's Up?",CELL__MAIN_TXT,@"icn_whatsup",CELL__IMG, nil],
                               
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Quick Map",CELL__MAIN_TXT,@"icn_quickmap",CELL__IMG, nil],
                               
                               [NSDictionary dictionaryWithObjectsAndKeys:@"ABC Waters",CELL__MAIN_TXT,@"icn_abcwaters",CELL__IMG, nil],
                               
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Events",CELL__MAIN_TXT,@"icn_events",CELL__IMG, nil],
                                                                                                           
                               [NSDictionary dictionaryWithObjectsAndKeys:@"CCTV",CELL__MAIN_TXT,@"icn_cctv",CELL__IMG, nil],
                                                                                                        
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Water Level Sensor",CELL__MAIN_TXT,@"icn_wls",CELL__IMG, nil],
                               
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Booking",CELL__MAIN_TXT,@"icn_booking",CELL__IMG, nil],
                               
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Feedback",CELL__MAIN_TXT,@"icn_feedback",CELL__IMG, nil],
                               
                               [NSDictionary dictionaryWithObjectsAndKeys:@"Settings",CELL__MAIN_TXT,@"icn_settings",CELL__IMG, nil],
                                                                                                           
                                [NSDictionary dictionaryWithObjectsAndKeys:@"About PUB",CELL__MAIN_TXT,@"icn_about_pub",CELL__IMG, nil],

                               nil],TABLE__SECTION_ARRAY, nil];
    
    
    [_options_array addObject:section0];
    [self setOptionsArray:(NSArray*)_options_array];
}




# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //***** Animation Code Added to remove the menu form top view
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pos = optionsTableView.center;
    if (IS_IPHONE_4_OR_LESS) {
        pos.x = -110;
    }
    else if (IS_IPHONE_5) {
        pos.x = -110;
    }
    else if (IS_IPHONE_6) {
        pos.x = -115;
    }
    else if (IS_IPHONE_6P) {
        pos.x = -115;
    }
    optionsTableView.center = pos;
    [UIView commitAnimations];
    
    appDelegate.SELECTED_MENU_ID = indexPath.row;

    switch (indexPath.section) {
            
        case 0:
            
            switch (indexPath.row) {


                case OPTION_HOME:{
                    
                    // -- Get the user detail if he signed in..
                    //                    if (![[SharedObject sharedClass] isSSCUserSignedIn])
                    //                    {
                    //                        [[AuxilaryService auxFunctions] showWC_AlertDelegate:nil msg:@"SignIn/SignUp" title:nil cancelTitle:@"Close" otherTitle: nil];
                    //                        break;
                    //                    }
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;
                    [[ViewControllerHelper viewControllerHelper] enableThisController:HOME_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                    
                }
                    break;
                    
                case NOTIFICATIONS_CONTROLLER:{
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;
                    [[ViewControllerHelper viewControllerHelper] enableThisController:NOTIFICATIONS_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                }
                    break;
                    
                case PROFILE_CONTROLLER:{
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;
                    [[ViewControllerHelper viewControllerHelper] enableThisController:PROFILE_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                }
                    break;
                    
                    
                case FAVOURITES_CONTROLLER:{
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;
                    [[ViewControllerHelper viewControllerHelper] enableThisController:FAVOURITES_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                }
                    break;
                    
                case WHATSUP_CONTROLLER:{
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;
                    [[ViewControllerHelper viewControllerHelper] enableThisController:WHATSUP_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                }
                    break;
                    
                case FLOODMAP_CONTROLLER:{
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;
                    [[ViewControllerHelper viewControllerHelper] enableThisController:FLOODMAP_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                }
                    break;
                    
                case ABCWATERS_CONTROLLER:{

                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;
                    
                    [[ViewControllerHelper viewControllerHelper] enableThisController:ABCWATERS_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                }
                    break;
                    
                case EVENTS_CONTROLLER:{
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;

                    [[ViewControllerHelper viewControllerHelper] enableThisController:EVENTS_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                }
                    break;
                    
                case CCTV_CONTROLLER:{
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;
                    
                    [[ViewControllerHelper viewControllerHelper] enableThisController:CCTV_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                }
                    break;
                    
                case WLS_CONTROLLER:{
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;
                    
                    [[ViewControllerHelper viewControllerHelper] enableThisController:WLS_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                }
                    break;
                    
                    
                case BOOKING_CONTROLLER:{
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;

                    [[ViewControllerHelper viewControllerHelper] enableThisController:BOOKING_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                }
                    break;
                    
                case FEEDBACK_CONTROLLER:{
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;
                    [[ViewControllerHelper viewControllerHelper] enableThisController:FEEDBACK_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                }
                    break;
                    
                    
                case SETTINGS_CONTROLLER:{
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;
                    [[ViewControllerHelper viewControllerHelper] enableThisController:SETTINGS_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                }
                    break;
                    
                    
                case ABOUT_PUB_CONTROLLER:{
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;
                    [[ViewControllerHelper viewControllerHelper] enableThisController:ABOUT_PUB_CONTROLLER onCenter:TRUE withAnimate:NO];
                    
                }
                    break;
                    
                    
                default: {
                    
                    [[appDelegate rootDeckController] closeLeftView]; // -- close left view if is opened.. already.
                    appDelegate.left_deck_width = self.view.bounds.size.width-180;
                }
                    break;
            }
            break;
            
            
        case 1:
        {
            UITableViewCell *cell = (UITableViewCell*)[optionsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]]; // -- on;y section ZERO is assigned for other controllers
            
            NSString *cell_String = [[cell textLabel] text];
            cell_String = [cell_String stringByReplacingOccurrencesOfString:@" " withString:@""];
            cell_String = [cell_String stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            cell_String = [cell_String uppercaseString];
            
            if ([cell_String isEqualToString:@"SIGNIN"]) {
                
//                [[appDelegate rootDeckController] closeRightView]; // -- clos right view if is opened.. already.
//                [[ViewControllerHelper viewControllerHelper] enableThisController:SIGN_IN_CONTROLLER onCenter:TRUE withAnimate:NO];
                
            }
            else{
                
//                [[AuxilaryService auxFunctions] showWC_AlertDelegate:self msg:@"Are you sure?" title:@"Sign Out" cancelTitle:@"Cancel" otherTitle:@"Ok", nil];
            }
        }
            break;
            
            
        default:
            break;
    }
}



# pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // -- ACCORDING TO MOCK UP 2 SECTIONS
    return [_optionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    // - according to mock up
    return [[[_optionsArray objectAtIndex:section] objectForKey:TABLE__SECTION_ARRAY] count];
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"options-%ld-%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectedBackgroundView = nil;
        cell.backgroundColor = RGB(232, 233, 232);

        cell = [self customizeTableCell:cell];
        
    }
    
    NSString *lblTxt = [[[[_optionsArray objectAtIndex:indexPath.section] objectForKey:TABLE__SECTION_ARRAY] objectAtIndex:indexPath.row] objectForKey:CELL__MAIN_TXT];
    NSString *imagTxt = [[[[_optionsArray objectAtIndex:indexPath.section] objectForKey:TABLE__SECTION_ARRAY] objectAtIndex:indexPath.row] objectForKey:CELL__IMG];
    
    // Configure the cell...
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //    [cell.textLabel setNumberOfLines:0];
    
    
    UILabel *lbl = (UILabel *)[cell.contentView viewWithTag:901];
    [lbl setText:lblTxt];
    
    [lbl setFont:[UIFont fontWithName:ROBOTO_MEDIUM size:14.5]];
    [lbl setTextColor:RGB(83, 83, 83)];
    
    UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:900];
    [img setImage:[UIImage imageNamed:imagTxt]];
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43.6, cell.bounds.size.width, 0.4)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];

    
    return cell;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self load_TableData];
    
    
    UIButton *dismissMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissMenuButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [dismissMenuButton addTarget:self action:@selector(dismissOverlayMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissMenuButton];
    
    
    optionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(-200, 0, self.view.bounds.size.width-150, self.view.bounds.size.height)];
//    optionsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    optionsTableView.delegate = self;
    optionsTableView.dataSource = self;
    [self.view addSubview:optionsTableView];
    optionsTableView.backgroundColor = RGB(245, 245, 245);
    optionsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [optionsTableView.layer setOpaque:NO];
    [optionsTableView setOpaque:NO];
    
    [self setCurrentIndex:_currentIndex];
    [optionsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - reset

- (void) resetDataSource {

//    [self setUserDictionary:nil];
//    [super resetDataSource];
}

- (void) resetView {
    
//    [[self popOverHolder] setDelegate:nil];
//    [self setPopOverHolder:nil];
//    
//    
//    [self setMainTable:nil];
//    [self setFooterView:nil];
//    [self setOptionsArray:nil];
//    [self setMainTable_background:nil];
//    [self setSignOutView:nil];
    
//    [super resetView];
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
