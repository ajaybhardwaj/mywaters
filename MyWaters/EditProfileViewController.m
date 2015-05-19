//
//  EditProfileViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 23/4/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController



//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



//*************** Method For Handling Edit Profile Actions

- (void) handleEitProfileActions:(id) sender {
    
    UIButton *button = (id) sender;
    if (button.tag==1) {
        
    }
    else if (button.tag==2) {
        
        ChangePasswordViewController *viewObj = [[ChangePasswordViewController alloc] init];
        [self.navigationController pushViewController:viewObj animated:YES];
    }
}



# pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField==nameField) {
        [emailField becomeFirstResponder];
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
    
    self.title = @"Edit Profile";
    self.view.backgroundColor = RGB(247, 247, 247);
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];

    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 40)];
    nameField.textColor = RGB(35, 35, 35);
    nameField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    nameField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    nameField.leftViewMode = UITextFieldViewModeAlways;
    nameField.borderStyle = UITextBorderStyleNone;
    nameField.textAlignment=NSTextAlignmentLeft;
    [nameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    nameField.placeholder=@"Name *";
    [self.view addSubview:nameField];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.delegate = self;
    nameField.keyboardType = UIKeyboardTypeDefault;
    nameField.backgroundColor = [UIColor whiteColor];
    nameField.returnKeyType = UIReturnKeyNext;
    [nameField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    nameField.tag = 1;
    
    emailField = [[UITextField alloc] initWithFrame:CGRectMake(0, nameField.frame.origin.y+nameField.bounds.size.height+1, self.view.bounds.size.width, 40)];
    emailField.textColor = RGB(35, 35, 35);
    emailField.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15.0];
    emailField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    emailField.leftViewMode = UITextFieldViewModeAlways;
    emailField.borderStyle = UITextBorderStyleNone;
    emailField.textAlignment=NSTextAlignmentLeft;
    [emailField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    emailField.placeholder=@"Email *";
    [self.view addSubview:emailField];
    emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailField.delegate = self;
    emailField.keyboardType = UIKeyboardTypeEmailAddress;
    emailField.backgroundColor = [UIColor whiteColor];
    emailField.returnKeyType = UIReturnKeyDefault;
    [emailField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    emailField.tag = 2;
    
    
    updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateButton setTitle:@"UPDATE" forState:UIControlStateNormal];
    [updateButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    updateButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    updateButton.tag = 1;
    updateButton.frame = CGRectMake(0, self.view.bounds.size.height-110, self.view.bounds.size.width, 45);
    [updateButton addTarget:self action:@selector(handleEitProfileActions:) forControlEvents:UIControlEventTouchUpInside];
    [updateButton setBackgroundColor:RGB(86, 46, 120)];
    [self.view addSubview:updateButton];
    
    changePasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changePasswordButton setTitle:@"CHANGE PASSWORD" forState:UIControlStateNormal];
    [changePasswordButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
    changePasswordButton.titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:15];
    changePasswordButton.tag = 2;
    changePasswordButton.frame = CGRectMake(0, updateButton.frame.origin.y-50, self.view.bounds.size.width, 45);
    [changePasswordButton addTarget:self action:@selector(handleEitProfileActions:) forControlEvents:UIControlEventTouchUpInside];
    [changePasswordButton setBackgroundColor:RGB(200, 0, 0)];
    [self.view addSubview:changePasswordButton];
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
