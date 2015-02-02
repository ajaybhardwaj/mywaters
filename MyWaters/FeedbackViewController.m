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
    
    if (fieldIndex==0) {
        return feedbackTypeArray.count;
    }
    else if (fieldIndex==2) {
        return severityTypeArray.count;
    }
    
    return 0;
}



# pragma mark - UIPickerViewDelegate Method

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (fieldIndex==0) {
        return [feedbackTypeArray objectAtIndex:row];
    }
    else if (fieldIndex==2) {
        return [severityTypeArray objectAtIndex:row];
    }
    
    return nil;
}



# pragma mark - UITableViewDelegate Methods

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    
//}


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
        cellTextField.tag = indexPath.row;
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



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu"]];
    [self.navigationItem setRightBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_filter"]];
    
    fieldIndex = 0;
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
    
    
    pickerbackground = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-266, self.view.bounds.size.width, 266)];
    
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *cancelPicker = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:nil];
    UIBarButtonItem *selectPicker = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:nil];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:cancelPicker,flexibleSpace,selectPicker, nil]];
    [pickerbackground addSubview:toolBar];
    
    
    feedbackPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 320, 216)];
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
