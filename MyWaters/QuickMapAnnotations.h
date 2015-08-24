//
//  QuickMapAnnotations.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 17/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface QuickMapAnnotations : NSObject <MKAnnotation>


@property (nonatomic, strong) NSString *title,*subtitle;
@property (nonatomic, assign) NSInteger annotationTag;
@property (nonatomic, assign) double latitude, longitude;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id) initWithTitle:(NSString*)title AndCoordinates:(CLLocationCoordinate2D) coordinate;

@end
