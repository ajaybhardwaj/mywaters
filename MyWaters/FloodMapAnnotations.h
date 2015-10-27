//
//  FloodMapAnnotations.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 27/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FloodMapAnnotations : NSObject <MKAnnotation>


@property (nonatomic, strong) NSString *annotationTitle,*annotationSubtitle,*annotationType,*annotationImageName;
@property (nonatomic, strong) NSString *title,*subtitle;
@property (nonatomic, assign) NSInteger annotationTag,waterLevel;
@property (nonatomic, assign) double latitude, longitude;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id) initWithTitle:(NSString *)title AndCoordinates:(CLLocationCoordinate2D)coordinate type:(NSString*)annotationType tag:(NSInteger)annotationTag subtitleValue:(NSString*) subtitle level:(NSInteger) waterLevel image:(NSString*) imageName;
//+ (MKAnnotationView *)createViewCCTVAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;



@end
