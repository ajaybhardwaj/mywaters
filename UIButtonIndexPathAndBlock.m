//
//  UIButtonWithIndexPath.m
//  SuperSportsClub
//
//  Created by Raja on 16/2/14.
//  Copyright (c) 2014 RoomDeck. All rights reserved.
//

#import "UIButtonIndexPathAndBlock.h"


@implementation UIButtonIndexPathAndBlock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(ActionBlock) action
{
    _actionBlock = Block_copy(action);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

-(void) callActionBlock:(id)sender{
    _actionBlock();
}

-(void)dealloc{
    Block_release(_actionBlock);
    [_indexPath release]; _indexPath = nil;
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
