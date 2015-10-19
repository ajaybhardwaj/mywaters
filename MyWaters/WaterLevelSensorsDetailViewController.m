//
//  WaterLevelSensorsDetailViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 14/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "WaterLevelSensorsDetailViewController.h"

@interface WaterLevelSensorsDetailViewController ()

@end

@implementation WaterLevelSensorsDetailViewController
@synthesize wlsID,drainDepthType,latValue,longValue,wlsName,observedTime,waterLevelValue,waterLevelPercentageValue,waterLevelTypeValue,drainDepthValue,isSubscribed;

//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Method To Close Top Menu For Outside Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    
    UITouch *touch = [touches anyObject];
    
    if(touch.view!=topMenu) {
        if (isShowingTopMenu) {
            [self animateTopMenu];
        }
    }
}


//*************** Method To Hide Search Bar Keypad

- (void) hideSearchBarKeypad {
    
    [topSearchBar resignFirstResponder];
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Register User For Flood Alerts

- (void) registerForWLSALerts {
    
    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    appDelegate.hud.labelText = @"Loading...";
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *parameters,*values;

    if (isSubscribed) {
        parameters = [[NSArray alloc] initWithObjects:@"Token",@"SubscriptionType",@"SubscriptionMode",@"WLSAlertLevel",@"WLSID", nil];
        values = [[NSArray alloc] initWithObjects:[prefs stringForKey:@"device_token"],@"2", @"2", @"3", wlsID, nil];
    }
    else {
        
        [self hideAlertOptionsView];
        
        parameters = [[NSArray alloc] initWithObjects:@"Token",@"SubscriptionType",@"SubscriptionMode",@"WLSAlertLevel",@"WLSID", nil];
        values = [[NSArray alloc] initWithObjects:[prefs stringForKey:@"device_token"],@"2", @"1", [NSString stringWithFormat:@"%d",selectedAlertType], wlsID, nil];
    }
    
    [CommonFunctions grabPostRequest:parameters paramtersValue:values delegate:self isNSData:NO baseUrl:[NSString stringWithFormat:@"%@%@",API_BASE_URL,REGISTER_FOR_SUBSCRIPTION]];
}



//************** Method To Handle WLS ALert Options

- (void) handleAlertOptions:(id) sender {
    
    if (sender==level50Button) {
        selectedAlertType = 1;
        [level50Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_selected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [level75Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [level90Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [level100Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if (sender==level75Button) {
        selectedAlertType = 2;
        [level50Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [level75Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_selected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [level90Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [level100Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if (sender==level90Button) {
        selectedAlertType = 3;
        [level50Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [level75Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [level90Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_selected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [level100Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
    else if (sender==level100Button) {
        selectedAlertType = 4;
        [level50Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [level75Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [level90Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [level100Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_selected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
}


//*************** Method To HIDE Alert Options Popup

- (void) hideAlertOptionsView {
    
    dimmedImageView.hidden = YES;
    
    alertOptionsView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        alertOptionsView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        [alertOptionsView removeFromSuperview];
        notifiyButton.userInteractionEnabled = YES;
    }];
}



//*************** Method To Create Alert Options Popup

- (void) createAlertOptions {
    
    notifiyButton.userInteractionEnabled = NO;
    
    alertOptionsView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, self.view.bounds.size.height/2-150, 200, 300)];
    alertOptionsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:alertOptionsView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(alertOptionsView.bounds.size.width-20, -5, 25, 25);
    [closeButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_cross.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hideAlertOptionsView) forControlEvents:UIControlEventTouchUpInside];
    [alertOptionsView addSubview:closeButton];

    UILabel *headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, alertOptionsView.bounds.size.width-30, 20)];
    headingLabel.text = @"Subscribe To iAlerts";
    headingLabel.backgroundColor = [UIColor clearColor];
    headingLabel.textColor = RGB(52,158,240);
    headingLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:15.0];
    [alertOptionsView addSubview:headingLabel];
    
    level50Button = [UIButton buttonWithType:UIButtonTypeCustom];
    level50Button.frame = CGRectMake(20, headingLabel.frame.origin.y+headingLabel.bounds.size.height+35, 25, 25);
    [level50Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_selected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    level50Button.tag = 1;
    [level50Button addTarget:self action:@selector(handleAlertOptions:) forControlEvents:UIControlEventTouchUpInside];
    [alertOptionsView addSubview:level50Button];
    
    UILabel *level50 = [[UILabel alloc] initWithFrame:CGRectMake(60, headingLabel.frame.origin.y+headingLabel.bounds.size.height+35, alertOptionsView.bounds.size.width-70, 20)];
    level50.text = @"Water Level >= 50%";
    level50.backgroundColor = [UIColor clearColor];
    level50.textColor = RGB(0,0,0);
    level50.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
    [alertOptionsView addSubview:level50];
    
    level75Button = [UIButton buttonWithType:UIButtonTypeCustom];
    level75Button.frame = CGRectMake(20, level50.frame.origin.y+level50.bounds.size.height+20, 25, 25);
    [level75Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    level75Button.tag = 2;
    [level75Button addTarget:self action:@selector(handleAlertOptions:) forControlEvents:UIControlEventTouchUpInside];
    [alertOptionsView addSubview:level75Button];
    
    UILabel *level75 = [[UILabel alloc] initWithFrame:CGRectMake(60, level50.frame.origin.y+level50.bounds.size.height+20, alertOptionsView.bounds.size.width-70, 20)];
    level75.text = @"Water Level >= 75%";
    level75.backgroundColor = [UIColor clearColor];
    level75.textColor = RGB(0,0,0);
    level75.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
    [alertOptionsView addSubview:level75];
    
    level90Button = [UIButton buttonWithType:UIButtonTypeCustom];
    level90Button.frame = CGRectMake(20, level75.frame.origin.y+level75.bounds.size.height+20, 25, 25);
    [level90Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    level90Button.tag = 3;
    [level90Button addTarget:self action:@selector(handleAlertOptions:) forControlEvents:UIControlEventTouchUpInside];
    [alertOptionsView addSubview:level90Button];
    
    UILabel *level90 = [[UILabel alloc] initWithFrame:CGRectMake(60, level75.frame.origin.y+level75.bounds.size.height+20, alertOptionsView.bounds.size.width-70, 20)];
    level90.text = @"Water Level >= 90%";
    level90.backgroundColor = [UIColor clearColor];
    level90.textColor = RGB(0,0,0);
    level90.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
    [alertOptionsView addSubview:level90];
    
    level100Button = [UIButton buttonWithType:UIButtonTypeCustom];
    level100Button.frame = CGRectMake(20, level90.frame.origin.y+level90.bounds.size.height+20, 25, 25);
    [level100Button setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/wls_radio_unselected.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    level100Button.tag = 4;
    [level100Button addTarget:self action:@selector(handleAlertOptions:) forControlEvents:UIControlEventTouchUpInside];
    [alertOptionsView addSubview:level100Button];
    
    UILabel *level100 = [[UILabel alloc] initWithFrame:CGRectMake(60, level90.frame.origin.y+level90.bounds.size.height+20, alertOptionsView.bounds.size.width-70, 20)];
    level100.text = @"Water Level = 100%";
    level100.backgroundColor = [UIColor clearColor];
    level100.textColor = RGB(0,0,0);
    level100.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
    [alertOptionsView addSubview:level100];
    
    
    UIButton *subscribeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [subscribeButton setTitle:@"SUBSCRIBE" forState:UIControlStateNormal];
    [subscribeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    subscribeButton.titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:14];
    subscribeButton.frame = CGRectMake(10, level100.frame.origin.y+level100.bounds.size.height+30, alertOptionsView.bounds.size.width-20, 40);
    [subscribeButton setBackgroundColor:RGB(68, 78, 98)];
    [subscribeButton addTarget:self action:@selector(registerForWLSALerts) forControlEvents:UIControlEventTouchUpInside];
    [alertOptionsView addSubview:subscribeButton];
    
    dimmedImageView.hidden = NO;
    
    alertOptionsView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        alertOptionsView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // do something once the animation finishes, put it here
    }];
    
}



//*************** Method To Animate Top Menu

- (void) animateTopMenu {
    
    if (isShowingTopMenu) {
        
        isShowingTopMenu = NO;
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint topMenuPos = topMenu.center;
        topMenuPos.y = -140;
        topMenu.center = topMenuPos;
        [UIView commitAnimations];
    }
    else {
        
        isShowingTopMenu = YES;
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint topMenuPos = topMenu.center;
        topMenuPos.y = 22;
        topMenu.center = topMenuPos;
        [UIView commitAnimations];
    }
}



//*************** Method To Move To Map Direction View

- (void) moveToDirectionView {
    
    if (isShowingTopMenu) {
        [self animateTopMenu];
    }
    
    DirectionViewController *viewObj = [[DirectionViewController alloc] init];
    viewObj.destinationLat = latValue;
    viewObj.destinationLong = longValue;
    [self.navigationController pushViewController:viewObj animated:YES];
}



//*************** Method To Add WLS To Favourites

- (void) addWLSToFavourites {
    
    [self animateTopMenu];
    
    NSMutableDictionary *parametersDict = [[NSMutableDictionary alloc] init];
    
    [parametersDict setValue:wlsID forKey:@"fav_id"];
    [parametersDict setValue:@"4" forKey:@"fav_type"];
    [parametersDict setValue:wlsName forKey:@"name"];
    [parametersDict setValue:@"NA" forKey:@"image"];
    [parametersDict setValue:[NSString stringWithFormat:@"%f",latValue] forKey:@"lat"];
    [parametersDict setValue:[NSString stringWithFormat:@"%f",latValue] forKey:@"long"];
    [parametersDict setValue:@"NA" forKey:@"address"];
    [parametersDict setValue:@"NA" forKey:@"phoneno"];
    [parametersDict setValue:@"NA" forKey:@"description"];
    [parametersDict setValue:@"NA" forKey:@"start_date_event"];
    [parametersDict setValue:@"NA" forKey:@"end_date_event"];
    [parametersDict setValue:@"NA" forKey:@"website_event"];
    [parametersDict setValue:@"NA" forKey:@"isCertified_ABC"];
    
    
    if (waterLevelValue != (id)[NSNull null] && [waterLevelValue length] !=0)
        [parametersDict setValue:waterLevelValue forKey:@"water_level_wls"];
    else
        [parametersDict setValue:@"NA" forKey:@"water_level_wls"];
    
    if (drainDepthValue != (id)[NSNull null] && [drainDepthValue length] !=0)
        [parametersDict setValue:drainDepthValue forKey:@"drain_depth_wls"];
    else
        [parametersDict setValue:@"NA" forKey:@"drain_depth_wls"];
    
    if (waterLevelPercentageValue != (id)[NSNull null] && [waterLevelPercentageValue length] !=0)
        [parametersDict setValue:waterLevelPercentageValue forKey:@"water_level_percentage_wls"];
    else
        [parametersDict setValue:@"NA" forKey:@"water_level_percentage_wls"];
    
    if (waterLevelTypeValue != (id)[NSNull null] && [waterLevelTypeValue length] !=0)
        [parametersDict setValue:waterLevelTypeValue forKey:@"water_level_type_wls"];
    else
        [parametersDict setValue:@"NA" forKey:@"water_level_type_wls"];
    
    if (observedTime != (id)[NSNull null] && [observedTime length] !=0)
        [parametersDict setValue:observedTime forKey:@"observation_time_wls"];
    else
        [parametersDict setValue:@"NA" forKey:@"observation_time_wls"];
    
    [appDelegate insertFavouriteItems:parametersDict];
    
    isAlreadyFav = [appDelegate checkItemForFavourite:@"4" idValue:wlsID];
    
    if (isAlreadyFav)
        [addToFavButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_fav.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    else
        [addToFavButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
}


//*************** Method To Create Top Menu

- (void) createTopMenu {
    
    //Top Menu Item
    
    topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, -140, self.view.bounds.size.width, 45)];
    topMenu.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:topMenu];
    
    
    //    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, (topMenu.bounds.size.width/2)-10, 35)];
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, (topMenu.bounds.size.width/2)+30, 35)];
    searchField.textColor = RGB(35, 35, 35);
    searchField.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    searchField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    searchField.leftViewMode = UITextFieldViewModeAlways;
    searchField.borderStyle = UITextBorderStyleNone;
    searchField.textAlignment=NSTextAlignmentLeft;
    [searchField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    searchField.placeholder = @"Search...";
    searchField.layer.borderWidth = 0.5;
    searchField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [topMenu addSubview:searchField];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.delegate = self;
    searchField.keyboardType = UIKeyboardTypeEmailAddress;
    searchField.backgroundColor = [UIColor whiteColor];
    searchField.returnKeyType = UIReturnKeyNext;
    [searchField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    //    //    iAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+10, 40, (topMenu.bounds.size.width/2)/3, 10)];
    //    iAlertLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2), 32, (topMenu.bounds.size.width/2)/3, 10)];
    //    iAlertLabel.backgroundColor = [UIColor clearColor];
    //    iAlertLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    //    iAlertLabel.text = @"iAlert";
    //    iAlertLabel.textAlignment = NSTextAlignmentCenter;
    //    iAlertLabel.textColor = [UIColor whiteColor];
    //    [topMenu addSubview:iAlertLabel];
    //
    //    alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    //    alertButton.frame = CGRectMake((topMenu.bounds.size.width/2)+10, 10, 25, 25);
    //    alertButton.frame = CGRectMake((topMenu.bounds.size.width/2)/3/2 - 10 + (topMenu.bounds.size.width/2), 5, 20, 20);
    //    [alertButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_ialert_disabled.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    //    [alertButton addTarget:self action:@selector(animateTopMenu) forControlEvents:UIControlEventTouchUpInside];
    //    [topMenu addSubview:alertButton];
    
    
    //    addToFavLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)-1.5, 40, (topMenu.bounds.size.width/2)/3, 10)];
    addToFavLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+(topMenu.bounds.size.width/2)/3, 32, (topMenu.bounds.size.width/2)/3, 10)];
    addToFavLabel.backgroundColor = [UIColor clearColor];
    addToFavLabel.textAlignment = NSTextAlignmentCenter;
    addToFavLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    addToFavLabel.text = @"Add To Fav";
    addToFavLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:addToFavLabel];
    
    addToFavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    addToFavButton.frame = CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)+15, 10, 25, 25);
    addToFavButton.frame = CGRectMake((topMenu.bounds.size.width/2)/3/2 - 10 + (topMenu.bounds.size.width/2)+(topMenu.bounds.size.width/2)/3, 5, 20, 20);
    if (isAlreadyFav)
        [addToFavButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_fav.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    else
        [addToFavButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];    [addToFavButton addTarget:self action:@selector(addWLSToFavourites) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:addToFavButton];
    
    
    //    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)*2+2, 40, (topMenu.bounds.size.width/2)/3, 10)];
    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/2)+(topMenu.bounds.size.width/2)/3+(topMenu.bounds.size.width/2)/3, 32, (topMenu.bounds.size.width/2)/3, 10)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.textAlignment = NSTextAlignmentCenter;
    refreshLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    refreshLabel.text = @"Refresh";
    refreshLabel.textColor = [UIColor whiteColor];
    [topMenu addSubview:refreshLabel];
    
    refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    refreshButton.frame = CGRectMake((topMenu.bounds.size.width/2)+((topMenu.bounds.size.width/2)/3)*2+18, 10, 25, 25);
    refreshButton.frame = CGRectMake((topMenu.bounds.size.width/2)/3/2 - 10 + (topMenu.bounds.size.width/2)+(topMenu.bounds.size.width/2)/3+(topMenu.bounds.size.width/2)/3, 5, 20, 20);
    [refreshButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_refresh_cctv.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(animateTopMenu) forControlEvents:UIControlEventTouchUpInside];
    [topMenu addSubview:refreshButton];
    
}


//*************** Method For Creating UI

- (void) createUI {
    
    for (UIView * view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    notifiyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    notifiyButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    [notifiyButton setBackgroundColor:[UIColor lightGrayColor]];
    [notifiyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (isSubscribed) {
        [notifiyButton setTitle:@"UNSUBSCRIBE ME" forState:UIControlStateNormal];
        [notifiyButton addTarget:self action:@selector(registerForWLSALerts) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [notifiyButton setTitle:@"NOTIFY ME" forState:UIControlStateNormal];
        [notifiyButton addTarget:self action:@selector(createAlertOptions) forControlEvents:UIControlEventTouchUpInside];
    }
    notifiyButton.titleLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:16];
    [self.view addSubview:notifiyButton];
    
    topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-100, notifiyButton.frame.origin.y+notifiyButton.bounds.size.height+30, 80, 80)];
    [self.view addSubview:topImageView];
    
    riskLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, notifiyButton.frame.origin.y+notifiyButton.bounds.size.height+30, self.view.bounds.size.width/2 -30, 60)];
    riskLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:17];
    riskLabel.textColor = [UIColor blackColor];//RGB(26, 158, 241);
    riskLabel.backgroundColor = [UIColor clearColor];
    riskLabel.numberOfLines = 0;
    [self.view addSubview:riskLabel];
    
    if (drainDepthType==1) {
        riskLabel.text = @"Low Flood Risk";
        [topImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_below75_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else if (drainDepthType==2) {
        riskLabel.text = @"Moderate Flood Risk";
        [topImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_75-90_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else if (drainDepthType==3) {
        riskLabel.text = @"High Flood Risk";
        [topImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_90_big.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    else {
        riskLabel.text = @"Under Maintenance";
        [topImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_undermaintenance.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    [riskLabel sizeToFit];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, riskLabel.frame.origin.y+riskLabel.bounds.size.height+5, self.view.bounds.size.width/2 -50, 35)];
    timeLabel.text = observedTime;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.numberOfLines = 0;
    timeLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
    [self.view addSubview:timeLabel];

    
    depthValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, timeLabel.frame.origin.y+timeLabel.bounds.size.height+5, self.view.bounds.size.width/2 -10, 15)];
    depthValueLabel.backgroundColor = [UIColor clearColor];
    depthValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.0];
    depthValueLabel.textColor = [UIColor darkGrayColor];//RGB(26, 158, 241);
    [self.view addSubview:depthValueLabel];
    

    if (drainDepthType==1) {
        depthValueLabel.text = @"Drain Below 75% Full";
    }
    else if (drainDepthType==2) {
        depthValueLabel.text = @"Drain 75%-90% Full";
    }
    else if (drainDepthType==3) {
        depthValueLabel.text = @"Drain Above 90% Full";
    }
    else {
        depthValueLabel.text = @"";
    }
    
    directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    directionButton.frame = CGRectMake(0, topImageView.frame.origin.y+topImageView.bounds.size.height, self.view.bounds.size.width, 40);
    directionButton.frame = CGRectMake(0, 200, self.view.bounds.size.width, 40);
    [directionButton setBackgroundColor:[UIColor whiteColor]];
    [directionButton addTarget:self action:@selector(moveToDirectionView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:directionButton];
    
    directionIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 22, 22)];
    [directionIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_directions_blue.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [directionButton addSubview:directionIcon];
    
    
    cctvTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, directionButton.bounds.size.width-140, 40)];
    cctvTitleLabel.backgroundColor = [UIColor whiteColor];
    cctvTitleLabel.textAlignment = NSTextAlignmentLeft;
    cctvTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    cctvTitleLabel.text = wlsName;
    cctvTitleLabel.numberOfLines = 0;
    [directionButton addSubview:cctvTitleLabel];
    
    
    //----- Change Current Location With Either Current Location Value or Default Location Value
    
    CLLocationCoordinate2D currentLocation;
    CLLocationCoordinate2D desinationLocation;
    
    currentLocation.latitude = appDelegate.CURRENT_LOCATION_LAT;
    currentLocation.longitude = appDelegate.CURRENT_LOCATION_LONG;
    
    desinationLocation.latitude = latValue;
    desinationLocation.longitude = longValue;
    
    distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(directionButton.bounds.size.width-130, 0, 100, 40)];
    distanceLabel.backgroundColor = [UIColor clearColor];
    distanceLabel.textAlignment = NSTextAlignmentRight;
    distanceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14];
    distanceLabel.text = [NSString stringWithFormat:@"%@ KM",[CommonFunctions kilometersfromPlace:currentLocation andToPlace:desinationLocation]];
    [directionButton addSubview:distanceLabel];
    
    arrowIcon = [[UIImageView alloc] initWithFrame:CGRectMake(directionButton.bounds.size.width-20, 12.5, 15, 15)];
    [arrowIcon setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_arrow_grey.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [directionButton addSubview:arrowIcon];
    
    
    wlsListingTable = [[UITableView alloc] initWithFrame:CGRectMake(0, directionButton.frame.origin.y+directionButton.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-(directionButton.bounds.size.height+topImageView.bounds.size.height+64))];
    wlsListingTable.delegate = self;
    wlsListingTable.dataSource = self;
    [self.view addSubview:wlsListingTable];
    wlsListingTable.backgroundColor = [UIColor clearColor];
    wlsListingTable.backgroundView = nil;
    wlsListingTable.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //    [cctvListingTable reloadData];
    
    dimmedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [dimmedImageView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
    [self.view addSubview:dimmedImageView];
    dimmedImageView.hidden = YES;
    
    [self createTopMenu];

}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    DebugLog(@"%@",responseString);
    [appDelegate.hud hide:YES];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [notifiyButton setTitle:@"UNSUBSCRIBE ME" forState:UIControlStateNormal];
        isSubscribed = YES;
        [CommonFunctions showAlertView:self title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
    
    [appDelegate.hud hide:YES];
}



# pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.navigationController popViewControllerAnimated:YES];
}



# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}



# pragma mark - UITableViewDelegate Methods


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section==0) {
        
        UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        sectionLabel.text = @"    Nearby";
        sectionLabel.textColor = RGB(51, 149, 255);
        sectionLabel.backgroundColor = RGB(234, 234, 234);
        sectionLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
        
        return sectionLabel;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (isShowingTopMenu) {
        [self animateTopMenu];
    }
    
    
    wlsID = [[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    wlsName = [[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    drainDepthType = [[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue];
    latValue = [[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"latitude"] doubleValue];
    longValue = [[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"longitude"] doubleValue];
    observedTime = [CommonFunctions dateTimeFromString:[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"observationTime"]];
    waterLevelValue = [NSString stringWithFormat:@"%d",[[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"waterLevel"] intValue]];
    waterLevelPercentageValue = [NSString stringWithFormat:@"%d",[[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"waterLevelPercentage"] intValue]];
    waterLevelTypeValue = [NSString stringWithFormat:@"%d",[[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue]];
    drainDepthValue = [NSString stringWithFormat:@"%d",[[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"drainDepth"] intValue]];
    isSubscribed = [[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"isSubscribed"] intValue];
    
    [self createUI];
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!appDelegate.IS_COMING_FROM_DASHBOARD) {
        return 3;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    
    cell.backgroundColor = RGB(247, 247, 247);
    
    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    if ([[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue] == 1) {
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_below75_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if ([[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue] == 2) {
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_75-90_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if ([[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue] == 3) {
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_90_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if ([[[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"waterLevelType"] intValue] == 4){
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_undermaintenance.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    [cell.contentView addSubview:cellImage];
    
    
    UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, wlsListingTable.bounds.size.width-90, 50)];
    cellTitleLabel.text = [[tempNearByArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cellTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    cellTitleLabel.backgroundColor = [UIColor clearColor];
    cellTitleLabel.numberOfLines = 0;
    [cell.contentView addSubview:cellTitleLabel];
    
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59.5, wlsListingTable.bounds.size.width, 0.5)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];
    
    
    return cell;
}



# pragma mark - UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (searchBar==topSearchBar) {
        
        if ([topSearchBar.text length]!=0) {
            
            [topSearchBar resignFirstResponder];
            
            CLGeocoder *fwdGeocoding = [[CLGeocoder alloc] init];
            DebugLog(@"Geocoding for Address: %@\n", searchBar.text);
            [fwdGeocoding geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
                if (!error) {
                    // do stuff with the placemarks
                    
                    for (CLPlacemark *placemark in placemarks) {
                        DebugLog(@"%@\n %.2f,%.2f",[placemark description], placemark.location.horizontalAccuracy, placemark.location.verticalAccuracy);
                    }
                } else {
                    DebugLog(@"Geocoding error: %@", [error localizedDescription]);
                }
            }];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    
    if (searchBar==topSearchBar) {
        
        topSearchBar.text = @"";
        [topSearchBar resignFirstResponder];
    }
}



# pragma mark - MKMapViewDelegate Methods


-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
    
    MKAnnotationView *pinView = nil;
    
    if(annotation != wateLevelMapView.userLocation) {
        
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[wateLevelMapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        if ( pinView == nil )
            pinView = [[MKAnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
        pinView.canShowCallout = YES;
        pinView.image = [UIImage imageNamed:@"icn_waterlevel_75-90.png"];
    }
    else {
        [wateLevelMapView.userLocation setTitle:@"You are here..!!"];
    }
    return pinView;
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Water Level Sensor";
    self.view.backgroundColor = RGB(247, 247, 247);
    
    selectedAlertType = 1;
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    isAlreadyFav = [appDelegate checkItemForFavourite:@"4" idValue:wlsID];

    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateTopMenu) withIconName:@"icn_3dots.png"]];
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
    if (!appDelegate.IS_COMING_FROM_DASHBOARD) {
    tempNearByArray = appDelegate.WLS_LISTING_ARRAY;
    
    NSSortDescriptor *sortByDistance = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES comparator:^(id left, id right) {
        float v1 = [left floatValue];
        float v2 = [right floatValue];
        if (v1 < v2)
            return NSOrderedAscending;
        else if (v1 > v2)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    }];
    
    [tempNearByArray sortUsingDescriptors:[NSArray arrayWithObjects:sortByDistance,nil]];
    }
    [self createUI];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(52,158,240) frame:CGRectMake(0, 0, 1, 1)];
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
