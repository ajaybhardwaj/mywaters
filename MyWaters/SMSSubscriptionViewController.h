//
//  SMSSubscriptionViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 19/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WebViewUrlViewController.h"

@interface SMSSubscriptionViewController : UIViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    
    AppDelegate *appDelegate;
    
    NSArray *idTypeArray;
    UITextField *nameField,*idTypeField,*identificationNumberField,*emailField,*mobileField,*postalCodeField,*locationField;
    UILabel *termsLabel;
    
    UIButton *subscribreButton;
    
    UIToolbar *dropDownToolbar;
    UIPickerView *dropDownPicker;
    UIBarButtonItem *cancelBarButton,*doneBarButton,*flexibleSpace;
    UIView *dropDownBg;
    NSInteger pickerSelectedIndex;
    
    UIView *uiBackgroundView;
    
    BOOL isShowingIDType,isShwoingLocations;
    UILabel *termsOfUseLabel;
}

@property (nonatomic, strong) NSString *wlsID;

@end
