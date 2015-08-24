//
//  BadgesViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 11/8/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "BadgesViewController.h"

@interface BadgesViewController ()

@end

@implementation BadgesViewController


//*************** Method To Refresh My Badges ScrollView

- (void) refreshBadgesScrollView {
    
    for (UIView * view in badgesScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    int counter = 0;
    int xAxis = 20;
    int yAxis = 5;
    
    for (int i=0; i<6; i++) {
        
        if (counter==3) {
            
            counter = 1;
            
            UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, yAxis, (self.view.bounds.size.width-75)/4, (self.view.bounds.size.width-75)/4)];
            [badgeImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%d_color.png",appDelegate.RESOURCE_FOLDER_PATH,i+1]]];
            badgeImageView.tag = i+1;
            [badgesScrollView addSubview:badgeImageView];
            
            yAxis = yAxis + 90;
            xAxis = 20;
        }
        else {
            
            UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, yAxis, (self.view.bounds.size.width-75)/4, (self.view.bounds.size.width-75)/4)];
            [badgeImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%d_color.png",appDelegate.RESOURCE_FOLDER_PATH,i+1]]];
            badgeImageView.tag = i+1;
            [badgesScrollView addSubview:badgeImageView];
            
            xAxis = xAxis + (self.view.bounds.size.width-100)/4 + 20;
        }
        
        counter = counter + 1;
        
    }
    
    badgesScrollView.contentSize = CGSizeMake(xAxis, 100);
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    myBadgesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 115, 20)];
    myBadgesLabel.text = @"What are badges?";
    myBadgesLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.5];
    myBadgesLabel.textColor = [UIColor blackColor];
    myBadgesLabel.backgroundColor = [UIColor clearColor];
    myBadgesLabel.numberOfLines = 0;
    [self.view addSubview:myBadgesLabel];
    
    infoIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    infoIconButton.frame = CGRectMake(myBadgesLabel.frame.origin.x+myBadgesLabel.bounds.size.width, 33, 16, 16);
    [infoIconButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_info_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [self.view addSubview:infoIconButton];
    
    badgesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, infoIconButton.frame.origin.y+infoIconButton.bounds.size.height+5, self.view.bounds.size.width, self.view.bounds.size.height-277)];
    badgesScrollView.showsHorizontalScrollIndicator = NO;
    badgesScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:badgesScrollView];
    badgesScrollView.backgroundColor = [UIColor clearColor];
    badgesScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 100);
}

- (void) viewWillAppear:(BOOL)animated {
    
    [self refreshBadgesScrollView];
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
