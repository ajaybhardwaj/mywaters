//
//  OTPViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 28/9/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ChangePasswordViewController.h"
#import "PasswordResetViewController.h"

@interface OTPViewController : UIViewController <UITextFieldDelegate> {
    
    AppDelegate *appDelegate;
    UITextField *otpField1,*otpField2,*otpField3,*otpField4,*otpField5,*otpField6;
    
    UIButton *submitButton,*resendOTPButton,*backButton;
    UILabel *instructionLabel;
    
    BOOL isVerifyingEmail,isResendingOTP;
}
@property (nonatomic, strong) NSString *emailStringForVerification;
@property (nonatomic, assign) BOOL isResettingPassword,isValidatingEmail;
@end
