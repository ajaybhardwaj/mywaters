//
//  UserFloodSubmissionViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 22/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SAMTextView.h"

@interface UserFloodSubmissionViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate> {
    
    AppDelegate *appDelegate;
    UITableView *floodSubmissionTableView;
    
    UITextField *locationField;
    UIImageView *picUploadImageView;
    BOOL isFeedbackImageAvailable;
    
    UIScrollView *backgroundScrollView;
    UIButton *hideKeyPadsButton;
    CLLocationCoordinate2D currentLocation;
    SAMTextView *commentField;
}
@property (nonatomic, strong) NSString *tempLocationString,*tempCommentString;
@property (nonatomic, assign) double floodSubmissionLat,floodSubmissionLon;

@end
