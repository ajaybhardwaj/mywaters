//
//  ShowImageView.m
//  NParks
//
//  Created by fitnessChamp on 2/6/12.
//  Copyright (c) 2012 fitnessChamp. All rights reserved.
//

#import "ShowImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface ShowImageView()
-(void)addPhotoClickedP:(id)sender;
-(void)cancelPhotoClickedP:(id)sender;
@end

@implementation ShowImageView
@synthesize showImg, toolButtons;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {

        // Initialization code
        [self setBackgroundColor:[UIColor blackColor]];
        //[self setAlpha:0.85];
        
        // -- Create image view
        UIImageView *avatarImg_ = [[UIImageView alloc] initWithFrame:CGRectMake(0,30,320,300)];
        [avatarImg_ setBackgroundColor:[UIColor clearColor]];
        [avatarImg_ setContentMode:UIViewContentModeScaleAspectFit];
        avatarImg_.layer.cornerRadius = 5;
        [self addSubview:avatarImg_];
        [self bringSubviewToFront:avatarImg_];
        [self setShowImg:avatarImg_];
        [avatarImg_ release];
        avatarImg_ = nil;
        
        // -- tool bar items to add images
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, frame.size.height-44, 320, 44)];
        [toolbar setBarStyle:UIBarStyleBlackTranslucent];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPhotoClickedP:)];
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addPhotoClickedP:)];
        
        NSArray *buttonsArray = [NSArray arrayWithObjects:backBtn,flexSpace,doneBtn, nil];
        [backBtn release];
        [doneBtn release];
        [flexSpace release];
        [toolbar setItems:buttonsArray];
        [self setToolButtons:toolbar];
        [self addSubview:toolbar];
        [toolbar release];
        toolbar = nil;
        
//        [self.layer setMasksToBounds:TRUE];
//        self.layer.cornerRadius = 10;
        
    }
    
    return self;
}

#pragma mark - Private method to solve image



#pragma mark - Button Clicks
-(void)addPhotoClickedP:(id)sender{
  
  //RDLog(@"\n\n %s \n",__FUNCTION__);
  
    if ([delegate respondsToSelector:@selector(addPhotoClicked:)]) {
        [delegate addPhotoClicked:[[self showImg] image]];
    }
}
                                    
-(void)cancelPhotoClickedP:(id)sender{
  
  //RDLog(@"\n\n %s \n",__FUNCTION__);
  
    if ([delegate respondsToSelector:@selector(cancelPhotoClicked:)]) {
        [delegate cancelPhotoClicked:nil];
    }
 
}


-(void)dealloc{
    self.showImg = nil;
    self.toolButtons = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
