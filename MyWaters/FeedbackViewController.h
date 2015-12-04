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
#import "SAMTextView.h"

@interface FeedbackViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate> {
    
    AppDelegate *appDelegate;
    
    UITableView *feedbackTableView;
    BOOL isFloodSubmission,isShowingPicker;
    
    NSArray *feedbackTypeArray,*severityTypeArray;
    UITextField *feedbackTypeField,*locationField,*nameField,*phoneField,*emailField;
    SAMTextView *commentField;
    
    NSInteger fieldIndex,uploadedImageCount;
    UIView *pickerbackground;
    UIPickerView *feedbackPickerView;
    NSInteger selectedPickerIndex;
    
    UIImageView *picUploadImageView,*uploadedImageView1,*uploadedImageView2,*uploadedImageView3;
    BOOL _moveToBottom;
    UIButton *removeUploadImageButton1,*removeUploadImageButton2,*removeUploadImageButton3;
    
    CLLocationCoordinate2D currentLocation;
    
    //----- New Feedback UI Components
    UIScrollView *backgroundScrollView;
    UIButton *hideKeyPadsButton;
}

@property (nonatomic, assign) BOOL isNotFeedbackController,isReportingForChatter,isEditingComment;
@property (nonatomic, strong) NSString *chatterID,*chatterText;

// Temp String Variables For Table Scroll
@property (nonatomic, strong) NSString *tempLocationString,*tempCommentString,*tempNameString,*tempPhoneString,*tempEmailString;

@end
