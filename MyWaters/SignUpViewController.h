//
//  SignUpViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 9/2/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "OTPViewController.h"

@interface SignUpViewController : UIViewController <UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    AppDelegate *appDelegate;
    
    UIScrollView *backgroundScrollView;
    
    UIButton *facebookButton,*checkboxButton,*signUpButton,*termsButton,*skipButton,*backButton;
    UITextField *emailField,*nameField,*passField,*retypePassField;
    UILabel *uploadAvatarLabel;
    
    UIImageView *profileImageView;
    
    BOOL isTermsAgree,isProfilePictureSelected;
    UITapGestureRecognizer *profileImageTap;
}

@end
