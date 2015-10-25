//
//  FeedbackViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "Base64.h"
#import "LongPressUserLocationViewController.h"

@interface FeedbackViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    AppDelegate *appDelegate;
    
    UITableView *feedbackTableView;
    BOOL isFloodSubmission,isShowingPicker;
    
    NSArray *feedbackTypeArray,*severityTypeArray;
    UITextField *feedbackTypeField,*locationField,*nameField,*phoneField,*emailField;
    UITextView *commentField;
    
    NSInteger fieldIndex;
    UIView *pickerbackground;
    UIPickerView *feedbackPickerView;
    NSInteger selectedPickerIndex;
    
    UIImageView *picUploadImageView;
    BOOL isFeedbackImageAvailable;
    
    CLLocationCoordinate2D currentLocation;
}

@property (nonatomic, assign) BOOL isNotFeedbackController;

// Temp String Variables For Table Scroll
@property (nonatomic, strong) NSString *tempLocationString,*tempCommentString,*tempNameString,*tempPhoneString,*tempEmailString;

@end
