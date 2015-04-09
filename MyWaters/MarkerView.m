//
//  MarkerView.m
//  Around Me
//
//  Created by jdistler on 11.02.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//

#import "MarkerView.h"

#import "ARGeoCoordinate.h"

const float kWidth = 250.0f;
const float kHeight = 100.0f;

@interface MarkerView ()

@property (nonatomic, strong) UILabel *lblDistance;

@end


@implementation MarkerView

- (id)initWithFrame:(CGRect)frame
{
    
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoordinate:(ARGeoCoordinate *)coordinate delegate:(id<MarkerViewDelegate>)delegate {
    
	if((self = [super initWithFrame:CGRectMake(0.0f, 0.0f, kWidth, kHeight)])) {
		_coordinate = coordinate;
		_delegate = delegate;
		
        appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

		[self setUserInteractionEnabled:YES];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
        backgroundView.backgroundColor = RGB(35, 35, 35);
        backgroundView.layer.cornerRadius = 5.0;
        [self addSubview:backgroundView];
		
		UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, kWidth-90, 60.0f)];
		[title setTextColor:[UIColor whiteColor]];
		[title setText:[coordinate title]];
        title.numberOfLines = 0;
        title.font = [UIFont fontWithName:ROBOTO_MEDIUM size:22.0f];
        title.backgroundColor = [UIColor clearColor];
        
//        UIButton *iconVolly = [UIButton buttonWithType:UIButtonTypeCustom];
//        iconVolly.frame = CGRectMake(210, 30, 40, 40);
//        [iconVolly setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_volly.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
//        [backgroundView addSubview:iconVolly];
//        iconVolly.userInteractionEnabled = NO;
		
		_lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 40.0f, kWidth-90, 40.0f)];
		[_lblDistance setTextColor:[UIColor whiteColor]];
		[_lblDistance setText:[NSString stringWithFormat:@"%.2f km", [coordinate distanceFromOrigin] / 1000.0f]];
        _lblDistance.font = [UIFont fontWithName:ROBOTO_MEDIUM size:18.0f];
        _lblDistance.backgroundColor = [UIColor clearColor];
		
		[backgroundView addSubview:title];
		[backgroundView addSubview:_lblDistance];
		
		[self setBackgroundColor:[UIColor clearColor]];
        
        CGAffineTransform rotationTransform = CGAffineTransformIdentity;
        rotationTransform = CGAffineTransformRotate(rotationTransform, degreesToRadians(90));
        backgroundView.transform = rotationTransform;

	}

	return self;
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
    [[self lblDistance] setText:[NSString stringWithFormat:@"%.2f km", [[self coordinate] distanceFromOrigin] / 1000.0f]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if(_delegate && [_delegate conformsToProtocol:@protocol(MarkerViewDelegate)]) {
		[_delegate didTouchMarkerView:self];
	}
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    CGRect theFrame = CGRectMake(0, 0, kWidth, kHeight);
    
	return CGRectContainsPoint(theFrame, point);
}

@end
