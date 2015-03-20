//
//  BookingConfirmationViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 19/3/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "CustomButtons.h"

@interface BookingConfirmationViewController : UIViewController {
    
    UIScrollView *contentBgScrollView;
    UILabel *personDetailsLabel,*bookingDetailsLabel,*contactPersonLabel,*contactPersonValueLabel,*organisationLabel,*organisationValueLabel,*designationLabel,*designationValueLabel,*contactNoLabel,*contactNoValueLabel,*emailLabel,*emailValueLabel,*preferredContactLabel,*preferredContactValueLabel,*dateLabel,*dateValueLabel,*startTimeLabel,*startTimeValueLabel,*endTimeLabel,*endTimeValueLabel,*groupSizeLabel,*groupSizeValueLabel,*categoryLabel,*categoryValueLabel,*firstVisitLabel,*firstVisitValueLabel,*remarksLabel,*remarksValueLabel;
    
    UIButton *doneButton;
}
@property (nonatomic, retain) NSMutableDictionary *dataDict;

@end
