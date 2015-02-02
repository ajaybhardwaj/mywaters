//
//  ArrowImageView.m
//  fitnessChamp
//
//  Created by Admin on 8/4/10.
//  Copyright 2010 fitnessChamp Pte. Ltd.. All rights reserved.
//

#define degreesToRadians(x) (M_PI * x / 180.0)
#import "ArrowImageView.h"


@implementation ArrowImageView

@synthesize locationManager;
@synthesize target;


- (void)dealloc {
	
	[locationManager stopUpdatingHeading];
	[locationManager stopUpdatingLocation];
	[locationManager release];
	locationManager = nil;
	
	[super dealloc];
}

#pragma mark -

- (float)bearingFromPoint:(CLLocationCoordinate2D)fromPoint toPoint:(CLLocationCoordinate2D)toPoint
{ 
	
	float deltaY = fromPoint.longitude - toPoint.longitude;
	
	float deltaX = fromPoint.latitude - toPoint.latitude;
	
	float radians = atan2(deltaY, deltaX);
	
	if (radians < M_PI) {
		radians += M_PI;
	}
	
	return radians;
	
}


#pragma mark -
- (id)initWithCoder:(NSCoder *)aDecoder {
	// RDLog(@"arrow image view awakeFromNib");
	if (self = [super initWithCoder:aDecoder]) {
		
		self.userInteractionEnabled = YES;
		
		self.hidden = YES;
		currentLocation = nil;
		currentHeading = nil;
		
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		
		if (![self IsHeadingAvailable]) {
			self.locationManager = nil;
			self.image = nil;
			
		} else {
			
			if([self IsLocationServiceEnabled]){
				locationManager.headingFilter = kCLHeadingFilterNone;
				
				locationManager.delegate = self;
				
				[locationManager startUpdatingLocation];
				[locationManager startUpdatingHeading];

			}else {
				self.locationManager = nil;
				self.image = nil;
			}
		}

	}
	
	return self;
}

- (id)initWithImage:(UIImage *)image {

	if (self = [super initWithImage:image]) {

		self.userInteractionEnabled = YES;
		
		self.hidden = YES;
		currentLocation = nil;
		currentHeading = nil;
		
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
		//RDLog(@"Initiating");
		if (![self IsHeadingAvailable]) 
		{
			self.locationManager = nil;
			self.image = nil;
		//	RDLog(@"Heading Not Available");
		} else {
			
			if([self IsLocationServiceEnabled]){
				locationManager.headingFilter = kCLHeadingFilterNone;
				
				locationManager.delegate = self;
				
				[locationManager startUpdatingLocation];
				[locationManager startUpdatingHeading];
				//RDLog(@"Location Manager started to update heading");
			}else {
				self.locationManager = nil;
				self.image = nil;
				//RDLog(@"Location Service not enabled");
			}
		}
		
	}
	
	return self;
}



- (BOOL) IsLocationServiceEnabled{
	if ([CLLocationManager respondsToSelector:@selector(locationServicesEnabled)]){
		if ([CLLocationManager locationServicesEnabled]) {
			return YES;
		}else {
			return NO;
		}
	}else{
		//if (locationManager.locationServicesEnabled) {
    if ([CLLocationManager locationServicesEnabled]) {
			return YES;
		}else {
			return NO;
		}
	}
}

- (BOOL) IsHeadingAvailable{
	if ([CLLocationManager respondsToSelector:@selector(headingAvailable)]){
		if ([CLLocationManager headingAvailable]) {
			return YES;
		}else {
			return NO;
		}
	}else{
		if ([CLLocationManager locationServicesEnabled]) {
			return YES;
		}else {
			return NO;
		}
	}
}

#pragma mark -  -
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
	currentLocation = [newLocation copy];

	//RDLog(@"lat: %f, long: %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading 
{
	currentHeading = [newHeading retain];
	
	if (currentHeading != nil && currentLocation != nil){
		self.hidden = NO;
	}
	
	float radiansToNorth = degreesToRadians(newHeading.magneticHeading);
	float bearingToTarget = [self bearingFromPoint:currentLocation.coordinate toPoint:self.target];
	CGAffineTransform transform = CGAffineTransformMakeRotation(bearingToTarget - radiansToNorth);
	self.transform = transform;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error 
{
	if ( [error code] == kCLErrorDenied ) {
		[manager stopUpdatingHeading];
	} else if ([error code] == kCLErrorHeadingFailure) {
        // This error indicates that the heading could not be determined, most likely because of strong magnetic interference.
    }
}



/*-(BOOL)locationManagerShouldDisplayHeadingCalibration : (CLLocationManager *)manager {
	
    //do stuff
	
    return YES;
}*/

@end
