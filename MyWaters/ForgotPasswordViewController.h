//
//  ForgotPasswordViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 10/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ForgotPasswordViewController : UIViewController <UITextFieldDelegate> {
    
    AppDelegate *appDelegate;
    UITextField *emailField;
    UIButton *submitButton,*backButton;
}

@end
