//
//  AutoResizeImageView.h
//  fitnessChamp
//
//  Created by Raja on 17/5/13.
//  Copyright (c) 2013 RoomDeck. All rights reserved.
//

#import "AsyncImageView.h"
#import "UIImage+ProportionalFill.h"
@interface AutoResizeImageView : AsyncImageView
@property (nonatomic, assign) MGImageResizingMethod imag_resize_method;
@end
