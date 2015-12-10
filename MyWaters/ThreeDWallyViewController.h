//
//  ThreeDWallyViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 9/12/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ThreeDWallyViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate> {
    
    UIImagePickerController *imagePicker;
    AppDelegate *appDelegate;
    
    UIButton *wallyButton1,*wallyButton2,*wallyButton3;
}

@end
