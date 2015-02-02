//
//  UIButtonWithIndexPath.h
//  SuperSportsClub
//
//  Created by Raja on 16/2/14.
//  Copyright (c) 2014 RoomDeck. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)();
@interface UIButtonIndexPathAndBlock : UIButton
{
    ActionBlock _actionBlock;
}
@property (nonatomic, retain) NSIndexPath *indexPath;
-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(ActionBlock) action;

@end
