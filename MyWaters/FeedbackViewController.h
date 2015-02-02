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
    BOOL isFloodSubmission;
    
    NSArray *feedbackTypeArray,*severityTypeArray;
    UITextField *cellTextField;
    
    NSInteger fieldIndex;
    UIView *pickerbackground;
    UIPickerView *feedbackPickerView;
}

@end
