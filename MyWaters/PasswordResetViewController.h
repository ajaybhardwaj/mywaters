//
//  PasswordResetViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 2/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PasswordResetViewController : UIViewController <UITextFieldDelegate> {
    
    AppDelegate *appDelegate;
    
    UITextField *newPassField,*confirmPassField;
    UIButton *submitButton;
}
@property (nonatomic, strong) NSString *emailString;

@end
