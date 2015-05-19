//
//  ChangePasswordViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 23/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField==currentPassField) {
        [newPassField becomeFirstResponder];
    }
    else if (textField==newPassField) {
        [confirmPassField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
    }
    return YES;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Change Password";
    self.view.backgroundColor = RGB(247, 247, 247);
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
    currentPassField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 40)];
    currentPassField.textColor = RGB(35, 35, 35);
    currentPassField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    currentPassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    currentPassField.leftViewMode = UITextFieldViewModeAlways;
    currentPassField.borderStyle = UITextBorderStyleNone;
    currentPassField.textAlignment=NSTextAlignmentLeft;
    [currentPassField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    currentPassField.placeholder = @"Current password *";
    [self.view addSubview:currentPassField];
    currentPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    currentPassField.delegate = self;
    currentPassField.keyboardType = UIKeyboardTypeDefault;
    currentPassField.backgroundColor = [UIColor whiteColor];
    currentPassField.returnKeyType = UIReturnKeyNext;
    currentPassField.secureTextEntry = YES;
    [currentPassField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    currentPassField.tag = 1;
    
    newPassField = [[UITextField alloc] initWithFrame:CGRectMake(0, currentPassField.frame.origin.y+currentPassField.bounds.size.height+1, self.view.bounds.size.width, 40)];
    newPassField.textColor = RGB(35, 35, 35);
    newPassField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    newPassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    newPassField.leftViewMode = UITextFieldViewModeAlways;
    newPassField.borderStyle = UITextBorderStyleNone;
    newPassField.textAlignment=NSTextAlignmentLeft;
    [newPassField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    newPassField.placeholder = @"New password *";
    [self.view addSubview:newPassField];
    newPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    newPassField.delegate = self;
    newPassField.keyboardType = UIKeyboardTypeDefault;
    newPassField.backgroundColor = [UIColor whiteColor];
    newPassField.returnKeyType = UIReturnKeyNext;
    newPassField.secureTextEntry = YES;
    [newPassField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    newPassField.tag = 2;
    
    confirmPassField = [[UITextField alloc] initWithFrame:CGRectMake(0, newPassField.frame.origin.y+newPassField.bounds.size.height+1, self.view.bounds.size.width, 40)];
    confirmPassField.textColor = RGB(35, 35, 35);
    confirmPassField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    confirmPassField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    confirmPassField.leftViewMode = UITextFieldViewModeAlways;
    confirmPassField.borderStyle = UITextBorderStyleNone;
    confirmPassField.textAlignment=NSTextAlignmentLeft;
    [confirmPassField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    confirmPassField.placeholder = @"Re-type password *";
    [self.view addSubview:confirmPassField];
    confirmPassField.clearButtonMode = UITextFieldViewModeWhileEditing;
    confirmPassField.delegate = self;
    confirmPassField.keyboardType = UIKeyboardTypeDefault;
    confirmPassField.backgroundColor = [UIColor whiteColor];
    confirmPassField.returnKeyType = UIReturnKeyDone;
    confirmPassField.secureTextEntry = YES;
    [confirmPassField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    confirmPassField.tag = 3;
    
    submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [submitButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    submitButton.tag = 1;
    submitButton.frame = CGRectMake(0, self.view.bounds.size.height-110, self.view.bounds.size.width, 45);
    [submitButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    [submitButton setBackgroundColor:RGB(86, 46, 120)];
    [self.view addSubview:submitButton];

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
