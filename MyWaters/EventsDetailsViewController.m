//
//  EventsDetailsViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 29/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "EventsDetailsViewController.h"
#import "AppDelegate.h"

@implementation EventsDetailsViewController


//*************** Demo App UI

- (void) createDemoAppControls {
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/events_detail_options.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
}


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void) animateTopMenu {
    
    if (isShowingTopMenu) {
        
        isShowingTopMenu = NO;
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint topMenuPos = topMenu.center;
        topMenuPos.y = -30;
        topMenu.center = topMenuPos;
        [UIView commitAnimations];
    }
    else {
        
        isShowingTopMenu = YES;
        
        [UIView beginAnimations:@"topMenu" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint topMenuPos = topMenu.center;
        topMenuPos.y = 28;
        topMenu.center = topMenuPos;
        [UIView commitAnimations];
    }
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"EVENT INFO";
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(animateTopMenu) withIconName:@"icn_3dots"]];
    
    [self createDemoAppControls];

    
    //Top Menu Item
    
    topMenu = [[UIView alloc] initWithFrame:CGRectMake(0, -60, self.view.bounds.size.width, 55)];
    topMenu.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topMenu];
    
    notifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    notifyButton.frame = CGRectMake((topMenu.bounds.size.width/3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 10, 25, 25);
    [notifyButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_notifyme.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [topMenu addSubview:notifyButton];
    
    favouritesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    favouritesButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*2)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 10, 25, 25);
    [favouritesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_addtofavorites.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [topMenu addSubview:favouritesButton];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(((topMenu.bounds.size.width/3)*3)-(topMenu.bounds.size.width/3)+(topMenu.bounds.size.width/3)/2 - 12.5, 10, 25, 25);
    [shareButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_share.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [topMenu addSubview:shareButton];
    
    notifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, topMenu.bounds.size.width/3, 10)];
    notifyLabel.backgroundColor = [UIColor clearColor];
    notifyLabel.textAlignment = NSTextAlignmentCenter;
    notifyLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    notifyLabel.text = @"Notify Me";
    [topMenu addSubview:notifyLabel];
    
    addToFavlabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3), 40, topMenu.bounds.size.width/3, 10)];
    addToFavlabel.backgroundColor = [UIColor clearColor];
    addToFavlabel.textAlignment = NSTextAlignmentCenter;
    addToFavlabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    addToFavlabel.text = @"Add To Favourite";
    [topMenu addSubview:addToFavlabel];
    
    shareLabel = [[UILabel alloc] initWithFrame:CGRectMake((topMenu.bounds.size.width/3)*2, 40, topMenu.bounds.size.width/3, 10)];
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10];
    shareLabel.text = @"Share";
    [topMenu addSubview:shareLabel];
}



@end
