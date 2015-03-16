//
//  BookingViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "BookingViewController.h"
#import "ViewControllerHelper.h"


@interface BookingViewController ()

@end

@implementation BookingViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}



//*************** Method To Move To Second Part Of Form

- (void) slideToSecondPart {
    
    [bgScrollView setContentOffset:CGPointMake(self.view.bounds.size.width, 0) animated:YES];
}


//*************** Method To Opt For Preferred Contact Mode

- (void) selectContactModes:(id) sender {
    
    UIButton *button = (id) sender;
    if (button.tag==1) {
        if (isSMSOpted) {
            isSMSOpted = NO;
            [smsContactMethodButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/checkbox_untick.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else {
            isSMSOpted = YES;
            [smsContactMethodButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/tick.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
    }
    else if (button.tag==2) {
        if (isEmailOpted) {
            isEmailOpted = NO;
            [emailContactMethodButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/checkbox_untick.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
        else {
            isEmailOpted = YES;
            [emailContactMethodButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/tick.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        }
    }
}


//*************** Method To Opt For First Visit Options

- (void) selectFirstVisitOption:(id) sender {
    
    UIButton *button = (id) sender;
    if (button.tag==1) {
        isFirstVisit = YES;
        [firstVisitYesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/tick.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [firstVisitNoButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/checkbox_untick.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];

    }
    else if (button.tag==2) {
        isFirstVisit = NO;
        [firstVisitYesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/checkbox_untick.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [firstVisitNoButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/tick.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    }
}


//*************** Method To Flush And Create UI

- (void) createBookingForm {
    
    contactPersonField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, bgScrollView.bounds.size.width, 40)];
    contactPersonField.textColor = RGB(35, 35, 35);
    contactPersonField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    contactPersonField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    contactPersonField.leftViewMode = UITextFieldViewModeAlways;
    contactPersonField.borderStyle = UITextBorderStyleNone;
    contactPersonField.textAlignment=NSTextAlignmentLeft;
    [contactPersonField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    contactPersonField.placeholder=@"Contact Person *";
    [bgScrollView addSubview:contactPersonField];
    contactPersonField.clearButtonMode = UITextFieldViewModeWhileEditing;
    contactPersonField.delegate = self;
    contactPersonField.backgroundColor = [UIColor whiteColor];
    contactPersonField.returnKeyType = UIReturnKeyNext;
    [contactPersonField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    contactPersonField.tag = 1;
    
    organisationField = [[UITextField alloc] initWithFrame:CGRectMake(0, contactPersonField.frame.origin.y+contactPersonField.bounds.size.height+2, bgScrollView.bounds.size.width, 40)];
    organisationField.textColor = RGB(35, 35, 35);
    organisationField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    organisationField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    organisationField.leftViewMode = UITextFieldViewModeAlways;
    organisationField.borderStyle = UITextBorderStyleNone;
    organisationField.textAlignment=NSTextAlignmentLeft;
    [organisationField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    organisationField.placeholder=@"Organisation";
    [bgScrollView addSubview:organisationField];
    organisationField.clearButtonMode = UITextFieldViewModeWhileEditing;
    organisationField.delegate = self;
    organisationField.backgroundColor = [UIColor whiteColor];
    organisationField.returnKeyType = UIReturnKeyNext;
    [organisationField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    organisationField.tag = 2;
    
    designationField = [[UITextField alloc] initWithFrame:CGRectMake(0, organisationField.frame.origin.y+organisationField.bounds.size.height+2, bgScrollView.bounds.size.width, 40)];
    designationField.textColor = RGB(35, 35, 35);
    designationField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    designationField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    designationField.leftViewMode = UITextFieldViewModeAlways;
    designationField.borderStyle = UITextBorderStyleNone;
    designationField.textAlignment=NSTextAlignmentLeft;
    [designationField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    designationField.placeholder=@"Designation *";
    [bgScrollView addSubview:designationField];
    designationField.clearButtonMode = UITextFieldViewModeWhileEditing;
    designationField.delegate = self;
    designationField.backgroundColor = [UIColor whiteColor];
    designationField.returnKeyType = UIReturnKeyNext;
    [designationField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    designationField.tag = 3;
    
    UIButton *designationDropdown = [UIButton buttonWithType:UIButtonTypeCustom];
    designationDropdown.frame = CGRectMake(designationField.bounds.size.width-30, 12.5, 15, 15);
    [designationDropdown setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_arrow_down_field.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    designationDropdown.tag = 1;
    [designationField addSubview:designationDropdown];
    designationDropdown.userInteractionEnabled = NO;

    
    contactNoField = [[UITextField alloc] initWithFrame:CGRectMake(0, designationField.frame.origin.y+designationField.bounds.size.height+2, bgScrollView.bounds.size.width, 40)];
    contactNoField.textColor = RGB(35, 35, 35);
    contactNoField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    contactNoField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    contactNoField.leftViewMode = UITextFieldViewModeAlways;
    contactNoField.borderStyle = UITextBorderStyleNone;
    contactNoField.textAlignment=NSTextAlignmentLeft;
    [contactNoField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    contactNoField.placeholder=@"Contact No *";
    [bgScrollView addSubview:contactNoField];
    contactNoField.clearButtonMode = UITextFieldViewModeWhileEditing;
    contactNoField.delegate = self;
    contactNoField.backgroundColor = [UIColor whiteColor];
    contactNoField.returnKeyType = UIReturnKeyNext;
    [contactNoField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    contactNoField.tag = 4;
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, contactNoField.frame.origin.y+contactNoField.bounds.size.height+2, bgScrollView.bounds.size.width, 40)];
    emailField.textColor = RGB(35, 35, 35);
    emailField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    emailField.leftViewMode = UITextFieldViewModeAlways;
    emailField.borderStyle = UITextBorderStyleNone;
    emailField.textAlignment=NSTextAlignmentLeft;
    [emailField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    emailField.placeholder=@"Email *";
    [bgScrollView addSubview:emailField];
    emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailField.delegate = self;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    emailField.backgroundColor = [UIColor whiteColor];
    emailField.returnKeyType = UIReturnKeyNext;
    [emailField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    emailField.tag = 5;
    
    preferredContactLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, emailField.frame.origin.y+emailField.bounds.size.height+20, bgScrollView.bounds.size.width, 20)];
    preferredContactLabel.backgroundColor = [UIColor clearColor];
    preferredContactLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    preferredContactLabel.text = @"Preferred Contact Method:";
    [bgScrollView addSubview:preferredContactLabel];
    
    smsContactMethodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    smsContactMethodButton.frame = CGRectMake(10, preferredContactLabel.frame.origin.y+preferredContactLabel.bounds.size.height+20, 20, 20);
    [smsContactMethodButton addTarget:self action:@selector(selectContactModes:) forControlEvents:UIControlEventTouchUpInside];
    [smsContactMethodButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/checkbox_untick.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    smsContactMethodButton.tag = 1;
    [bgScrollView addSubview:smsContactMethodButton];
    
    smsLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, preferredContactLabel.frame.origin.y+preferredContactLabel.bounds.size.height+20, bgScrollView.bounds.size.width, 20)];
    smsLabel.backgroundColor = [UIColor clearColor];
    smsLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    smsLabel.text = @"SMS";
    [bgScrollView addSubview:smsLabel];
    
    emailContactMethodButton = [UIButton buttonWithType:UIButtonTypeCustom];
    emailContactMethodButton.frame = CGRectMake(10, smsContactMethodButton.frame.origin.y+smsContactMethodButton.bounds.size.height+20, 20, 20);
    [emailContactMethodButton addTarget:self action:@selector(selectContactModes:) forControlEvents:UIControlEventTouchUpInside];
    [emailContactMethodButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/checkbox_untick.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    emailContactMethodButton.tag = 2;
    [bgScrollView addSubview:emailContactMethodButton];
    
    
    emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, smsContactMethodButton.frame.origin.y+smsContactMethodButton.bounds.size.height+20, bgScrollView.bounds.size.width, 20)];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    emailLabel.text = @"Email";
    [bgScrollView addSubview:emailLabel];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    nextButton.frame = CGRectMake(0, bgScrollView.bounds.size.height-108, self.view.bounds.size.width, 45);
    [nextButton addTarget:self action:@selector(slideToSecondPart) forControlEvents:UIControlEventTouchUpInside];
    [nextButton setBackgroundColor:RGB(82, 82, 82)];
    [bgScrollView addSubview:nextButton];
    
    
    //***** Form Second Part
    
    dateField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, 0, bgScrollView.bounds.size.width, 40)];
    dateField.textColor = RGB(35, 35, 35);
    dateField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    dateField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    dateField.leftViewMode = UITextFieldViewModeAlways;
    dateField.borderStyle = UITextBorderStyleNone;
    dateField.textAlignment=NSTextAlignmentLeft;
    [dateField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    dateField.placeholder=@"Select Date";
    [bgScrollView addSubview:dateField];
    dateField.clearButtonMode = UITextFieldViewModeWhileEditing;
    dateField.delegate = self;
    dateField.backgroundColor = [UIColor whiteColor];
    dateField.returnKeyType = UIReturnKeyNext;
    [dateField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    dateField.tag = 6;
    
    UIButton *dateDropdown = [UIButton buttonWithType:UIButtonTypeCustom];
    dateDropdown.frame = CGRectMake(dateField.bounds.size.width-30, 12.5, 15, 15);
    [dateDropdown addTarget:self action:@selector(selectContactModes:) forControlEvents:UIControlEventTouchUpInside];
    [dateDropdown setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_arrow_down_field.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [dateField addSubview:dateDropdown];
    dateDropdown.userInteractionEnabled = NO;

    
    startTimeField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, dateField.frame.origin.y+dateField.bounds.size.height+2, (bgScrollView.bounds.size.width/2)-1, 40)];
    startTimeField.textColor = RGB(35, 35, 35);
    startTimeField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    startTimeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    startTimeField.leftViewMode = UITextFieldViewModeAlways;
    startTimeField.borderStyle = UITextBorderStyleNone;
    startTimeField.textAlignment=NSTextAlignmentLeft;
    [startTimeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    startTimeField.placeholder=@"Start Time";
    [bgScrollView addSubview:startTimeField];
    startTimeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    startTimeField.delegate = self;
    startTimeField.backgroundColor = [UIColor whiteColor];
    startTimeField.returnKeyType = UIReturnKeyNext;
    [startTimeField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    startTimeField.tag = 7;
    
    UIButton *startTimeDropdown = [UIButton buttonWithType:UIButtonTypeCustom];
    startTimeDropdown.frame = CGRectMake(startTimeField.bounds.size.width-30, 12.5, 15, 15);
    [startTimeDropdown addTarget:self action:@selector(selectContactModes:) forControlEvents:UIControlEventTouchUpInside];
    [startTimeDropdown setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_arrow_down_field.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [startTimeField addSubview:startTimeDropdown];
    startTimeDropdown.userInteractionEnabled = NO;

    
    endTimeField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width+(self.view.bounds.size.width/2)+1, dateField.frame.origin.y+dateField.bounds.size.height+2, (bgScrollView.bounds.size.width/2)-1, 40)];
    endTimeField.textColor = RGB(35, 35, 35);
    endTimeField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    endTimeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    endTimeField.leftViewMode = UITextFieldViewModeAlways;
    endTimeField.borderStyle = UITextBorderStyleNone;
    endTimeField.textAlignment=NSTextAlignmentLeft;
    [endTimeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    endTimeField.placeholder=@"End Time";
    [bgScrollView addSubview:endTimeField];
    endTimeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    endTimeField.delegate = self;
    endTimeField.backgroundColor = [UIColor whiteColor];
    endTimeField.returnKeyType = UIReturnKeyNext;
    [endTimeField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    endTimeField.tag = 8;
    
    UIButton *endTimeDropdown = [UIButton buttonWithType:UIButtonTypeCustom];
    endTimeDropdown.frame = CGRectMake(endTimeField.bounds.size.width-30, 12.5, 15, 15);
    [endTimeDropdown addTarget:self action:@selector(selectContactModes:) forControlEvents:UIControlEventTouchUpInside];
    [endTimeDropdown setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_arrow_down_field.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [endTimeField addSubview:endTimeDropdown];
    endTimeDropdown.userInteractionEnabled = NO;

    
    groupSizeField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, endTimeField.frame.origin.y+endTimeField.bounds.size.height+2, bgScrollView.bounds.size.width, 40)];
    groupSizeField.textColor = RGB(35, 35, 35);
    groupSizeField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    groupSizeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    groupSizeField.leftViewMode = UITextFieldViewModeAlways;
    groupSizeField.borderStyle = UITextBorderStyleNone;
    groupSizeField.textAlignment=NSTextAlignmentLeft;
    [groupSizeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    groupSizeField.placeholder=@"Group Size *";
    [bgScrollView addSubview:groupSizeField];
    groupSizeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    groupSizeField.delegate = self;
    groupSizeField.backgroundColor = [UIColor whiteColor];
    groupSizeField.returnKeyType = UIReturnKeyNext;
    [groupSizeField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    groupSizeField.tag = 9;
    
    categoryField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, groupSizeField.frame.origin.y+groupSizeField.bounds.size.height+2, bgScrollView.bounds.size.width, 40)];
    categoryField.textColor = RGB(35, 35, 35);
    categoryField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    categoryField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    categoryField.leftViewMode = UITextFieldViewModeAlways;
    categoryField.borderStyle = UITextBorderStyleNone;
    categoryField.textAlignment=NSTextAlignmentLeft;
    [categoryField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    categoryField.placeholder=@"Category *";
    [bgScrollView addSubview:categoryField];
    categoryField.clearButtonMode = UITextFieldViewModeWhileEditing;
    categoryField.delegate = self;
    categoryField.backgroundColor = [UIColor whiteColor];
    categoryField.returnKeyType = UIReturnKeyNext;
    [categoryField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    categoryField.tag = 10;

    UIButton *categoryDropdown = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryDropdown.frame = CGRectMake(categoryField.bounds.size.width-30, 12.5, 15, 15);
    [categoryDropdown addTarget:self action:@selector(selectContactModes:) forControlEvents:UIControlEventTouchUpInside];
    [categoryDropdown setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_arrow_down_field.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [categoryField addSubview:categoryDropdown];
    categoryDropdown.userInteractionEnabled = NO;
    
    ageRangeField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, categoryField.frame.origin.y+categoryField.bounds.size.height+2, bgScrollView.bounds.size.width, 40)];
    ageRangeField.textColor = RGB(35, 35, 35);
    ageRangeField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    ageRangeField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    ageRangeField.leftViewMode = UITextFieldViewModeAlways;
    ageRangeField.borderStyle = UITextBorderStyleNone;
    ageRangeField.textAlignment=NSTextAlignmentLeft;
    [ageRangeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    ageRangeField.placeholder=@"Age Range *";
    [bgScrollView addSubview:ageRangeField];
    ageRangeField.clearButtonMode = UITextFieldViewModeWhileEditing;
    ageRangeField.delegate = self;
    ageRangeField.backgroundColor = [UIColor whiteColor];
    ageRangeField.returnKeyType = UIReturnKeyNext;
    [ageRangeField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    ageRangeField.tag = 11;
    
    firstVisitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width+10, ageRangeField.frame.origin.y+ageRangeField.bounds.size.height+20, 120, 20)];
    firstVisitLabel.backgroundColor = [UIColor clearColor];
    firstVisitLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    firstVisitLabel.text = @"First Visit:";
    [bgScrollView addSubview:firstVisitLabel];
    
    firstVisitYesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstVisitYesButton.frame = CGRectMake(self.view.bounds.size.width+150, ageRangeField.frame.origin.y+ageRangeField.bounds.size.height+20, 20, 20);
    [firstVisitYesButton addTarget:self action:@selector(selectFirstVisitOption:) forControlEvents:UIControlEventTouchUpInside];
    [firstVisitYesButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/tick.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    firstVisitYesButton.tag = 1;
    [bgScrollView addSubview:firstVisitYesButton];
    
    yesLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width+180, ageRangeField.frame.origin.y+ageRangeField.bounds.size.height+20, 80, 20)];
    yesLabel.backgroundColor = [UIColor clearColor];
    yesLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    yesLabel.text = @"YES";
    [bgScrollView addSubview:yesLabel];
    
    firstVisitNoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstVisitNoButton.frame = CGRectMake(self.view.bounds.size.width+220, ageRangeField.frame.origin.y+ageRangeField.bounds.size.height+20, 20, 20);
    [firstVisitNoButton addTarget:self action:@selector(selectFirstVisitOption:) forControlEvents:UIControlEventTouchUpInside];
    [firstVisitNoButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/checkbox_untick.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    firstVisitNoButton.tag = 2;
    [bgScrollView addSubview:firstVisitNoButton];
    
    
    noLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width+250, ageRangeField.frame.origin.y+ageRangeField.bounds.size.height+20, 80, 20)];
    noLabel.backgroundColor = [UIColor clearColor];
    noLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    noLabel.text = @"NO";
    [bgScrollView addSubview:noLabel];
    
    
    remarksTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width, firstVisitLabel.frame.origin.y+firstVisitLabel.bounds.size.height+20, self.view.bounds.size.width, 100)];
    remarksTextView.returnKeyType = UIReturnKeyDone;
    remarksTextView.delegate = self;
    remarksTextView.text = @"Remarks";
    remarksTextView.textColor = [UIColor lightGrayColor];
    remarksTextView.font = [UIFont fontWithName:ROBOTO_REGULAR size:14.0];
    remarksTextView.backgroundColor = [UIColor whiteColor];
    [bgScrollView addSubview:remarksTextView];
    
    
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    submitButton.frame = CGRectMake(self.view.bounds.size.width, bgScrollView.bounds.size.height-108, self.view.bounds.size.width, 45);
//    [submitButton addTarget:self action:@selector(slideToSecondPart) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setBackgroundColor:RGB(82, 82, 82)];
    [bgScrollView addSubview:submitButton];
}


# pragma mark - UITextViewDelegate Methods

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{

    [remarksTextView resignFirstResponder];
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [remarksTextView resignFirstResponder];
        if(remarksTextView.text.length == 0){
            remarksTextView.textColor = [UIColor lightGrayColor];
            remarksTextView.text = @"Remarks";
            [remarksTextView resignFirstResponder];
        }
        return NO;
    }
    
    return YES;
}


- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    if (remarksTextView.textColor == [UIColor lightGrayColor]) {
        remarksTextView.text = @"";
        remarksTextView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(remarksTextView.text.length == 0){
        remarksTextView.textColor = [UIColor lightGrayColor];
        remarksTextView.text = @"Remarks";
        [remarksTextView resignFirstResponder];
    }
}



# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    
    bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    bgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width*2, self.view.bounds.size.height);
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.backgroundColor = RGB(247, 247, 247);
    [self.view addSubview:bgScrollView];
    bgScrollView.scrollEnabled = NO;
}


- (void) viewWillAppear:(BOOL)animated {
    
    isFirstVisit = YES;
    [self createBookingForm];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
