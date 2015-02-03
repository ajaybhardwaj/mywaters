//
//  FeedbackViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "FeedbackViewController.h"
#import "ViewControllerHelper.h"


@interface FeedbackViewController ()

@end

@implementation FeedbackViewController


//*************** Method To Animate To Show Picker View

- (void) showPickerView {
    
    if (isShowingPicker) {
        [feedbackPickerView reloadAllComponents];
    }
    else {
        isShowingPicker = YES;
        
        [UIView beginAnimations:@"feedbackPicker" context:NULL];
        [UIView setAnimationDuration:0.5];
        CGPoint pickerBgView = pickerbackground.center;
        pickerBgView.y = self.view.bounds.size.height-40;
        pickerbackground.center = pickerBgView;
        [UIView commitAnimations];
    }
}



//*************** Method To Hide Picker View

- (void) cancelPickerView {
    
    isShowingPicker = NO;
    
    [UIView beginAnimations:@"feedbackPicker" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pickerBgView = pickerbackground.center;
    pickerBgView.y = self.view.bounds.size.height+180;
    pickerbackground.center = pickerBgView;
    [UIView commitAnimations];
}


//*************** Method To Hide Picker View

- (void) selectPickerViewValue {
    
    isShowingPicker = NO;
    NSLog(@"%ld",(long)fieldIndex);
    
    UITextField *newField = (UITextField *)[self.view viewWithTag:fieldIndex];

    if (fieldIndex==1) {
        newField.text = [feedbackTypeArray objectAtIndex:selectedPickerIndex];
    }
    else if (fieldIndex==3) {
        newField.text = [severityTypeArray objectAtIndex:selectedPickerIndex];
    }
    
    [UIView beginAnimations:@"feedbackPicker" context:NULL];
    [UIView setAnimationDuration:0.5];
    CGPoint pickerBgView = pickerbackground.center;
    pickerBgView.y = self.view.bounds.size.height+180;
    pickerbackground.center = pickerBgView;
    [UIView commitAnimations];
}


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}



//*************** Method To Create Feedback Table Footer

- (void) createFeedbackTableHeader {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
    [headerView setBackgroundColor:RGB(247, 247, 247)];
    
    [feedbackTableView setTableHeaderView:headerView];
}





# pragma mark - UIPickerViewDataSource Method

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (fieldIndex==1) {
        return feedbackTypeArray.count;
    }
    else if (fieldIndex==3) {
        return severityTypeArray.count;
    }
    
    return 0;
}



# pragma mark - UIPickerViewDelegate Method

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *rowTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    if (fieldIndex==1) {
        rowTitle.text = [feedbackTypeArray objectAtIndex:row];
    }
    else if (fieldIndex==3) {
        rowTitle.text = [severityTypeArray objectAtIndex:row];
    }
    rowTitle.font = [UIFont fontWithName:ROBOTO_MEDIUM size:17.0];
    rowTitle.textColor = RGB(35, 35, 35);
    rowTitle.textAlignment = NSTextAlignmentCenter;
    rowTitle.backgroundColor = [UIColor clearColor];
    
    return rowTitle;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    selectedPickerIndex = row;
}



# pragma mark - UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedback"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"feedback"];
    }
    
    cell.backgroundColor = RGB(247, 247, 247);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    cell.detailTextLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:12];
    
    cell.textLabel.textColor = RGB(35, 35, 35);
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.numberOfLines = 0;
    
    
    if (isFloodSubmission) {
        
        cellTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height-0.5)];
        cellTextField.textColor = RGB(35, 35, 35);
        cellTextField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
        cellTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        cellTextField.leftViewMode = UITextFieldViewModeAlways;
        cellTextField.borderStyle = UITextBorderStyleNone;
        cellTextField.textAlignment=NSTextAlignmentLeft;
        [cellTextField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        
        if (indexPath.row==0) {
            cellTextField.placeholder=@"Select Feedback Type";
            cellTextField.text = [feedbackTypeArray objectAtIndex:0];
            
            UIImageView *dropDownButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            [dropDownButton setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_arrow_down.png",appDelegate.RESOURCE_FOLDER_PATH]]];
            cell.accessoryView = dropDownButton;
        }
        else if (indexPath.row==1) {
            cellTextField.placeholder=@"Location *";
        }
        else if (indexPath.row==2) {
            cellTextField.placeholder=@"Severity Type *";
        }
        else if (indexPath.row==3) {
            cellTextField.placeholder=@"Name *";
            cellTextField.returnKeyType=UIReturnKeyNext;
            cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
        else if (indexPath.row==4) {
            cellTextField.placeholder=@"Contact No. *";
            cellTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
        cellTextField.backgroundColor = [UIColor clearColor];
        cellTextField.delegate = self;
        cellTextField.tag = indexPath.row+1;
        [cellTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [cell.contentView addSubview:cellTextField];
    }
    else {
        
    }
    
    
    UIImageView *cellSeperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-0.5, feedbackTableView.bounds.size.width, 0.5)];
    [cellSeperator setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:cellSeperator];
    
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}


# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (isFloodSubmission) {
        if (textField.tag == 1 || textField.tag == 3) {
            fieldIndex = textField.tag;
            selectedPickerIndex = 0;
            [feedbackPickerView reloadComponent:0];
            [self showPickerView];
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        if (textField.tag == 1) {
            return NO;
        }
        else {
            return YES;
        }
    }
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_filter"]];
    
    fieldIndex = 1;
    isFloodSubmission = YES;
    feedbackTypeArray = [[NSArray alloc] initWithObjects:@"Dirty/Choked Drain",@"Flood Area Submission",@"Water Leak",@"Poor Water Pressure Quality",@"Reports Feeds",@"Sewer Choke/Overflow/Smell",@"Others", nil];
    severityTypeArray = [[NSArray alloc] initWithObjects:@"Light",@"Heavy",@"Severe", nil];
    
    feedbackTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60) style:UITableViewStylePlain];
    feedbackTableView.delegate = self;
    feedbackTableView.dataSource = self;
    [self.view addSubview:feedbackTableView];
    feedbackTableView.backgroundColor = RGB(247, 247, 247);
    feedbackTableView.backgroundView = nil;
    feedbackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    feedbackTableView.scrollEnabled = NO;
    
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(0, self.view.bounds.size.height-114, self.view.bounds.size.width, 50);
    [submitButton setBackgroundColor:RGB(82, 82, 82)];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:BEBAS_NEUE_FONT size:18];
    [self.view addSubview:submitButton];
    
    [self createFeedbackTableHeader];
    
    
    pickerbackground = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 220)];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *cancelPicker = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPickerView)];
    UIBarButtonItem *selectPicker = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectPickerViewValue)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:cancelPicker,flexibleSpace,selectPicker, nil]];
    [pickerbackground addSubview:toolBar];
    
    
    feedbackPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 180)];
    feedbackPickerView.delegate=self;
    feedbackPickerView.dataSource=self;
    feedbackPickerView.backgroundColor = RGB(247, 247, 247);
    feedbackPickerView.showsSelectionIndicator=YES;
    
    [pickerbackground addSubview:feedbackPickerView];
    [appDelegate.window addSubview:pickerbackground];
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
