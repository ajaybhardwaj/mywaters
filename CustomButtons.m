//
//  CustomButtons.m
//  eleAppz 1.0
//
//  Created by Raja
//  Copyright (c) 2012 CSC. All rights reserved.
//

#import "CustomButtons.h"

static CustomButtons *sharedInstance;

@interface CustomButtons () {
    
}

@end

@implementation CustomButtons

+(CustomButtons *)sharedInstance{
    if (sharedInstance == nil) {
        sharedInstance = [[CustomButtons alloc] init];
    }
    return sharedInstance;
}

/****************** Custom Back BarButton for Nav *********************/
-(UIBarButtonItem *)_PYaddCustomBackButton2Target:(id)target{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:BTN_BACK_HEADER_BAR];
    imageView.frame = CGRectMake(0, 0, BTN_BACK_HEADER_BAR.size.width, BTN_BACK_HEADER_BAR.size.height);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-20, 0, BTN_BACK_HEADER_BAR.size.width + BACK_BUTTON_LEFT_MARGIN, BTN_BACK_HEADER_BAR.size.height)];
    [view addSubview:imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(pop2Dismiss:)];
    [view addGestureRecognizer:tap];
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView: view] autorelease];
    
    [imageView release];
    [view release];
    [tap release];
    
    return backButton;
}

/****************** Custom Back BarButton for Nav end *********************/


/****************** Custom Left BarButton for Nav *********************/
-(UIBarButtonItem *)_PYaddCustomSettingsLeftBarButton2Target:(id)target withImg:(UIImage*)leftImage{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:leftImage];
    imageView.frame = CGRectMake(BACK_BUTTON_LEFT_MARGIN, 0, leftImage.size.width, leftImage.size.height);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftImage.size.width + BACK_BUTTON_LEFT_MARGIN, leftImage.size.height)];
    [view addSubview:imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(leftBarClicked)];
    [view addGestureRecognizer:tap];
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView: view] autorelease];
    
    [imageView release];
    [view release];
    [tap release];
    
    return backButton;
    
}
/****************** Custom Left BarButton for Nav end *********************/


/****************** Custom Left BarButton for Nav *********************/
-(UIBarButtonItem *)_PYaddCustomSettingsLeftBarButton2Target:(id)target withSelector:(SEL)selector withImg:(UIImage*)leftImage{
  
  UIImageView *imageView = [[UIImageView alloc] initWithImage:leftImage];
  imageView.frame = CGRectMake(0, 0, leftImage.size.width, leftImage.size.height);
  [imageView setBackgroundColor:[UIColor clearColor]];
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftImage.size.width + BACK_BUTTON_LEFT_MARGIN, leftImage.size.height)];
  [view addSubview:imageView];
  [view setBackgroundColor:[UIColor clearColor]];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
  [view addGestureRecognizer:tap];
  UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView: view] autorelease];
  
  [imageView release];
  [view release];
  [tap release];
  
  return backButton;
  
}

/****************** Custom Left BarButton for Nav end *********************/



/****************** Custom Right BarButton for Nav *********************/
-(UIBarButtonItem *)_PYaddCustomRightBarButton2Target:(id)target withSelector:(SEL)selector withIconName:(NSString *)iconName{

  UIImage *iconImg = [UIImage imageNamed:iconName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:iconImg];
    imageView.frame = CGRectMake(0, 0, iconImg.size.width, iconImg.size.height);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, iconImg.size.width + BACK_BUTTON_LEFT_MARGIN - 10 , iconImg.size.height)];
    [view addSubview:imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [view addGestureRecognizer:tap];
    UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView: view] autorelease];
    
    [imageView release];
    [view release];
    [tap release];
    
    return backButton;
}


/****************** Custom Right BarButton for Nav end *********************/


/*original*/
/****************** Custom Back BarButton for Nav *********************/
-(UIBarButtonItem *)addCustomBackButton2Target:(id)target{
  
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BTN_BACK_HEADER_BAR_NAME]];
  imageView.frame = CGRectMake(5 + BACK_BUTTON_LEFT_MARGIN, 0, BTN_BACK_HEADER_BAR_SIZE, BTN_BACK_HEADER_BAR_SIZE);
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BTN_BACK_HEADER_BAR_SIZE + BACK_BUTTON_LEFT_MARGIN , BTN_BACK_HEADER_BAR_SIZE)];
  [view addSubview:imageView];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(pop2Dismiss)];
  [view addGestureRecognizer:tap];
  UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView: view] autorelease];
  
  [imageView release];
  [view release];
  [tap release];
  
  return backButton;
}

/****************** Custom Back BarButton for Nav end *********************/


/****************** Custom Left BarButton for Nav *********************/
-(UIBarButtonItem *)addCustomSettingsLeftBarButton2Target:(id)target{
  
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:BTN_BACK_HEADER_BAR_NAME]];
  imageView.frame = CGRectMake(BACK_BUTTON_LEFT_MARGIN, 0, BTN_BACK_HEADER_BAR_SIZE, BTN_BACK_HEADER_BAR_SIZE);
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BTN_BACK_HEADER_BAR_SIZE + BACK_BUTTON_LEFT_MARGIN, BTN_BACK_HEADER_BAR_SIZE)];
  [view addSubview:imageView];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:@selector(settings)];
  [view addGestureRecognizer:tap];
  UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView: view] autorelease];
  
  [imageView release];
  [view release];
  [tap release];
  
  return backButton;
  
}

/****************** Custom Left BarButton for Nav end *********************/


/****************** Custom Right BarButton for Nav *********************/
-(UIBarButtonItem *)addCustomRightBarButton2Target:(id)target withSelector:(SEL)selector withIconName:(NSString *)iconName{
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
  imageView.frame = CGRectMake(0, 0, BTN_BACK_HEADER_BAR_SIZE, BTN_BACK_HEADER_BAR_SIZE);
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BTN_BACK_HEADER_BAR_SIZE + BACK_BUTTON_LEFT_MARGIN, BTN_BACK_HEADER_BAR_SIZE)];
  [view addSubview:imageView];
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
  [view addGestureRecognizer:tap];
  UIBarButtonItem *backButton = [[[UIBarButtonItem alloc] initWithCustomView: view] autorelease];
  
  [imageView release];
  [view release];
  [tap release];
  
  return backButton;
}


/****************** Custom Right BarButton for Nav end *********************/

-(void)dealloc{
    [super dealloc];
  
}

@end
