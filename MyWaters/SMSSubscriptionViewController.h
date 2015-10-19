//
//  SMSSubscriptionViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 19/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SMSSubscriptionViewController : UIViewController <UITextFieldDelegate> {
    
    AppDelegate *appDelegate;
    
    UITextField *nameField,*idTypeField,*identificationNumberField,*emailField,*mobileField,*postalCodeField;
    UILabel *termsLabel;
    
    UIButton *subscribreButton;
}

@end
