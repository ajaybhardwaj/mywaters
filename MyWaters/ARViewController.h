//
//  ARViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 17/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ARKit.h"
#import "AppDelegate.h"
#import "Place.h"
#import "ARGeoCoordinate.h"
#import "UILabel + Extension.h"

@interface ARViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, ARLocationDelegate, ARDelegate, ARMarkerDelegate, UINavigationControllerDelegate> {
    
    AppDelegate *appDelegate;
    UIScrollView *overlayScrollview;
    
    NSArray *pictureDataSource;
}

@property (weak, nonatomic) MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, strong) MKUserLocation *userLocation;

@end
