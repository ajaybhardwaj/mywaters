//
//  FeedbackViewController.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FeedbackViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    
    AppDelegate *appDelegate;
    
    UITableView *feedbackTableView;
    BOOL isFloodSubmission,isShowingPicker;
    
    NSArray *feedbackTypeArray,*severityTypeArray;
    UITextField *feedbackTypeField,*locationField,*commentField,*nameField,*phoneField;
    
    NSInteger fieldIndex;
    UIView *pickerbackground;
    UIPickerView *feedbackPickerView;
    NSInteger selectedPickerIndex;
}

@property (nonatomic, assign) BOOL isNotFeedbackController;

@end
