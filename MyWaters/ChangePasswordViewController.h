//
//  ChangePasswordViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 23/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButtons.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface ChangePasswordViewController : UIViewController <UITextFieldDelegate> {
    
    UITextField *currentPassField,*newPassField,*confirmPassField;
    UIButton *submitButton;
    
    AppDelegate *appDelegate;
}

@end
