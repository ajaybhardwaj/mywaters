//
//  MapOverlayView.m
//  RadarImageExample
//
//  Created by Neon Spark on 3/8/12.
//  Copyright (c) 2012 http://sugartin.info. All rights reserved.
//

#import "MapOverlayView.h"
#import "AppDelegate.h"

@implementation MapOverlayView
@synthesize image;


- (void)drawMapRect:(MKMapRect)mapRect
          zoomScale:(MKZoomScale)zoomScale
          inContext:(CGContextRef)ctx
{

    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@RainArea/rain.zo.png",IMAGE_BASE_URL]]]];//[UIImage imageNamed:@"201509281910.rain.zo.png"];;
            
    MKMapRect theMapRect = [self.overlay boundingMapRect];
    CGRect theRect = [self rectForMapRect:theMapRect];
       
    @try {
        UIGraphicsBeginImageContext(image.size);
        UIGraphicsPushContext(ctx);
        [image drawInRect:theRect];
        UIGraphicsPopContext();
        UIGraphicsEndImageContext();
    }
    @catch (NSException *exception) {
        NSLog(@"Caught an exception while drawing radar on map - %@",[exception description]);
    }
    @finally {
        
    }

}


@end
