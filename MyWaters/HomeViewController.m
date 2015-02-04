//
//  HomeViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewControllerHelper.h"

@interface HomeViewController ()

@end

@implementation HomeViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Demo App Controls Action Handler

- (void) handleDemoControls:(id) sender {
    
    UIButton *button = (id) sender;
    
    if (button.tag==1) {
        QuickMapViewController *viewObj = [[QuickMapViewController alloc] init];
        viewObj.isNotQuickMapController = YES;
        [self.navigationController pushViewController:viewObj animated:NO];
    }
    else if (button.tag==2) {
        CCTVDetailViewController *viewObj = [[CCTVDetailViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:NO];
    }
    else if (button.tag==3) {
        WhatsUpViewController *viewObj = [[WhatsUpViewController alloc] init];
        viewObj.isNotWhatsUpController = YES;
        [self.navigationController pushViewController:viewObj animated:NO];
    }
    else if (button.tag==4) {
        FeedbackViewController *viewObj = [[FeedbackViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:NO];
    }
}


//*************** Demo App UI

- (void) createDemoAppControls {
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/dashboard.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    quickMapButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    quickMapButton.tag = 1;
    [quickMapButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quickMapButton];
    
    cctvButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cctvButton.tag = 2;
    [cctvButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cctvButton];
    
    whatsUpButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    whatsUpButton.tag = 3;
    [whatsUpButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:whatsUpButton];
    
    reportButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    reportButton.tag = 4;
    [reportButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reportButton];
    
    if (IS_IPHONE_4_OR_LESS) {
        quickMapButton.frame = CGRectMake(10, 75, (self.view.bounds.size.width-30)/2, 105);
        cctvButton.frame = CGRectMake(10, 300, (self.view.bounds.size.width-30)/2, 100);
        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 75, (self.view.bounds.size.width-30)/2, 210);
        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 300, (self.view.bounds.size.width-30)/2, 100);
    }
    else if (IS_IPHONE_5) {
        quickMapButton.frame = CGRectMake(10, 90, (self.view.bounds.size.width-30)/2, 125);
        cctvButton.frame = CGRectMake(10, 360, (self.view.bounds.size.width-30)/2, 130);
        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 90, (self.view.bounds.size.width-30)/2, 260);
        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 360, (self.view.bounds.size.width-30)/2, 130);
    }
    else if (IS_IPHONE_6) {
        quickMapButton.frame = CGRectMake(10, 110, (self.view.bounds.size.width-30)/2, 145);
        cctvButton.frame = CGRectMake(10, 430, (self.view.bounds.size.width-30)/2, 150);
        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 110, (self.view.bounds.size.width-30)/2, 305);
        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 430, (self.view.bounds.size.width-30)/2, 150);
    }
    else if (IS_IPHONE_6P) {
        quickMapButton.frame = CGRectMake(10, 125, (self.view.bounds.size.width-30)/2, 160);
        cctvButton.frame = CGRectMake(10, 480, (self.view.bounds.size.width-30)/2, 165);
        whatsUpButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 125, (self.view.bounds.size.width-30)/2, 335);
        reportButton.frame = CGRectMake(20+(self.view.bounds.size.width-30)/2, 480, (self.view.bounds.size.width-30)/2, 165);
    }
    
}



//*************** Method To Create Specific Corner Round For Views

- (void) setMaskTo:(UIView*)view byRoundingCorners:(UIRectCorner)corners {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
}


- (UIColor*) colorWithHexString:(NSString*)hex {
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


//*************** Method To Create Home Page UI

- (void) createDynamicUIColumns {
    
    for (int i=0; i<appDelegate.DASHBOARD_PREFERENCES_ARRAY.count; i++) {
        if ([[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"status"] isEqualToString:@"1"]) {
            
            if (left_yAxis < right_yAxis) {
                
                UIView *columnView = [[UIView alloc] initWithFrame:CGRectMake(10, left_yAxis, (self.view.bounds.size.width-30)/2, [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"height"] floatValue])];
                columnView.backgroundColor = [UIColor whiteColor];
                columnView.layer.cornerRadius = 10;
                [columnView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
                [columnView.layer setShadowOffset:CGSizeMake(2, 2)];
                [columnView.layer setShadowOpacity:1];
                [columnView.layer setShadowRadius:1.0];
                columnView.tag = [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue];
                [backgroundScrollView addSubview:columnView];
                
                UILabel *columnViewHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, columnView.bounds.size.width, 20)];
                columnViewHeaderLabel.text = [NSString stringWithFormat:@"   %@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"component"]];
                columnViewHeaderLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12];
                columnViewHeaderLabel.textColor = [UIColor whiteColor];
                columnViewHeaderLabel.backgroundColor = [self colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                [columnView addSubview:columnViewHeaderLabel];
                
                [self setMaskTo:columnViewHeaderLabel byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
                
                left_yAxis = left_yAxis + columnView.bounds.size.height + 10;
                
            }
            else {
                
                UIView *columnView = [[UIView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2)+5, right_yAxis, (self.view.bounds.size.width-30)/2, [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"height"] floatValue])];
                columnView.backgroundColor = [UIColor whiteColor];
                columnView.layer.cornerRadius = 10;
                [columnView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
                [columnView.layer setShadowOffset:CGSizeMake(2, 2)];
                [columnView.layer setShadowOpacity:1];
                [columnView.layer setShadowRadius:1.0];
                columnView.tag = [[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"id"] intValue];
                [backgroundScrollView addSubview:columnView];
                
                UILabel *columnViewHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, columnView.bounds.size.width, 20)];
                columnViewHeaderLabel.text = [NSString stringWithFormat:@"   %@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"component"]];
                columnViewHeaderLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12];
                columnViewHeaderLabel.textColor = [UIColor whiteColor];
                columnViewHeaderLabel.backgroundColor = [self colorWithHexString:[NSString stringWithFormat:@"%@",[[appDelegate.DASHBOARD_PREFERENCES_ARRAY objectAtIndex:i] objectForKey:@"color"]]];
                [columnView addSubview:columnViewHeaderLabel];
                
                [self setMaskTo:columnViewHeaderLabel byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
                
                right_yAxis = right_yAxis + columnView.bounds.size.height + 10;
            }
        }
    }
    
    if (right_yAxis > left_yAxis) {
        backgroundScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, right_yAxis+80);
    }
    else {
        backgroundScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, left_yAxis+80);
    }

}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(245, 245, 245);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    
    //    [self createDemoAppControls];
    
    backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    backgroundScrollView.showsHorizontalScrollIndicator = NO;
    backgroundScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:backgroundScrollView];
    backgroundScrollView.backgroundColor = [UIColor clearColor];
    
}

- (void) viewWillAppear:(BOOL)animated {
    
    for (UIView * view in backgroundScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    welcomeView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.bounds.size.width-20, 100)];
    welcomeView.backgroundColor = [UIColor whiteColor];
    welcomeView.layer.cornerRadius = 10;
    [welcomeView.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [welcomeView.layer setShadowOffset:CGSizeMake(2, 2)];
    [welcomeView.layer setShadowOpacity:1];
    [welcomeView.layer setShadowRadius:1.0];
    [backgroundScrollView addSubview:welcomeView];
    
    UILabel *welcomeHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, welcomeView.bounds.size.width, 20)];
    welcomeHeaderLabel.text = @"   Welcome!";
    welcomeHeaderLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12];
    welcomeHeaderLabel.textColor = [UIColor whiteColor];
    welcomeHeaderLabel.backgroundColor = RGB(67, 79, 93);
    [welcomeView addSubview:welcomeHeaderLabel];
    
    [self setMaskTo:welcomeHeaderLabel byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    reportIncidentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reportIncidentButton.frame = CGRectMake(10, welcomeView.frame.origin.y + welcomeView.bounds.size.height + 10, self.view.bounds.size.width-20, 40);
    [reportIncidentButton setBackgroundColor:RGB(242, 47, 56)];
    [reportIncidentButton setTitle:@"Report Incident" forState:UIControlStateNormal];
    reportIncidentButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [reportIncidentButton setTintColor:[UIColor whiteColor]];
    reportIncidentButton.layer.cornerRadius = 10;
    [reportIncidentButton.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    [reportIncidentButton.layer setShadowOffset:CGSizeMake(2, 2)];
    [reportIncidentButton.layer setShadowOpacity:1];
    [reportIncidentButton.layer setShadowRadius:1.0];
    [backgroundScrollView addSubview:reportIncidentButton];
    
    left_yAxis = reportIncidentButton.frame.origin.y + reportIncidentButton.bounds.size.height + 10;
    right_yAxis = reportIncidentButton.frame.origin.y + reportIncidentButton.bounds.size.height + 10.1;
    
    [self createDynamicUIColumns];

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
