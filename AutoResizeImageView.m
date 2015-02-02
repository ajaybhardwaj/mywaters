//
//  AutoResizeImageView.m
//  fitnessChamp
//
//  Created by Raja on 17/5/13.
//  Copyright (c) 2013 RoomDeck. All rights reserved.
//

#import "AutoResizeImageView.h"
#import "ViewControllerHelper.h"
#import "AppDelegate.h"


@implementation AutoResizeImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setImage:(UIImage *)image_tofit{
    CGSize imag_size = self.frame.size;
    [super setImage:[image_tofit imageToFitSize:imag_size method:_imag_resize_method]];
    //RDLog(@"\n\n -- asyncImage Setting image here -- !! ");
}

@end
