//
//  CustomButtons.h
//  eleAppz 1.0
//
//  Created by Raja
//  Copyright (c) 2012 CSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define BACK_BUTTON_LEFT_MARGIN                                         8
#define BTN_BACK_HEADER_BAR_SIZE                                       25

@interface CustomButtons : NSObject

+(CustomButtons *)sharedInstance;

/*Modified*/
-(UIBarButtonItem *)_PYaddCustomBackButton2Target:(id)target;
-(UIBarButtonItem *)_PYaddCustomSettingsLeftBarButton2Target:(id)target withImg:(UIImage*)leftImage;

-(UIBarButtonItem *)_PYaddCustomSettingsLeftBarButton2Target:(id)target withSelector:(SEL)selector withImg:(UIImage*)leftImage;
-(UIBarButtonItem *)_PYaddCustomRightBarButton2Target:(id)target withSelector:(SEL)selector withIconName:(NSString *)iconName;

/*Original*/
-(UIBarButtonItem *)addCustomBackButton2Target:(id)target;
-(UIBarButtonItem *)addCustomSettingsLeftBarButton2Target:(id)target;

-(UIBarButtonItem *)addCustomRightBarButton2Target:(id)target withSelector:(SEL)selector withIconName:(NSString *)iconName;


@end
