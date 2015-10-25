//
//  LongPressUserLocationViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 22/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "QuickMapAnnotations.h"

@interface LongPressUserLocationViewController : UIViewController <MKMapViewDelegate> {
    
    AppDelegate *appDelegate;
    MKMapView *userLocMapView;
    
    QuickMapAnnotations *longPressLocationAnnotation;
}

@end
