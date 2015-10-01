//
//  CustomAnnotationView.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 30/9/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "AppDelegate.h"

@implementation CustomAnnotationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)drawRect:(CGRect)rect
{
    // used to draw the rounded background box and pointer
    QuickMapAnnotations *mapItem = (QuickMapAnnotations *)self.annotation;
    if (mapItem != nil)
    {
        [[UIColor darkGrayColor] setFill];
        
        // draw the pointed shape
        UIBezierPath *pointShape = [UIBezierPath bezierPath];
        [pointShape moveToPoint:CGPointMake(14.0, 0.0)];
        [pointShape addLineToPoint:CGPointMake(0.0, 0.0)];
        [pointShape addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height)];
        [pointShape fill];
        
        // draw the rounded box
        UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:
                                     CGRectMake(10.0,
                                                0.0,
                                                self.frame.size.width - 10.0,
                                                self.frame.size.height)
                                                               cornerRadius:3.0];
        roundedRect.lineWidth = 2.0;
        [roundedRect fill];
    }
}


- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        if ([reuseIdentifier isEqualToString:@"CCTV"]) {
            
            QuickMapAnnotations *mapItem = (QuickMapAnnotations*)self.annotation;
            
            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

            self.centerOffset = CGPointMake(50.0, 50.0);

            UIView *calloutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 100)];
            
            UIImageView *locationNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
            [locationNameImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/callout_icn_location_grey.png",appDelegate.RESOURCE_FOLDER_PATH]]];
            [calloutView addSubview:locationNameImageView];
            
            UIImageView *distanceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 27, 20, 20)];
            [distanceImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/callout_icn_distance.png",appDelegate.RESOURCE_FOLDER_PATH]]];
            [calloutView addSubview:distanceImageView];
            
            
            UIView *calloutView2 = [[UIView alloc] initWithFrame:CGRectMake(30, 0, 150, 100)];
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
            titleLabel.backgroundColor = [UIColor redColor];
            titleLabel.text = mapItem.annotationTitle;
            titleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12.0];
            titleLabel.numberOfLines = 0;
            [calloutView2 addSubview:titleLabel];
            
            UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 150, 50)];
            subTitleLabel.backgroundColor = [UIColor greenColor];
            subTitleLabel.text = mapItem.annotationSubtitle;
            subTitleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:10.0];
            subTitleLabel.numberOfLines = 0;
            [calloutView2 addSubview:subTitleLabel];
            
            
            self.leftCalloutAccessoryView = calloutView;
            self.rightCalloutAccessoryView = calloutView2;
            
            
            //[self addSubview:calloutView];
        }
    }
    
    return self;
}


@end
