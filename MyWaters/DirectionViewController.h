//
//  DirectionViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 6/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface DirectionViewController : UIViewController <MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate> {
    
    AppDelegate *appDelegate;
    MKMapView *directionMapView;
    
    UITableView *stepsTableView;
    UIBarButtonItem *routesButton;
    
    BOOL isShowingStepsTable;
}
@property (nonatomic, assign) double destinationLat,destinationLong;

@end
