//
//  GalleryViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 10/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface GalleryViewController : UIViewController <UIScrollViewDelegate,UIGestureRecognizerDelegate> {
    
    AppDelegate *appDelegate;
@private
    NSMutableArray *galleryImages_;
    NSInteger currentIndex_;
    NSInteger previousPage_;
}
@property (nonatomic, strong)  UIImageView *prevImgView; //reusable Imageview  - always contains the previous image
@property (nonatomic, strong)  UIImageView *centerImgView; //reusable Imageview  - always contains the currently shown image
@property (nonatomic, strong)  UIImageView *nextImgView; //reusable Imageview  - always contains the next image image

@property(nonatomic, strong)UIScrollView *imageHostScrollView; //UIScrollview to hold the images
@property (nonatomic, strong) NSArray *galleryImages;
@property (nonatomic, assign) BOOL isABCGallery,isUserGallery;

@property (nonatomic, assign) NSInteger currentIndex;

@end
