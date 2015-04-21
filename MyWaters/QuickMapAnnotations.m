//
//  QuickMapAnnotations.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 17/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "QuickMapAnnotations.h"

@implementation QuickMapAnnotations
//@synthesize coordinate = _coordinate;
//@synthesize title = _title;
//@synthesize subtitle = _subtitle;

@synthesize title,subtitle,coordinate;

- (id) initWithTitle:(NSString *)title AndCoordinates:(CLLocationCoordinate2D)coordinate {
    
    self = [super init];
//    _title = title;
//    _coordinate = coordinate;
    
    return self;
}

@end
