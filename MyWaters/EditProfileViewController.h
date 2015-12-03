//
//  EditProfileViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 23/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CustomButtons.h"
#import "ChangePasswordViewController.h"
#import "AppDelegate.h"

@interface EditProfileViewController : UIViewController <UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    
    AppDelegate *appDelegate;
    
    UITextField *nameField,*emailField;
    UIButton *changePasswordButton,*updateButton,*signoutButton;
    
    UIImageView *profileImageView;
    UITapGestureRecognizer *profileImageTap;
    UILabel *uploadAvatarLabel;
    
    BOOL isProfilePictureSelected,isChangingName;
    
    UIButton *removeKeypadsButton;
}

@end
