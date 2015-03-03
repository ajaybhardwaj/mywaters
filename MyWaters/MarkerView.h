//
//  MarkerView.h
//  Around Me
//
//  Created by jdistler on 11.02.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class ARGeoCoordinate;
@protocol MarkerViewDelegate;

@interface MarkerView : UIView {
    
    AppDelegate *appDelegate;
}

@property (nonatomic, strong) ARGeoCoordinate *coordinate;
@property (nonatomic, weak) id <MarkerViewDelegate> delegate;
- (id)initWithCoordinate:(ARGeoCoordinate *)coordinate delegate:(id<MarkerViewDelegate>)delegate;

@end

@protocol MarkerViewDelegate <NSObject>

- (void)didTouchMarkerView:(MarkerView *)markerView;

@end
