//
//  UILabel + Extension.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 20/3/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "UILabel + Extension.h"
#import "AppDelegate.h"

@implementation UILabel___Extension

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    
    AppDelegate *appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self = [super initWithFrame:frame];
    if (self) {
        if (appdelegate.IS_ARVIEW_CUSTOM_LABEL) {
            self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        else {
            self.edgeInsets = UIEdgeInsetsMake(0, 40, 0, 20);
        }
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.width  += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return size;
}

@end
