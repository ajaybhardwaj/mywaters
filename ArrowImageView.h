//
//  ArrowImageView.h
//  fitnessChamp
//
//  Created by Admin on 8/4/10.
//  Copyright 2010 fitnessChamp Pte. Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ArrowImageView : UIImageView <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLLocation *currentLocation;
	CLLocationCoordinate2D target;
	CLHeading *currentHeading;
}

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, readwrite) CLLocationCoordinate2D target;



- (BOOL) IsLocationServiceEnabled;
- (BOOL) IsHeadingAvailable;
@end

