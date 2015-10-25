//
//  UserFloodSubmissionViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 22/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserFloodSubmissionViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    
    AppDelegate *appDelegate;
    UITableView *floodSubmissionTableView;
    
    UITextField *locationField;
    UITextView *commentField;
    UIImageView *picUploadImageView;
    BOOL isFeedbackImageAvailable;
    
    CLLocationCoordinate2D currentLocation;
}
@property (nonatomic, strong) NSString *tempLocationString,*tempCommentString;
@property (nonatomic, assign) double floodSubmissionLat,floodSubmissionLon;

@end
