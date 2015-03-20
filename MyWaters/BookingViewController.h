//
//  BookingViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BookingConfirmationViewController.h"

@interface BookingViewController : UIViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate> {
    
    AppDelegate *appDelegate;
    
    UIScrollView *bgScrollView;
    UITextField *contactPersonField,*organisationField,*designationField,*contactNoField,*emailField,*dateField,*startTimeField,*endTimeField,*groupSizeField,*categoryField,*ageRangeField;
    
    UIButton *smsContactMethodButton,*emailContactMethodButton,*firstVisitYesButton,*firstVisitNoButton;
    UIButton *nextButton,*submitButton;
    UITextView *remarksTextView;
    
    UILabel *preferredContactLabel,*smsLabel,*emailLabel,*firstVisitLabel,*yesLabel,*noLabel;
    
    BOOL isEmailOpted,isSMSOpted,isFirstVisit;
    
    UIDatePicker *datePicker;
    UIPickerView *optionsPicker;
    
    UIView *datePickerBgView, *optionsPickerBgView;
    BOOL isShowingDatePicker,isShowingOptionsPicker;
    NSInteger fieldIndex,selectedPickerIndex,selectedDesignationIndex,selectedCategoryIndex;
    NSArray *designationDataSource,*categoryDataSource;
    
    BOOL canDetectGesture,isStartTimeSet,isEndTimeSet;
    NSDateFormatter *formatter;
    NSDate *selectedDate,*selectedStartTime,*selectedEndTime;
}

@end
