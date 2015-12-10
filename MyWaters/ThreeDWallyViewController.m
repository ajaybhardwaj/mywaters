//
//  ThreeDWallyViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 9/12/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import "ThreeDWallyViewController.h"

@interface ThreeDWallyViewController ()

@end

@interface UIDevice (MyPrivateNameThatAppleWouldNeverUseGoesHere)
- (void) setOrientation:(UIInterfaceOrientation)orientation;
@end

@implementation ThreeDWallyViewController




//*************** Method For Moving To AR View

- (void) moveBackToARView {
    
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight animated:NO];
    [self.navigationController popViewControllerAnimated:NO];
}


//*************** Method For Launching Camera View After Delay

- (void) launchCameraView {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIView *customCameraOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
        
        wallyButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
        wallyButton1.frame = CGRectMake((customCameraOverlayView.bounds.size.width-270)/4, 40, 90, 90);
        [wallyButton1 setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/pose1.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [customCameraOverlayView addSubview:wallyButton1];
        
        wallyButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        wallyButton2.frame = CGRectMake(((customCameraOverlayView.bounds.size.width-270)/4)*2+90, 40, 90, 90);
        [wallyButton2 setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/pose2.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [customCameraOverlayView addSubview:wallyButton2];
        
        wallyButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
        wallyButton3.frame = CGRectMake(((customCameraOverlayView.bounds.size.width-270)/4)*3+180, 40, 90, 90);
        [wallyButton3 setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/pose3.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        [customCameraOverlayView addSubview:wallyButton3];
        
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = YES;
        imagePicker.allowsEditing = YES;
        
        imagePicker.cameraOverlayView = customCameraOverlayView;
        
        [self presentViewController:imagePicker animated:NO completion:nil];
    }
}


# pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight animated:NO];
    [self performSelector:@selector(moveBackToARView) withObject:nil afterDelay:0.5];
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [appDelegate setShouldRotate:NO];
    [self.navigationController setNavigationBarHidden:YES];

    self.view.backgroundColor = RGB(0, 0, 0);
    //    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:NO];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self performSelector:@selector(launchCameraView) withObject:nil afterDelay:0.5];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    [appDelegate setShouldRotate:NO];
    [self.navigationController setNavigationBarHidden:YES];
//    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationPortrait animated:NO];
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
