//
//  ShowImageView.h
//  NParks
//
//  Created by fitnessChamp on 2/6/12.
//  Copyright (c) 2012 fitnessChamp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowImageViewDelegate <NSObject>

@optional
-(void)addPhotoClicked:(id)sender;
-(void)cancelPhotoClicked:(id)sender;

@end

@interface ShowImageView : UIView

@property (nonatomic, retain) UIImageView *showImg;
@property (nonatomic, retain) UIToolbar *toolButtons;
@property (nonatomic, assign) id <ShowImageViewDelegate> delegate;

@end
