//
//  OTPViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 28/9/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface OTPViewController : UIViewController <UITextFieldDelegate> {
    
    AppDelegate *appDelegate;
    UITextField *otpField1,*otpField2,*otpField3,*otpField4,*otpField5,*otpField6;
    
    UIButton *submitButton,*resendOTPButton;
    UILabel *instructionLabel;
}

@end
