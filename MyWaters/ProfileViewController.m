//
//  ProfileViewController.m
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "ProfileViewController.h"
#import "ViewControllerHelper.h"
#import "RewardDetailsViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController


//*************** Method To Move To Photo Gallery

- (void) tapToMoveToPhotoGallery:(id) sender {
    
    
    if (photoDataSourceForGallery.count!=0) {
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        [self.navigationController pushViewController:networkGallery animated:YES];
    }
    
    //    GalleryViewController *viewObj = [[GalleryViewController alloc] init];
    //    viewObj.galleryImages = photosDataSource;
    //    viewObj.isABCGallery = NO;
    //    viewObj.isUserGallery = YES;
    //    viewObj.isPOIGallery = NO;
    //    [self.navigationController pushViewController:viewObj animated:YES];
}


//*************** Method To Show Badges Description ALerts

- (void) showBadgesDescPopUp:(id) sender {
    
    UIButton *button = (id) sender;
    //    NSString *alertTitle = [[badgesDataSource objectAtIndex:button.tag-1] objectForKey:@"Name"];
    NSString *alertMessage = [[badgesDataSource objectAtIndex:button.tag-1] objectForKey:@"Description"];
    
    if ([[badgesDataSource objectAtIndex:button.tag-1] objectForKey:@"UnlockedAt"] != (id)[NSNull null]) {
        isBadgeUnlocked = YES;
        [CommonFunctions showAlertView:self title:nil msg:alertMessage cancel:nil otherButton:@"Share on Facebook",@"Cancel",nil];
    }
    else {
        isBadgeUnlocked = NO;
        [CommonFunctions showAlertView:self title:nil msg:alertMessage cancel:@"OK" otherButton:nil];
    }
}


//*************** Method To Move To Edit Profile View

- (void) moveToEditProfile {
    
    EditProfileViewController *viewObj = [[EditProfileViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:YES];
}


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}


//*************** Demo App Controls Action Handler

- (void) handleDemoControls:(id) sender {
    
    RewardsListingViewController *viewObj = [[RewardsListingViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:NO];
}



//*************** Demo App UI

- (void) createDemoAppControls {
    
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-60)];
    [self.view addSubview:bgImageView];
    [bgImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/profile.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    
    
    rewardsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rewardsButton.tag = 1;
    rewardsButton.frame = CGRectMake(0, self.view.bounds.size.height-100, self.view.bounds.size.width, 50);
    [rewardsButton addTarget:self action:@selector(handleDemoControls:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rewardsButton];
    
    
    
}



//*************** Method To Call Get Config API

- (void) getOtherProfileData {
    
    [CommonFunctions showGlobalProgressHUDWithTitle:@"Loading..."];
    //    appDelegate.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    appDelegate.hud.mode = MBProgressHUDModeIndeterminate;
    //    appDelegate.hud.labelText = @"Loading...";
    
    [CommonFunctions grabGetRequest:USER_PROFILE_OTHERS_DATA delegate:self isNSData:NO accessToken:[[SharedObject sharedClass] getPUBUserSavedDataValue:@"AccessToken"]];
    
    
}


//*************** Method To Handle Tab Button Actions

- (void) handleTabButtons:(id) sender {
    
    UIButton *button = (id) sender;
    
    if (button.tag==1) {
        
        badgesBackgroundView.hidden = NO;
        pointsTableView.hidden = YES;
        rewardsListingTableView.hidden = YES;
        photosBackgroundView.hidden = YES;
        
        badgesButton.userInteractionEnabled = NO;
        pointsButton.userInteractionEnabled = YES;
        rewardsButton.userInteractionEnabled = YES;
        photosButton.userInteractionEnabled = YES;
        
        [badgesButton setBackgroundColor:RGB(83, 83, 83)];
        [badgesIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_award_white.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        badgesLabel.textColor = RGB(255,255,255);
        
        [pointsButton setBackgroundColor:[UIColor clearColor]];
        [pointsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_money_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        pointsLabel.textColor = RGB(83, 83, 83);
        
        [rewardsButton setBackgroundColor:[UIColor clearColor]];
        [rewardsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_gift_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        rewardsLabel.textColor = RGB(83, 83, 83);
        
        [photosButton setBackgroundColor:[UIColor clearColor]];
        [photosIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_poloroid_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        photosLabel.textColor = RGB(83, 83, 83);
        
        [self refreshBadgesScrollView];
        
    }
    else if (button.tag==2) {
        
        badgesBackgroundView.hidden = YES;
        pointsTableView.hidden = NO;
        rewardsListingTableView.hidden = YES;
        photosBackgroundView.hidden = YES;
        
        badgesButton.userInteractionEnabled = YES;
        pointsButton.userInteractionEnabled = NO;
        rewardsButton.userInteractionEnabled = YES;
        photosButton.userInteractionEnabled = YES;
        
        [badgesButton setBackgroundColor:[UIColor clearColor]];
        [badgesIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_award_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        badgesLabel.textColor = RGB(83, 83, 83);
        
        [pointsButton setBackgroundColor:RGB(83, 83, 83)];
        [pointsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_money_white.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        pointsLabel.textColor = RGB(255,255,255);
        
        [rewardsButton setBackgroundColor:[UIColor clearColor]];
        [rewardsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_gift_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        rewardsLabel.textColor = RGB(83, 83, 83);
        
        [photosButton setBackgroundColor:[UIColor clearColor]];
        [photosIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_poloroid_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        photosLabel.textColor = RGB(83, 83, 83);
        
        [pointsTableView reloadData];
        
    }
    else if (button.tag==3) {
        
        badgesBackgroundView.hidden = YES;
        pointsTableView.hidden = YES;
        rewardsListingTableView.hidden = NO;
        photosBackgroundView.hidden = YES;
        
        badgesButton.userInteractionEnabled = YES;
        pointsButton.userInteractionEnabled = YES;
        rewardsButton.userInteractionEnabled = NO;
        photosButton.userInteractionEnabled = YES;
        
        [badgesButton setBackgroundColor:[UIColor clearColor]];
        [badgesIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_award_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        badgesLabel.textColor = RGB(83, 83, 83);
        
        [pointsButton setBackgroundColor:[UIColor clearColor]];
        [pointsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_money_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        pointsLabel.textColor = RGB(83, 83, 83);
        
        [rewardsButton setBackgroundColor:RGB(83, 83, 83)];
        [rewardsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_gift_white.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        rewardsLabel.textColor = RGB(255,255,255);
        
        [photosButton setBackgroundColor:[UIColor clearColor]];
        [photosIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_poloroid_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        photosLabel.textColor = RGB(83, 83, 83);
        
        [rewardsListingTableView reloadData];
        
    }
    else if (button.tag==4) {
        
        badgesBackgroundView.hidden = YES;
        pointsTableView.hidden = YES;
        rewardsListingTableView.hidden = YES;
        photosBackgroundView.hidden = NO;
        
        badgesButton.userInteractionEnabled = YES;
        pointsButton.userInteractionEnabled = YES;
        rewardsButton.userInteractionEnabled = YES;
        photosButton.userInteractionEnabled = NO;
        
        [badgesButton setBackgroundColor:[UIColor clearColor]];
        [badgesIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_award_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        badgesLabel.textColor = RGB(83, 83, 83);
        
        [pointsButton setBackgroundColor:[UIColor clearColor]];
        [pointsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_money_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        pointsLabel.textColor = RGB(83, 83, 83);
        
        [rewardsButton setBackgroundColor:[UIColor clearColor]];
        [rewardsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_gift_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        rewardsLabel.textColor = RGB(83, 83, 83);
        
        [photosButton setBackgroundColor:RGB(83, 83, 83)];
        [photosIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_poloroid_white.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
        photosLabel.textColor = RGB(255,255,255);
        
        [self refreshMyPhotosScrollView];
        
    }
}



//*************** Method To Refresh My Photos ScrollView

- (void) refreshMyPhotosScrollView {
    
    for (UIView * view in photosScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    int counter = 0;
    int heightCounter = 1;
    float xAxis = 0;
    float yAxis = 0;
    
    for (int i=0; i<photosDataSource.count; i++) {
        
        DebugLog(@"Counter %d --- %d",counter,i);
        
        if (counter==3) {
            
            
            xAxis = 0;
            yAxis = yAxis + photosScrollView.bounds.size.width/3 + 0.5;
            
            DebugLog(@"If X-Axis %f --- Y-Axis %f",xAxis,yAxis);
            
            heightCounter = heightCounter + 1;
            counter = 0;
            
            UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, yAxis, photosScrollView.bounds.size.width/3 - 1, photosScrollView.bounds.size.width/3)];
            badgeImageView.tag = i+1;
            [photosScrollView addSubview:badgeImageView];
            badgeImageView.userInteractionEnabled = YES;
            
            UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tapButton.frame = CGRectMake(0, 0, badgeImageView.bounds.size.width, badgeImageView.bounds.size.height);
            tapButton.tag = i;
            [tapButton addTarget:self action:@selector(tapToMoveToPhotoGallery:) forControlEvents:UIControlEventTouchUpInside];
            [badgeImageView addSubview:tapButton];
            
            NSString *imageName = [photosDataSource objectAtIndex:i];
            //            imageName = [imageName stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[photosDataSource objectAtIndex:i]];
            
            
            NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
            NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserProfileUpload"]];
            
            NSString *localFile = [destinationPath stringByAppendingPathComponent:imageName];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
                if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]] != nil)
                    badgeImageView.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]];
            }
            
            else {
                
                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator.center = CGPointMake(badgeImageView.bounds.size.width/2, badgeImageView.bounds.size.height/2);
                [badgeImageView addSubview:activityIndicator];
                [activityIndicator startAnimating];
                
                [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
                    if (succeeded) {
                        
                        badgeImageView.image = image;
                        
                        NSFileManager *fileManger=[NSFileManager defaultManager];
                        NSError* error;
                        
                        if (![fileManger fileExistsAtPath:destinationPath]){
                            
                            if([[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:&error])
                                ;// success
                            else
                            {
                                DebugLog(@"[%@] ERROR: attempting to write create MyTasks directory", [self class]);
                                NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
                            }
                        }
                        
                        NSData *data = UIImageJPEGRepresentation(image, 0.8);
                        [data writeToFile:[destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]] atomically:YES];
                    }
                    else {
                        DebugLog(@"Image Loading Failed..!!");
                    }
                    [activityIndicator stopAnimating];
                }];
            }
            
        }
        else {
            
            DebugLog(@"Else X-Axis %f --- Y-Axis %f",xAxis,yAxis);
            
            UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, yAxis, photosScrollView.bounds.size.width/3 - 1, photosScrollView.bounds.size.width/3)];
            //            [badgeImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/dummy_my_pic_new.jpeg",appDelegate.RESOURCE_FOLDER_PATH]]];
            badgeImageView.tag = i+1;
            [photosScrollView addSubview:badgeImageView];
            badgeImageView.userInteractionEnabled = YES;
            
            UIButton *tapButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tapButton.frame = CGRectMake(0, 0, badgeImageView.bounds.size.width, badgeImageView.bounds.size.height);
            tapButton.tag = i;
            [tapButton addTarget:self action:@selector(tapToMoveToPhotoGallery:) forControlEvents:UIControlEventTouchUpInside];
            [badgeImageView addSubview:tapButton];
            
            NSString *imageName = [photosDataSource objectAtIndex:i];
            //            imageName = [imageName stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
            NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[photosDataSource objectAtIndex:i]];
            
            
            NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
            NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserProfileUpload"]];
            
            NSString *localFile = [destinationPath stringByAppendingPathComponent:imageName];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
                if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]] != nil)
                    badgeImageView.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]];
            }
            
            else {
                
                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator.center = CGPointMake(badgeImageView.bounds.size.width/2, badgeImageView.bounds.size.height/2);
                [badgeImageView addSubview:activityIndicator];
                [activityIndicator startAnimating];
                
                [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
                    if (succeeded) {
                        
                        badgeImageView.image = image;
                        
                        NSFileManager *fileManger=[NSFileManager defaultManager];
                        NSError* error;
                        
                        if (![fileManger fileExistsAtPath:destinationPath]){
                            
                            if([[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:&error])
                                ;// success
                            else
                            {
                                DebugLog(@"[%@] ERROR: attempting to write create MyTasks directory", [self class]);
                                NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
                            }
                        }
                        
                        NSData *data = UIImageJPEGRepresentation(image, 0.8);
                        [data writeToFile:[destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]] atomically:YES];
                    }
                    else {
                        DebugLog(@"Image Loading Failed..!!");
                    }
                    [activityIndicator stopAnimating];
                }];
            }
            
            xAxis = xAxis + photosScrollView.bounds.size.width/3 + 0.5;
            counter = counter + 1;
        }
        
    }
    photosScrollView.contentSize = CGSizeMake(photosScrollView.bounds.size.width, (heightCounter*(photosScrollView.bounds.size.width)/3)+40);
}



//*************** Method To Refresh My Badges ScrollView

- (void) refreshBadgesScrollView {
    
    for (UIView * view in badgesScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    int counter = 0;
    int heightCounter = 1;
    float xAxis = 20;
    float yAxis = 5;
    
    for (int i=0; i<badgesDataSource.count; i++) {
        
        if (counter==3) {
            
            heightCounter = heightCounter + 1;
            counter = 0;
            
            UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, yAxis, (badgesScrollView.bounds.size.width-75)/4, (badgesScrollView.bounds.size.width-75)/4)];
            badgeImageView.tag = i+1;
            [badgeImageView setBackgroundColor:[UIColor clearColor]];
            badgeImageView.opaque = NO;
            [badgesScrollView addSubview:badgeImageView];
            badgeImageView.userInteractionEnabled = YES;
            
            UIButton *popUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
            popUpButton.frame = CGRectMake(0, 0, badgeImageView.bounds.size.width, badgeImageView.bounds.size.height);
            popUpButton.tag = i+1;
            [popUpButton addTarget:self action:@selector(showBadgesDescPopUp:) forControlEvents:UIControlEventTouchUpInside];
            [badgeImageView addSubview:popUpButton];
            
            NSString *imageName,*imageURLString;
            
            NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
            NSString *destinationPath;//=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ProfileBadges"]];
            
            
            imageName = [[badgesDataSource objectAtIndex:i] objectForKey:@"Image"];
            
            if ([[badgesDataSource objectAtIndex:i] objectForKey:@"UnlockedAt"] == (id)[NSNull null]) {
                imageURLString = [NSString stringWithFormat:@"%@grey/%@",IMAGE_BASE_URL,[[badgesDataSource objectAtIndex:i] objectForKey:@"Image"]];
                destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ProfileBadges/Grey"]];
                
            }
            else {
                destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ProfileBadges"]];
                imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[badgesDataSource objectAtIndex:i] objectForKey:@"Image"]];
            }
            
            DebugLog(@"%@",imageURLString);
            
            
            
            NSString *localFile = [destinationPath stringByAppendingPathComponent:imageName];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
                if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]] != nil)
                    badgeImageView.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]];
            }
            
            else {
                
                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator.center = CGPointMake(badgeImageView.bounds.size.width/2, badgeImageView.bounds.size.height/2);
                [badgeImageView addSubview:activityIndicator];
                [activityIndicator startAnimating];
                
                [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
                    if (succeeded) {
                        
                        badgeImageView.image = image;
                        
                        NSFileManager *fileManger=[NSFileManager defaultManager];
                        NSError* error;
                        
                        if (![fileManger fileExistsAtPath:destinationPath]){
                            
                            if([[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:&error])
                                ;// success
                            else
                            {
                                DebugLog(@"[%@] ERROR: attempting to write create MyTasks directory", [self class]);
                                NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
                            }
                        }
                        
                        NSData *data = UIImagePNGRepresentation(image);
                        [data writeToFile:[destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]] atomically:YES];
                    }
                    else {
                        DebugLog(@"Image Loading Failed..!!");
                    }
                    [activityIndicator stopAnimating];
                }];
            }
            
            yAxis = yAxis + (badgesScrollView.bounds.size.width-100)/4 +20;
            xAxis = 20;
        }
        else {
            
            UIImageView *badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xAxis, yAxis, (badgesScrollView.bounds.size.width-75)/4, (badgesScrollView.bounds.size.width-75)/4)];
            badgeImageView.tag = i+1;
            [badgeImageView setBackgroundColor:[UIColor clearColor]];
            badgeImageView.opaque = NO;
            [badgesScrollView addSubview:badgeImageView];
            badgeImageView.userInteractionEnabled = YES;
            
            UIButton *popUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
            popUpButton.frame = CGRectMake(0, 0, badgeImageView.bounds.size.width, badgeImageView.bounds.size.height);
            popUpButton.tag = i+1;
            [popUpButton addTarget:self action:@selector(showBadgesDescPopUp:) forControlEvents:UIControlEventTouchUpInside];
            [badgeImageView addSubview:popUpButton];
            
            NSString *imageName,*imageURLString;
            NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
            NSString *destinationPath;//=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ProfileBadges"]];
            
            imageName = [[badgesDataSource objectAtIndex:i] objectForKey:@"Image"];
            
            if ([[badgesDataSource objectAtIndex:i] objectForKey:@"UnlockedAt"] == (id)[NSNull null]) {
                destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ProfileBadges/Grey"]];
                imageURLString = [NSString stringWithFormat:@"%@grey/%@",IMAGE_BASE_URL,[[badgesDataSource objectAtIndex:i] objectForKey:@"Image"]];
                
            }
            else {
                destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ProfileBadges"]];
                imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[badgesDataSource objectAtIndex:i] objectForKey:@"Image"]];
            }
            
            DebugLog(@"%@",imageURLString);
            
            
            NSString *localFile = [destinationPath stringByAppendingPathComponent:imageName];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
                if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]] != nil)
                    badgeImageView.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]];
            }
            
            else {
                
                UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityIndicator.center = CGPointMake(badgeImageView.bounds.size.width/2, badgeImageView.bounds.size.height/2);
                [badgeImageView addSubview:activityIndicator];
                [activityIndicator startAnimating];
                
                [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
                    if (succeeded) {
                        
                        badgeImageView.image = image;
                        
                        NSFileManager *fileManger=[NSFileManager defaultManager];
                        NSError* error;
                        
                        if (![fileManger fileExistsAtPath:destinationPath]){
                            
                            if([[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:&error])
                                ;// success
                            else
                            {
                                DebugLog(@"[%@] ERROR: attempting to write create MyTasks directory", [self class]);
                                NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
                            }
                        }
                        
                        NSData *data = UIImagePNGRepresentation(image);
                        [data writeToFile:[destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]] atomically:YES];
                    }
                    else {
                        DebugLog(@"Image Loading Failed..!!");
                    }
                    [activityIndicator stopAnimating];
                }];
            }
            
            xAxis = xAxis + (badgesScrollView.bounds.size.width-100)/4 + 20;
            counter = counter + 1;
        }
        
    }
    
    badgesScrollView.contentSize = CGSizeMake(badgesScrollView.bounds.size.width, (heightCounter*(badgesScrollView.bounds.size.width)/4)+80);
}



//*************** Method To Show Badges Tool Tip

- (void) showBadgesToolTip:(id)sender {
    
    //    UIImageView *toolTipView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 250.0f)];
    //    toolTipView.backgroundColor = [UIColor whiteColor];
    //
    //    CGRect frameValue = sender.frame;
    //    frameValue.origin.y = frameValue.origin.y + 180;
    //
    //    AKETooltip *tooltip = [[AKETooltip alloc] initWithContentView:toolTipView sourceRect:frameValue parentWindow:self.view.window];
    //
    //    tooltip.hideShadow = NO;
    //    tooltip.arrowColor = RGB(85,49,118);
    //    tooltip.borderColor = [UIColor whiteColor];//RGB(85,49,118);
    //    tooltip.layer.cornerRadius = 10.0;
    //    [tooltip show];
    //
    //
    //    NSString *imageURLString = [NSString stringWithFormat:@"%@/info/badge.png",IMAGE_BASE_URL];
    //
    //    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    activityIndicator.center = CGPointMake(toolTipView.bounds.size.width/2, toolTipView.bounds.size.height/2);
    //    [toolTipView addSubview:activityIndicator];
    //    [activityIndicator startAnimating];
    //
    //    [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
    //        if (succeeded) {
    //
    //            toolTipView.image = image;
    //
    //        }
    //        [activityIndicator stopAnimating];
    //    }];
    
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    
    UIImageView *toolTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 250.0f, 250.0f)];
    toolTipImageView.layer.cornerRadius = 10.0;
    toolTipImageView.layer.masksToBounds = YES;
    toolTipImageView.backgroundColor = [UIColor whiteColor];
    
    NSString *imageURLString = [NSString stringWithFormat:@"%@/info/badge.png",IMAGE_BASE_URL];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = CGPointMake(toolTipImageView.bounds.size.width/2, toolTipImageView.bounds.size.height/2);
    [toolTipImageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            
            toolTipImageView.image = image;
            
        }
        [activityIndicator stopAnimating];
    }];
    
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [alertView close];
    }];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Close", nil]];
    [alertView setUseMotionEffects:true];
    [alertView setContainerView:toolTipImageView];
    [alertView show];
    
    [self.view addSubview:alertView];
    
}


# pragma mark - ASIHTTPRequestDelegate Methods

- (void) requestFinished:(ASIHTTPRequest *)request {
    
    // Use when fetching text data
    NSString *responseString = [request responseString];
    [CommonFunctions dismissGlobalHUD];
    //    [appDelegate.hud hide:YES];
    
    if ([[[responseString JSONValue] objectForKey:API_ACKNOWLEDGE] intValue] == true) {
        
        [photosDataSource removeAllObjects];
        [badgesDataSource removeAllObjects];
        [rewardsDataSource removeAllObjects];
        [pointsDataSource removeAllObjects];
        
        pointsValue = [NSString stringWithFormat:@"%d",[[[[responseString JSONValue] objectForKey:@"UserProfile"] objectForKey:@"CurrentRewardPoints"] intValue]];
        
        [photosDataSource setArray:[[responseString JSONValue] objectForKey:USER_UPLOADED_IMAGES_RESPONSE_NAME]];
        [badgesDataSource setArray:[[responseString JSONValue] objectForKey:USER_BADGES_RESPONSE_NAME]];
        [rewardsDataSource setArray:[[responseString JSONValue] objectForKey:REWARDS_RESPONSE_NAME]];
        [pointsDataSource setArray:[[responseString JSONValue] objectForKey:USER_ACTION_HISTORY_RESPONSE_NAME]];
        
        [photoDataSourceForGallery removeAllObjects];
        
        for (int i=0; i<photosDataSource.count; i++) {
            [photoDataSourceForGallery addObject:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[photosDataSource objectAtIndex:i]]];
        }
        
        //        photosDataSource = [[responseString JSONValue] objectForKey:USER_UPLOADED_IMAGES_RESPONSE_NAME];
        //        badgesDataSource = [[responseString JSONValue] objectForKey:USER_BADGES_RESPONSE_NAME];
        //        rewardsDataSource = [[responseString JSONValue] objectForKey:REWARDS_RESPONSE_NAME];
        //        pointsDataSource = [[responseString JSONValue] objectForKey:USER_ACTION_HISTORY_RESPONSE_NAME];
        
        DebugLog(@"%@",photosDataSource);
        DebugLog(@"%@",badgesDataSource);
        DebugLog(@"%@",rewardsDataSource);
        DebugLog(@"%@",pointsDataSource);
        
        [self refreshBadgesScrollView];
        
    }
    else {
        [CommonFunctions showAlertView:nil title:nil msg:[[responseString JSONValue] objectForKey:API_MESSAGE] cancel:@"OK" otherButton:nil];
    }
}

- (void) requestFailed:(ASIHTTPRequest *)request {
    
    NSError *error = [request error];
    DebugLog(@"%@",[error description]);
    [CommonFunctions showAlertView:nil title:nil msg:[error description] cancel:@"OK" otherButton:nil];
    [CommonFunctions dismissGlobalHUD];
    //    [appDelegate.hud hide:YES];
}



# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    float titleHeight = 0.0;
    float subTitleHeight = 0.0;
    float dateHeight = 0.0;
    int subtractComponent = 0;
    
    if (tableView==rewardsListingTableView) {
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Name"] != (id)[NSNull null]) {
            titleHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Name"]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:14.0] withinWidth:rewardsListingTableView.bounds.size.width-85];
            subtractComponent = subtractComponent + 25;
        }
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"PointsToRedeem"] != (id)[NSNull null]) {
            subTitleHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"PointsToRedeem"]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0] withinWidth:rewardsListingTableView.bounds.size.width-90];
            subtractComponent = subtractComponent + 25;
        }
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"LocationName"] != (id)[NSNull null]) {
            dateHeight = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[CommonFunctions dateTimeFromString:[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"LocationName"]]] font:[UIFont fontWithName:ROBOTO_MEDIUM size:13.0] withinWidth:rewardsListingTableView.bounds.size.width-85];
            subtractComponent = subtractComponent + 25;
        }
        
        if ((titleHeight+subTitleHeight+dateHeight) < 90) {
            return 90.0f;
        }
        
        return titleHeight+subTitleHeight+dateHeight-subtractComponent;
        
    }
    else if (tableView==pointsTableView) {
        return 70.0f;
    }
    
    return 0.0f;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==pointsTableView) {
        return 90.0f;
    }
    
    return 0.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView==pointsTableView) {
        
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pointsTableView.bounds.size.width, 90)];
        sectionHeaderView.backgroundColor = RGB(255, 255, 255);
        
        UILabel *pointsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, sectionHeaderView.bounds.size.width, 16)];
        pointsTitleLabel.backgroundColor = [UIColor clearColor];
        pointsTitleLabel.textColor = RGB(58, 58, 58);
        pointsTitleLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:13.0];
        pointsTitleLabel.text = @"Current points:";
        pointsTitleLabel.textAlignment = NSTextAlignmentCenter;
        [sectionHeaderView addSubview:pointsTitleLabel];
        
        
        UILabel *pointsValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, sectionHeaderView.bounds.size.width, 30)];
        pointsValueLabel.backgroundColor = [UIColor clearColor];
        pointsValueLabel.textColor = RGB(82, 82, 82);
        pointsValueLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:28.0];
        pointsValueLabel.text = pointsValue;
        pointsValueLabel.textAlignment = NSTextAlignmentCenter;
        [sectionHeaderView addSubview:pointsValueLabel];
        
        return sectionHeaderView;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView==rewardsListingTableView) {
        
        RewardDetailsViewController *viewObj = [[RewardDetailsViewController alloc] init];
        
        viewObj.currentPointsString = pointsValue;
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"ID"] != (id)[NSNull null])
            viewObj.rewardID = [NSString stringWithFormat:@"%d",[[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"ID"] intValue]];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Name"] != (id)[NSNull null])
            viewObj.titleString = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Name"];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Description"] != (id)[NSNull null])
            viewObj.descriptionString = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Description"];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Lat"] != (id)[NSNull null])
            viewObj.latValue = [[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Lat"] doubleValue];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Lon"] != (id)[NSNull null])
            viewObj.longValue = [[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Lon"] doubleValue];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"ValidFrom"] != (id)[NSNull null]) {
            viewObj.validFromDateString = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"ValidFrom"];
            viewObj.validFromDateString = [CommonFunctions dateTimeFromString:viewObj.validFromDateString];
        }
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"ValidTo"] != (id)[NSNull null]) {
            viewObj.validTillDateString = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"ValidTo"];
            viewObj.validTillDateString = [CommonFunctions dateTimeFromString:viewObj.validTillDateString];
        }
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"LocationName"] != (id)[NSNull null])
            viewObj.locationValueString = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"LocationName"];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"PointsToRedeem"] != (id)[NSNull null])
            viewObj.pointsValueString = [NSString stringWithFormat:@"%d",[[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"PointsToRedeem"] intValue]];
        
        if ([[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Image"] != (id)[NSNull null]) {
            viewObj.imageUrl = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Image"]];
            viewObj.imageName = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Image"];
        }
        
        
        [self.navigationController pushViewController:viewObj animated:YES];
    }
    else if (tableView==pointsTableView) {
        
    }
}


# pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==rewardsListingTableView) {
        return rewardsDataSource.count;
    }
    else if (tableView==pointsTableView) {
        return pointsDataSource.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==rewardsListingTableView) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rewardsCell"];
        cell.backgroundColor = RGB(247, 247, 247);
        
        UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 70, 70)];
        [cell.contentView addSubview:cellImage];
        
        NSString *imageURLString,*imageName;
        imageName = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Image"];
        imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Image"]];
        [cell.contentView addSubview:cellImage];
        
        
        NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
        NSString *destinationPath=[doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"Rewards"]];
        
        NSString *localFile = [destinationPath stringByAppendingPathComponent:imageName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
            if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]] != nil)
                cellImage.image = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]];
        }
        
        else {
            
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.center = CGPointMake(cellImage.bounds.size.width/2, cellImage.bounds.size.height/2);
            [cellImage addSubview:activityIndicator];
            [activityIndicator startAnimating];
            
            [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    
                    cellImage.image = image;
                    
                    NSFileManager *fileManger=[NSFileManager defaultManager];
                    NSError* error;
                    
                    if (![fileManger fileExistsAtPath:destinationPath]){
                        
                        if([[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:&error])
                            ;// success
                        else
                        {
                            DebugLog(@"[%@] ERROR: attempting to write create MyTasks directory", [self class]);
                            NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
                        }
                    }
                    
                    NSData *data = UIImageJPEGRepresentation(image, 0.8);
                    [data writeToFile:[destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]] atomically:YES];
                }
                else {
                    DebugLog(@"Image Loading Failed..!!");
                    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/Icon_180.png",appDelegate.RESOURCE_FOLDER_PATH]];
                }
                [activityIndicator stopAnimating];
            }];
        }
        
        
        UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, rewardsListingTableView.bounds.size.width-100, 40)];
        cellTitleLabel.text = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Name"];
        cellTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        cellTitleLabel.backgroundColor = [UIColor clearColor];
        cellTitleLabel.numberOfLines = 0;
        [cell.contentView addSubview:cellTitleLabel];
        
        CGRect newTitleLabelLabelFrame = cellTitleLabel.frame;
        newTitleLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"Name"]] font:cellTitleLabel.font withinWidth:rewardsListingTableView.bounds.size.width-100];//expectedDescriptionLabelSize.height;
        cellTitleLabel.frame = newTitleLabelLabelFrame;
        [cell.contentView addSubview:cellTitleLabel];
        
        [cell.contentView addSubview:cellTitleLabel];
        [cellTitleLabel sizeToFit];
        
        
        UILabel *cellPointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, cellTitleLabel.frame.origin.y+cellTitleLabel.bounds.size.height+5, rewardsListingTableView.bounds.size.width-100, 13)];
        cellPointsLabel.text = [NSString stringWithFormat:@"%d",[[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"PointsToRedeem"] intValue]];
        cellPointsLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
        cellPointsLabel.backgroundColor = [UIColor clearColor];
        cellPointsLabel.textColor = [UIColor lightGrayColor];
        cellPointsLabel.numberOfLines = 0;
        [cell.contentView addSubview:cellPointsLabel];
        
        
        CGRect newSubTitleLabelLabelFrame = cellPointsLabel.frame;
        newSubTitleLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"PointsToRedeem"]] font:cellPointsLabel.font withinWidth:rewardsListingTableView.bounds.size.width-100];//expectedDescriptionLabelSize.height;
        cellPointsLabel.frame = newSubTitleLabelLabelFrame;
        [cell.contentView addSubview:cellPointsLabel];
        [cellPointsLabel sizeToFit];
        
        
        UILabel *cellPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, cellPointsLabel.frame.origin.y+cellPointsLabel.bounds.size.height+5, rewardsListingTableView.bounds.size.width-100, 35)];
        cellPlaceLabel.text = [[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"LocationName"];
        cellPlaceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
        cellPlaceLabel.backgroundColor = [UIColor clearColor];
        cellPlaceLabel.textColor = [UIColor lightGrayColor];
        cellPlaceLabel.numberOfLines = 0;
        [cell.contentView addSubview:cellPlaceLabel];
        
        CGRect newDateLabelLabelFrame = cellPlaceLabel.frame;
        newDateLabelLabelFrame.size.height = [CommonFunctions heightForText:[NSString stringWithFormat:@"%@",[CommonFunctions dateTimeFromString:[[rewardsDataSource objectAtIndex:indexPath.row] objectForKey:@"LocationName"]]] font:cellPlaceLabel.font withinWidth:rewardsListingTableView.bounds.size.width-100];//expectedDescriptionLabelSize.height;
        cellPlaceLabel.frame = newDateLabelLabelFrame;
        [cell.contentView addSubview:cellPlaceLabel];
        [cellPlaceLabel sizeToFit];
        
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 99.5, rewardsListingTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    else if (tableView==pointsTableView) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pointsCell"];
        cell.backgroundColor = RGB(247, 247, 247);
        
        
        UILabel *cellTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, pointsTableView.bounds.size.width-20, 45)];
        cellTitleLabel.text = [[pointsDataSource objectAtIndex:indexPath.row] objectForKey:@"Description"];
        cellTitleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
        cellTitleLabel.backgroundColor = [UIColor clearColor];
        cellTitleLabel.numberOfLines = 0;
        [cellTitleLabel sizeToFit];
        [cell.contentView addSubview:cellTitleLabel];
        
        
        UILabel *cellTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, pointsTableView.bounds.size.width-20, 15)];
        cellTimeLabel.text = [CommonFunctions dateForRFC3339DateTimeString:[[pointsDataSource objectAtIndex:indexPath.row] objectForKey:@"ActionDate"]];
        cellTimeLabel.font = [UIFont fontWithName:ROBOTO_REGULAR size:11.0];
        cellTimeLabel.backgroundColor = [UIColor clearColor];
        cellTimeLabel.textColor = [UIColor lightGrayColor];
        cellTimeLabel.numberOfLines = 0;
        cellTimeLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:cellTimeLabel];
        
        UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69.5, rewardsListingTableView.bounds.size.width, 0.5)];
        [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView addSubview:seperatorImage];
        
        return cell;
    }
    
    return nil;
}



# pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (appDelegate.IS_SKIPPING_USER_LOGIN) {
        if (buttonIndex==0) {
            appDelegate.IS_SKIPPING_USER_LOGIN = NO;
            [[ViewControllerHelper viewControllerHelper] signOut];
        }
    }
    else {
        if (isBadgeUnlocked) {
            if (buttonIndex==0) {
                // Code To Post To Facebook
            }
        }
    }
}


#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
    //    if( gallery == localGallery ) {
    //        num = [localImages count];
    //    }
    //    else if( gallery == networkGallery ) {
    if( gallery == networkGallery ) {
        num = (int)[photoDataSourceForGallery count];
    }
    return num;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    //    if( gallery == localGallery ) {
    //        return FGalleryPhotoSourceTypeLocal;
    //    }
    //    else
    return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    //    NSString *caption;
    //    if( gallery == localGallery ) {
    //        caption = [localCaptions objectAtIndex:index];
    //    }
    //    else if( gallery == networkGallery ) {
    //        caption = [networkCaptions objectAtIndex:index];
    //    }
    //    return caption;
    return nil;
}


- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    //    return [localImages objectAtIndex:index];
    return nil;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [photoDataSourceForGallery objectAtIndex:index];
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}


- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    self.view.backgroundColor = RGB(247, 247, 247);
    
    if (appDelegate.IS_SKIPPING_USER_LOGIN) {
        [CommonFunctions showAlertView:self title:nil msg:@"To access profile, Please login." cancel:nil otherButton:@"OK",nil];
        return;
    }
    
    photosDataSource = [[NSMutableArray alloc] init];
    badgesDataSource = [[NSMutableArray alloc] init];
    pointsDataSource = [[NSMutableArray alloc] init];
    rewardsDataSource = [[NSMutableArray alloc] init];
    photoDataSourceForGallery = [[NSMutableArray alloc] init];
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(moveToEditProfile)];
    self.navigationItem.rightBarButtonItem = editButton;
    editButton.tintColor = [UIColor whiteColor];
    
    
    //===== Top Profile View
    UIImageView *profileBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 120)];
    [profileBg setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/profile_image_background.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:profileBg];
    
    
    UIImageView *profileImageViewBg = [[UIImageView alloc] initWithFrame:CGRectMake(18, 9, 104, 104)];
    profileImageViewBg.layer.cornerRadius = 52;
    profileImageViewBg.layer.masksToBounds = YES;
    [profileImageViewBg setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/circle_background.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    [self.view addSubview:profileImageViewBg];
    
    profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 100, 100)];
    profileImageView.layer.cornerRadius = 50;
    profileImageView.layer.masksToBounds = YES;
    [self.view addSubview:profileImageView];
    
    
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, self.view.bounds.size.width-150, 70)];
    userNameLabel.font = [UIFont fontWithName:ROBOTO_BOLD size:16];
    userNameLabel.textColor = RGB(85,49,118);
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.numberOfLines = 0;
    [self.view addSubview:userNameLabel];
    
    
    
    //===== For Tabs UI
    
    tabsBackground = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-114, self.view.bounds.size.width, 50)];
    [tabsBackground setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/tabbar_bg.png",appDelegate.RESOURCE_FOLDER_PATH]]]];
    [self.view addSubview:tabsBackground];
    tabsBackground.userInteractionEnabled = YES;
    
    badgesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    badgesButton.frame = CGRectMake(0, 0, tabsBackground.bounds.size.width/4, 50);
    [badgesButton setBackgroundColor:RGB(83, 83, 83)];
    badgesButton.tag = 1;
    [badgesButton addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [tabsBackground addSubview:badgesButton];
    
    badgesIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    badgesIcon.frame = CGRectMake(badgesButton.bounds.size.width/2 - 15, 5, 30, 30);
    badgesIcon.tag = 1;
    [badgesIcon addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [badgesIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_award_white.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [badgesButton addSubview:badgesIcon];
    
    badgesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, badgesButton.bounds.size.width, 15)];
    badgesLabel.text = @"Badges";
    badgesLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11];
    badgesLabel.textColor = RGB(255,255,255);
    badgesLabel.backgroundColor = [UIColor clearColor];
    badgesLabel.numberOfLines = 0;
    badgesLabel.textAlignment = NSTextAlignmentCenter;
    [badgesButton addSubview:badgesLabel];
    
    pointsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pointsButton.frame = CGRectMake(tabsBackground.bounds.size.width/4, 0, tabsBackground.bounds.size.width/4, 50);
    pointsButton.tag = 2;
    [pointsButton addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [pointsButton setBackgroundColor:[UIColor clearColor]];
    [tabsBackground addSubview:pointsButton];
    
    pointsIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    pointsIcon.frame = CGRectMake(pointsButton.bounds.size.width/2 - 15, 5, 30, 30);
    pointsIcon.tag = 2;
    [pointsIcon addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [pointsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_money_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [pointsButton addSubview:pointsIcon];
    
    pointsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, pointsButton.bounds.size.width, 15)];
    pointsLabel.text = @"Points";
    pointsLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11];
    pointsLabel.textColor = RGB(83,83,83);
    pointsLabel.backgroundColor = [UIColor clearColor];
    pointsLabel.numberOfLines = 0;
    pointsLabel.textAlignment = NSTextAlignmentCenter;
    [pointsButton addSubview:pointsLabel];
    
    rewardsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rewardsButton.frame = CGRectMake((tabsBackground.bounds.size.width/4)*2, 0, tabsBackground.bounds.size.width/4, 50);
    rewardsButton.tag = 3;
    [rewardsButton addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [rewardsButton setBackgroundColor:[UIColor clearColor]];
    [tabsBackground addSubview:rewardsButton];
    
    rewardsIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    rewardsIcon.frame = CGRectMake(rewardsButton.bounds.size.width/2 - 15, 5, 30, 30);
    rewardsIcon.tag = 3;
    [rewardsIcon addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [rewardsIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_gift_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    [rewardsButton addSubview:rewardsIcon];
    
    rewardsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, rewardsButton.bounds.size.width, 15)];
    rewardsLabel.text = @"Rewards";
    rewardsLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11];
    rewardsLabel.textColor = RGB(83,83,83);
    rewardsLabel.backgroundColor = [UIColor clearColor];
    rewardsLabel.numberOfLines = 0;
    rewardsLabel.textAlignment = NSTextAlignmentCenter;
    [rewardsButton addSubview:rewardsLabel];
    
    photosButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photosButton.frame = CGRectMake((tabsBackground.bounds.size.width/4)*3, 0, tabsBackground.bounds.size.width/4, 50);
    photosButton.tag = 4;
    [photosButton addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [photosButton setBackgroundColor:[UIColor clearColor]];
    [tabsBackground addSubview:photosButton];
    
    photosIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    photosIcon.frame = CGRectMake(photosButton.bounds.size.width/2 - 15, 5, 30, 30);
    [photosIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_poloroid_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    photosIcon.tag = 4;
    [photosIcon addTarget:self action:@selector(handleTabButtons:) forControlEvents:UIControlEventTouchUpInside];
    [photosButton addSubview:photosIcon];
    
    photosLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, photosButton.bounds.size.width, 15)];
    photosLabel.text = @"Photos";
    photosLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:11];
    photosLabel.textColor = RGB(83,83,83);
    photosLabel.backgroundColor = [UIColor clearColor];
    photosLabel.numberOfLines = 0;
    photosLabel.textAlignment = NSTextAlignmentCenter;
    [photosButton addSubview:photosLabel];
    
    
    
    //===== For Badges SubViews
    
    badgesBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, profileImageViewBg.frame.origin.y+profileImageViewBg.bounds.size.height+5, self.view.bounds.size.width, self.view.bounds.size.height-(132+profileImageViewBg.bounds.size.height))];
    [badgesBackgroundView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:badgesBackgroundView];
    badgesBackgroundView.userInteractionEnabled = YES;
    
    myBadgesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 115, 20)];
    myBadgesLabel.text = @"What are my badges";
    myBadgesLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:13.5];
    myBadgesLabel.textColor = [UIColor blackColor];
    myBadgesLabel.backgroundColor = [UIColor clearColor];
    myBadgesLabel.numberOfLines = 0;
    [badgesBackgroundView addSubview:myBadgesLabel];
    
    //    infoIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    infoIconButton.frame = CGRectMake(myBadgesLabel.frame.origin.x+myBadgesLabel.bounds.size.width, 13, 16, 16);
    //    [infoIconButton setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_info_purple.png",appDelegate.RESOURCE_FOLDER_PATH]] forState:UIControlStateNormal];
    //    [infoIconButton addTarget:self action:@selector(showBadgesToolTip:) forControlEvents:UIControlEventTouchUpInside];
    //    [badgesBackgroundView addSubview:infoIconButton];
    
    badgesScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, myBadgesLabel.frame.origin.y+myBadgesLabel.bounds.size.height+10, badgesBackgroundView.bounds.size.width, badgesBackgroundView.bounds.size.height)];
    badgesScrollView.showsHorizontalScrollIndicator = NO;
    badgesScrollView.showsVerticalScrollIndicator = NO;
    [badgesBackgroundView addSubview:badgesScrollView];
    badgesScrollView.backgroundColor = [UIColor clearColor];
    badgesScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 100);
    badgesScrollView.userInteractionEnabled = YES;
    
    
    //===== For Rewards SubViews
    
    rewardsListingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, profileImageViewBg.frame.origin.y+profileImageViewBg.bounds.size.height+8, self.view.bounds.size.width, self.view.bounds.size.height-(132+profileImageViewBg.bounds.size.height))];
    rewardsListingTableView.delegate = self;
    rewardsListingTableView.dataSource = self;
    [self.view addSubview:rewardsListingTableView];
    rewardsListingTableView.backgroundColor = [UIColor clearColor];
    rewardsListingTableView.backgroundView = nil;
    rewardsListingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    rewardsListingTableView.hidden = YES;
    
    
    
    //===== For Points SubViews
    
    pointsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, profileImageViewBg.frame.origin.y+profileImageViewBg.bounds.size.height+8, self.view.bounds.size.width, self.view.bounds.size.height-(132+profileImageViewBg.bounds.size.height))];
    pointsTableView.delegate = self;
    pointsTableView.dataSource = self;
    [self.view addSubview:pointsTableView];
    pointsTableView.backgroundColor = [UIColor clearColor];
    pointsTableView.backgroundView = nil;
    pointsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    pointsTableView.hidden = YES;
    
    
    
    //===== For Badges SubViews
    
    photosBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, profileImageViewBg.frame.origin.y+profileImageViewBg.bounds.size.height+5, self.view.bounds.size.width, self.view.bounds.size.height-(132+profileImageViewBg.bounds.size.height))];
    [photosBackgroundView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:photosBackgroundView];
    photosBackgroundView.userInteractionEnabled = YES;
    
    
    photosScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, photosBackgroundView.bounds.size.width, photosBackgroundView.bounds.size.height)];
    photosScrollView.showsHorizontalScrollIndicator = NO;
    photosScrollView.showsVerticalScrollIndicator = NO;
    [photosBackgroundView addSubview:photosScrollView];
    photosScrollView.backgroundColor = [UIColor clearColor];
    photosScrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 100);
    photosBackgroundView.hidden = YES;
    photosScrollView.userInteractionEnabled = YES;
    
    
}


//- (void) viewDidAppear:(BOOL)animated {
//
//
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
//    swipeGesture.numberOfTouchesRequired = 1;
//    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
//
//    [self.view addGestureRecognizer:swipeGesture];
//
//}

- (void) viewWillAppear:(BOOL)animated {
    
    [appDelegate setShouldRotate:NO];
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    
    userNameLabel.text = [[SharedObject sharedClass] getPUBUserSavedDataValue:@"userName"];
    
    if ([[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userProfileImageName"] length] !=0) {
        
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[[SharedObject sharedClass] getPUBUserSavedDataValue:@"userProfileImageName"]];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(profileImageView.bounds.size.width/2, profileImageView.bounds.size.height/2);
        [profileImageView addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                profileImageView.image = image;
            }
            else {
                [profileImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/image_avatar.png",appDelegate.RESOURCE_FOLDER_PATH]]];
            }
            [activityIndicator stopAnimating];
        }];
    }
    else {
        [profileImageView setImage:[[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/image_avatar.png",appDelegate.RESOURCE_FOLDER_PATH]]];
    }
    
    if (!appDelegate.IS_SKIPPING_USER_LOGIN)
        [self getOtherProfileData];
    
    //    self.hidesBottomBarWhenPushed = NO;
}


- (void) viewWillDisappear:(BOOL)animated {
    
    for (ASIHTTPRequest *req in ASIHTTPRequest.sharedQueue.operations)
    {
        [req cancel];
        [req setDelegate:nil];
    }
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
