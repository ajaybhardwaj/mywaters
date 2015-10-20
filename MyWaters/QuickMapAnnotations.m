//
//  QuickMapAnnotations.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 17/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "QuickMapAnnotations.h"
#import "CustomAnnotationView.h"

@implementation QuickMapAnnotations

@synthesize coordinate = _coordinate;
@synthesize annotationTitle = _annotationTitle;
@synthesize annotationSubtitle = _annotationSubtitle;
@synthesize annotationType = _annotationType;
@synthesize annotationTag = _annotationTag;
@synthesize waterLevel = _waterLevel;
@synthesize annotationImageName = _annotationImageName;

@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (id) initWithTitle:(NSString *)title AndCoordinates:(CLLocationCoordinate2D)coordinate type:(NSString*)annotationType tag:(NSInteger)annotationTag subtitleValue:(NSString*) subtitle level:(NSInteger) waterLevel image:(NSString*) imageName {
    
    self = [super init];
    _title = title;
    _coordinate = coordinate;
    _annotationType = annotationType;
    _annotationTag = annotationTag;
    _subtitle = subtitle;
    _annotationTitle = title;
    _annotationSubtitle = subtitle;
    _waterLevel = waterLevel;
    _annotationImageName = imageName;
    
    return self;
}


//+ (MKAnnotationView *)createViewCCTVAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation {
//    
//    MKAnnotationView *returnedAnnotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CCTV"];
//    if (returnedAnnotationView == nil)
//    {
//        returnedAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CCTV"];
//    }
//    
//    return returnedAnnotationView;
//}


@end
