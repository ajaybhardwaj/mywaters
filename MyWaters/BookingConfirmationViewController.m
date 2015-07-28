//
//  BookingConfirmationViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 19/3/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "BookingConfirmationViewController.h"

@interface BookingConfirmationViewController ()

@end

@implementation BookingConfirmationViewController
@synthesize dataDict;

//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Booking Form";
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];

    
    contentBgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-109)];
    contentBgScrollView.showsHorizontalScrollIndicator = NO;
    contentBgScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:contentBgScrollView];
    contentBgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    contentBgScrollView.backgroundColor = RGB(247, 247, 247);
    
    personDetailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, contentBgScrollView.bounds.size.width, 20)];
    personDetailsLabel.backgroundColor = [UIColor clearColor];
    personDetailsLabel.text = @"----  PERSONAL DETAILS  ----------------------------------------------";
    personDetailsLabel.textColor = [UIColor lightGrayColor];
    personDetailsLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    [contentBgScrollView addSubview:personDetailsLabel];
    
    contactPersonLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, personDetailsLabel.frame.origin.y+personDetailsLabel.bounds.size.height+10, 110, 20)];
    contactPersonLabel.backgroundColor = [UIColor clearColor];
    contactPersonLabel.text = @"Contact Person :";
    contactPersonLabel.textColor = [UIColor blackColor];
    contactPersonLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [contentBgScrollView addSubview:contactPersonLabel];
    
    contactPersonValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(contactPersonLabel.frame.origin.x+contactPersonLabel.bounds.size.width, personDetailsLabel.frame.origin.y+personDetailsLabel.bounds.size.height+10, contentBgScrollView.bounds.size.width-(contactPersonLabel.frame.origin.x+contactPersonLabel.bounds.size.width), 20)];
    contactPersonValueLabel.backgroundColor = [UIColor clearColor];
    contactPersonValueLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"personName"]];
    contactPersonValueLabel.textColor = [UIColor blackColor];
    contactPersonValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    contactPersonValueLabel.numberOfLines = 0;
    contactPersonValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedDescriptionLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"personName"]] sizeWithFont:contactPersonValueLabel.font
                                                                                                         constrainedToSize:contactPersonValueLabel.frame.size
                                                                                                             lineBreakMode:NSLineBreakByWordWrapping];

    CGRect newTitleFrame = contactPersonValueLabel.frame;
    newTitleFrame.size.height = expectedDescriptionLabelSize.height;
    contactPersonValueLabel.frame = newTitleFrame;
    [contentBgScrollView addSubview:contactPersonValueLabel];
    [contactPersonValueLabel sizeToFit];

    
    
    
    organisationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, contactPersonValueLabel.frame.origin.y+contactPersonValueLabel.bounds.size.height+15, 90, 20)];
    organisationLabel.backgroundColor = [UIColor clearColor];
    organisationLabel.text = @"Organisation :";
    organisationLabel.textColor = [UIColor blackColor];
    organisationLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [contentBgScrollView addSubview:organisationLabel];
    
    organisationValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(organisationLabel.frame.origin.x+organisationLabel.bounds.size.width, contactPersonValueLabel.frame.origin.y+contactPersonValueLabel.bounds.size.height+15, contentBgScrollView.bounds.size.width-(organisationLabel.frame.origin.x+organisationLabel.bounds.size.width), 20)];
    organisationValueLabel.backgroundColor = [UIColor clearColor];
    organisationValueLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"organisationName"]];
    organisationValueLabel.textColor = [UIColor blackColor];
    organisationValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    organisationValueLabel.numberOfLines = 0;
    organisationValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedOrganisationValueLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"organisationName"]] sizeWithFont:organisationValueLabel.font
                                                                                                              constrainedToSize:organisationValueLabel.frame.size
                                                                                                                  lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newOrganisationValueFrame = organisationValueLabel.frame;
    newOrganisationValueFrame.size.height = expectedOrganisationValueLabelSize.height;
    organisationValueLabel.frame = newOrganisationValueFrame;
    [contentBgScrollView addSubview:organisationValueLabel];
    [organisationValueLabel sizeToFit];

    
    
    designationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, organisationValueLabel.frame.origin.y+organisationValueLabel.bounds.size.height+15, 85, 20)];
    designationLabel.backgroundColor = [UIColor clearColor];
    designationLabel.text = @"Designation :";
    designationLabel.textColor = [UIColor blackColor];
    designationLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [contentBgScrollView addSubview:designationLabel];
    
    designationValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(designationLabel.frame.origin.x+designationLabel.bounds.size.width, organisationValueLabel.frame.origin.y+organisationValueLabel.bounds.size.height+15, contentBgScrollView.bounds.size.width-(designationLabel.frame.origin.x+designationLabel.bounds.size.width), 20)];
    designationValueLabel.backgroundColor = [UIColor clearColor];
    designationValueLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"designationName"]];
    designationValueLabel.textColor = [UIColor blackColor];
    designationValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    designationValueLabel.numberOfLines = 0;
    designationValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedDesignationValueLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"designationName"]] sizeWithFont:designationValueLabel.font
                                                                                                                          constrainedToSize:designationValueLabel.frame.size
                                                                                                                              lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newDesignationValueFrame = designationValueLabel.frame;
    newDesignationValueFrame.size.height = expectedDesignationValueLabelSize.height;
    designationValueLabel.frame = newDesignationValueFrame;
    [contentBgScrollView addSubview:designationValueLabel];
    [designationValueLabel sizeToFit];

    
    contactNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, designationValueLabel.frame.origin.y+designationValueLabel.bounds.size.height+15, 80, 20)];
    contactNoLabel.backgroundColor = [UIColor clearColor];
    contactNoLabel.text = @"Contact No :";
    contactNoLabel.textColor = [UIColor blackColor];
    contactNoLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [contentBgScrollView addSubview:contactNoLabel];
    
    contactNoValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(contactNoLabel.frame.origin.x+contactNoLabel.bounds.size.width, designationValueLabel.frame.origin.y+designationValueLabel.bounds.size.height+15, contentBgScrollView.bounds.size.width-(contactNoLabel.frame.origin.x+contactNoLabel.bounds.size.width), 20)];
    contactNoValueLabel.backgroundColor = [UIColor clearColor];
    contactNoValueLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"contactNumber"]];
    contactNoValueLabel.textColor = [UIColor blackColor];
    contactNoValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    contactNoValueLabel.numberOfLines = 0;
    contactNoValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedContactNumberValueLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"contactNumber"]] sizeWithFont:contactNoValueLabel.font
                                                                                                                         constrainedToSize:contactNoValueLabel.frame.size
                                                                                                                             lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newContactNumberValueFrame = contactNoValueLabel.frame;
    newContactNumberValueFrame.size.height = expectedContactNumberValueLabelSize.height;
    contactNoValueLabel.frame = newContactNumberValueFrame;
    [contentBgScrollView addSubview:contactNoValueLabel];
    [contactNoValueLabel sizeToFit];

    
    
    emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, contactNoValueLabel.frame.origin.y+contactNoValueLabel.bounds.size.height+15, 45, 20)];
    emailLabel.backgroundColor = [UIColor clearColor];
    emailLabel.text = @"Email :";
    emailLabel.textColor = [UIColor blackColor];
    emailLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [contentBgScrollView addSubview:emailLabel];
    
    emailValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(emailLabel.frame.origin.x+emailLabel.bounds.size.width, contactNoValueLabel.frame.origin.y+contactNoValueLabel.bounds.size.height+15, contentBgScrollView.bounds.size.width-(emailLabel.frame.origin.x+emailLabel.bounds.size.width), 20)];
    emailValueLabel.backgroundColor = [UIColor clearColor];
    emailValueLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"email"]];
    emailValueLabel.textColor = [UIColor blackColor];
    emailValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    emailValueLabel.numberOfLines = 0;
    emailValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedEmailValueLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"email"]] sizeWithFont:emailValueLabel.font
                                                                                                                        constrainedToSize:emailValueLabel.frame.size
                                                                                                                            lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newEmailValueFrame = emailValueLabel.frame;
    newEmailValueFrame.size.height = expectedEmailValueLabelSize.height;
    emailValueLabel.frame = newEmailValueFrame;
    [contentBgScrollView addSubview:emailValueLabel];
    [emailValueLabel sizeToFit];

    
    
    preferredContactLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, emailValueLabel.frame.origin.y+emailValueLabel.bounds.size.height+15, 175, 20)];
    preferredContactLabel.backgroundColor = [UIColor clearColor];
    preferredContactLabel.text = @"Preferred Contact Method :";
    preferredContactLabel.textColor = [UIColor blackColor];
    preferredContactLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [contentBgScrollView addSubview:preferredContactLabel];
    
    preferredContactValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(preferredContactLabel.frame.origin.x+preferredContactLabel.bounds.size.width, emailValueLabel.frame.origin.y+emailValueLabel.bounds.size.height+15, contentBgScrollView.bounds.size.width-(preferredContactLabel.frame.origin.x+preferredContactLabel.bounds.size.width), 20)];
    preferredContactValueLabel.backgroundColor = [UIColor clearColor];
    preferredContactValueLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"preferredContact"]];
    preferredContactValueLabel.textColor = [UIColor blackColor];
    preferredContactValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    preferredContactValueLabel.numberOfLines = 0;
    preferredContactValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedPreferredContactValueLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"preferredContact"]] sizeWithFont:preferredContactValueLabel.font
                                                                                                                constrainedToSize:preferredContactValueLabel.frame.size
                                                                                                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newPreferredContactValueFrame = preferredContactValueLabel.frame;
    newPreferredContactValueFrame.size.height = expectedPreferredContactValueLabelSize.height;
    preferredContactValueLabel.frame = newPreferredContactValueFrame;
    [contentBgScrollView addSubview:preferredContactValueLabel];
    [preferredContactValueLabel sizeToFit];

    
    
    bookingDetailsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, preferredContactValueLabel.frame.origin.y+preferredContactValueLabel.bounds.size.height+25, contentBgScrollView.bounds.size.width, 20)];
    bookingDetailsLabel.backgroundColor = [UIColor clearColor];
    bookingDetailsLabel.text = @"----  BOOKING DETAILS  ------------------------------------------------";
    bookingDetailsLabel.textColor = [UIColor lightGrayColor];
    bookingDetailsLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    [contentBgScrollView addSubview:bookingDetailsLabel];

    
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, bookingDetailsLabel.frame.origin.y+bookingDetailsLabel.bounds.size.height+10, 40, 20)];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.text = @"Date :";
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [contentBgScrollView addSubview:dateLabel];
    
    dateValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(dateLabel.frame.origin.x+dateLabel.bounds.size.width, bookingDetailsLabel.frame.origin.y+bookingDetailsLabel.bounds.size.height+10, contentBgScrollView.bounds.size.width-(preferredContactLabel.frame.origin.x+preferredContactLabel.bounds.size.width), 20)];
    dateValueLabel.backgroundColor = [UIColor clearColor];
    dateValueLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"date"]];
    dateValueLabel.textColor = [UIColor blackColor];
    dateValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    dateValueLabel.numberOfLines = 0;
    dateValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedDateValueLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"date"]] sizeWithFont:dateValueLabel.font
                                                                                                                              constrainedToSize:dateValueLabel.frame.size
                                                                                                                                  lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newDateValueFrame = dateValueLabel.frame;
    newDateValueFrame.size.height = expectedDateValueLabelSize.height;
    dateValueLabel.frame = newDateValueFrame;
    [contentBgScrollView addSubview:dateValueLabel];
    [dateValueLabel sizeToFit];

    
    
    startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, dateValueLabel.frame.origin.y+dateValueLabel.bounds.size.height+15, 77, 20)];
    startTimeLabel.backgroundColor = [UIColor clearColor];
    startTimeLabel.text = @"Start Time :";
    startTimeLabel.textColor = [UIColor blackColor];
    startTimeLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [contentBgScrollView addSubview:startTimeLabel];
    
    startTimeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(startTimeLabel.frame.origin.x+startTimeLabel.bounds.size.width, dateValueLabel.frame.origin.y+dateValueLabel.bounds.size.height+15, contentBgScrollView.bounds.size.width-(startTimeLabel.frame.origin.x+startTimeLabel.bounds.size.width), 20)];
    startTimeValueLabel.backgroundColor = [UIColor clearColor];
    startTimeValueLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"startTime"]];
    startTimeValueLabel.textColor = [UIColor blackColor];
    startTimeValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    startTimeValueLabel.numberOfLines = 0;
    startTimeValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedStartTimeValueLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"startTime"]] sizeWithFont:startTimeValueLabel.font
                                                                                                      constrainedToSize:startTimeValueLabel.frame.size
                                                                                                          lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newStartTimeValueFrame = startTimeValueLabel.frame;
    newStartTimeValueFrame.size.height = expectedStartTimeValueLabelSize.height;
    startTimeValueLabel.frame = newStartTimeValueFrame;
    [contentBgScrollView addSubview:startTimeValueLabel];
    [startTimeValueLabel sizeToFit];

    
    
    endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, startTimeValueLabel.frame.origin.y+startTimeValueLabel.bounds.size.height+15, 70, 20)];
    endTimeLabel.backgroundColor = [UIColor clearColor];
    endTimeLabel.text = @"End Time :";
    endTimeLabel.textColor = [UIColor blackColor];
    endTimeLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [contentBgScrollView addSubview:endTimeLabel];
    
    endTimeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(endTimeLabel.frame.origin.x+endTimeLabel.bounds.size.width, startTimeValueLabel.frame.origin.y+startTimeValueLabel.bounds.size.height+15, contentBgScrollView.bounds.size.width-(endTimeLabel.frame.origin.x+endTimeLabel.bounds.size.width), 20)];
    endTimeValueLabel.backgroundColor = [UIColor clearColor];
    endTimeValueLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"endTime"]];
    endTimeValueLabel.textColor = [UIColor blackColor];
    endTimeValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    endTimeValueLabel.numberOfLines = 0;
    endTimeValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedEndTimeValueLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"endTime"]] sizeWithFont:endTimeValueLabel.font
                                                                                                                constrainedToSize:endTimeValueLabel.frame.size
                                                                                                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newEndTimeValueFrame = endTimeValueLabel.frame;
    newEndTimeValueFrame.size.height = expectedEndTimeValueLabelSize.height;
    endTimeValueLabel.frame = newEndTimeValueFrame;
    [contentBgScrollView addSubview:endTimeValueLabel];
    [endTimeValueLabel sizeToFit];

    
    groupSizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, endTimeValueLabel.frame.origin.y+endTimeValueLabel.bounds.size.height+15, 80, 20)];
    groupSizeLabel.backgroundColor = [UIColor clearColor];
    groupSizeLabel.text = @"Group Size :";
    groupSizeLabel.textColor = [UIColor blackColor];
    groupSizeLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [contentBgScrollView addSubview:groupSizeLabel];
    
    groupSizeValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(groupSizeLabel.frame.origin.x+groupSizeLabel.bounds.size.width, endTimeValueLabel.frame.origin.y+endTimeValueLabel.bounds.size.height+15, contentBgScrollView.bounds.size.width-(groupSizeLabel.frame.origin.x+groupSizeLabel.bounds.size.width), 20)];
    groupSizeValueLabel.backgroundColor = [UIColor clearColor];
    groupSizeValueLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"groupSize"]];
    groupSizeValueLabel.textColor = [UIColor blackColor];
    groupSizeValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    groupSizeValueLabel.numberOfLines = 0;
    groupSizeValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedGroupSizeValueLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"groupSize"]] sizeWithFont:groupSizeValueLabel.font
                                                                                                              constrainedToSize:groupSizeValueLabel.frame.size
                                                                                                                  lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newGroupSizeValueFrame = groupSizeValueLabel.frame;
    newGroupSizeValueFrame.size.height = expectedGroupSizeValueLabelSize.height;
    groupSizeValueLabel.frame = newGroupSizeValueFrame;
    [contentBgScrollView addSubview:groupSizeValueLabel];
    
    
    
    categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, groupSizeValueLabel.frame.origin.y+groupSizeValueLabel.bounds.size.height+15, 69, 20)];
    categoryLabel.backgroundColor = [UIColor clearColor];
    categoryLabel.text = @"Category :";
    categoryLabel.textColor = [UIColor blackColor];
    categoryLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [contentBgScrollView addSubview:categoryLabel];
    
    categoryValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(categoryLabel.frame.origin.x+categoryLabel.bounds.size.width, groupSizeValueLabel.frame.origin.y+groupSizeValueLabel.bounds.size.height+15, contentBgScrollView.bounds.size.width-(categoryLabel.frame.origin.x+categoryLabel.bounds.size.width), 20)];
    categoryValueLabel.backgroundColor = [UIColor clearColor];
    categoryValueLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"category"]];
    categoryValueLabel.textColor = [UIColor blackColor];
    categoryValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    categoryValueLabel.numberOfLines = 0;
    categoryValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedCategoryValueLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"category"]] sizeWithFont:categoryValueLabel.font
                                                                                                                constrainedToSize:categoryValueLabel.frame.size
                                                                                                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newCategorySizeValueFrame = categoryValueLabel.frame;
    newCategorySizeValueFrame.size.height = expectedCategoryValueLabelSize.height;
    categoryValueLabel.frame = newCategorySizeValueFrame;
    [contentBgScrollView addSubview:categoryValueLabel];
    [categoryValueLabel sizeToFit];

    
    
    firstVisitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, categoryValueLabel.frame.origin.y+categoryValueLabel.bounds.size.height+15, 74, 20)];
    firstVisitLabel.backgroundColor = [UIColor clearColor];
    firstVisitLabel.text = @"First Visit :";
    firstVisitLabel.textColor = [UIColor blackColor];
    firstVisitLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [contentBgScrollView addSubview:firstVisitLabel];
    
    firstVisitValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(firstVisitLabel.frame.origin.x+firstVisitLabel.bounds.size.width, categoryValueLabel.frame.origin.y+categoryValueLabel.bounds.size.height+15, contentBgScrollView.bounds.size.width-(firstVisitLabel.frame.origin.x+firstVisitLabel.bounds.size.width), 20)];
    firstVisitValueLabel.backgroundColor = [UIColor clearColor];
    firstVisitValueLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"firstVisit"]];
    firstVisitValueLabel.textColor = [UIColor blackColor];
    firstVisitValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    firstVisitValueLabel.numberOfLines = 0;
    firstVisitValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedFirstVisitValueLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"firstVisit"]] sizeWithFont:firstVisitValueLabel.font
                                                                                                              constrainedToSize:firstVisitValueLabel.frame.size
                                                                                                                  lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newFirstVisitValueFrame = firstVisitValueLabel.frame;
    newFirstVisitValueFrame.size.height = expectedFirstVisitValueLabelSize.height;
    firstVisitValueLabel.frame = newFirstVisitValueFrame;
    [contentBgScrollView addSubview:firstVisitValueLabel];
    [firstVisitValueLabel sizeToFit];

    
    
    remarksLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, firstVisitValueLabel.frame.origin.y+firstVisitValueLabel.bounds.size.height+15, 70, 20)];
    remarksLabel.backgroundColor = [UIColor clearColor];
    remarksLabel.text = @"Remarks :";
    remarksLabel.textColor = [UIColor blackColor];
    remarksLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    [contentBgScrollView addSubview:remarksLabel];
    
    remarksValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(remarksLabel.frame.origin.x+remarksLabel.bounds.size.width, firstVisitValueLabel.frame.origin.y+firstVisitValueLabel.bounds.size.height+15, contentBgScrollView.bounds.size.width-(remarksLabel.frame.origin.x+remarksLabel.bounds.size.width), 20)];
    remarksValueLabel.backgroundColor = [UIColor clearColor];
    remarksValueLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"remarks"]];
    remarksValueLabel.textColor = [UIColor blackColor];
    remarksValueLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    remarksValueLabel.numberOfLines = 0;
    remarksValueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize expectedRemarksValueLabelSize = [[NSString stringWithFormat:@"%@",[dataDict objectForKey:@"remarks"]] sizeWithFont:remarksValueLabel.font
                                                                                                                constrainedToSize:remarksValueLabel.frame.size
                                                                                                                    lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newRemarksValueFrame = remarksValueLabel.frame;
    newRemarksValueFrame.size.height = expectedRemarksValueLabelSize.height;
    remarksValueLabel.frame = newRemarksValueFrame;
    [contentBgScrollView addSubview:remarksValueLabel];
    [remarksValueLabel sizeToFit];

    
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"DONE" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    doneButton.titleLabel.font = [UIFont fontWithName:BEBAS_NEUE_FONT size:19];
    doneButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:19];
    doneButton.frame = CGRectMake(0, self.view.bounds.size.height-109, self.view.bounds.size.width, 45);
    [doneButton addTarget:self action:@selector(pop2Dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setBackgroundColor:RGB(82, 82, 82)];
    [self.view addSubview:doneButton];
    
    
    contentBgScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, contactPersonValueLabel.bounds.size.height+organisationValueLabel.bounds.size.height+designationValueLabel.bounds.size.height+contactNoValueLabel.bounds.size.height+emailValueLabel.bounds.size.height+preferredContactValueLabel.bounds.size.height+dateValueLabel.bounds.size.height+startTimeValueLabel.bounds.size.height+endTimeValueLabel.bounds.size.height+groupSizeValueLabel.bounds.size.height+categoryValueLabel.bounds.size.height+firstVisitValueLabel.bounds.size.height+remarksValueLabel.bounds.size.height+personDetailsLabel.bounds.size.height+bookingDetailsLabel.bounds.size.height+319);
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
