//
//  AuxilaryUIService.m
//  NParks
//
//  Created by Raja Saravanan on 1/31/12.
//  Copyright (c) 2012 Shownearby. All rights reserved.
//

#define PLACE_LARGE_IMG @"PLACELARGEIMG"
#define PLACE_LARGE_IMG_ID @"PLACELARGEIMGID"
#define PLACE_OVERLAY_VIEW @"PLACEOVERLAYVIEW"
#define PLACE_OVERLAY_VIEW_ID @"PLACEOVERLAYVIEWID"
#define PLACE_BOTTOM_VIEW @"PLACEBOTTOMVIEW"
#define PLACE_BOTTOM_VIEW_ID @"PLACEBOTTOMVIEWID"

#define BTN_SELECTOR_ARRAY @"BTNSELECTORARRAY"
#define BTN_IMAGE_ARRAY @"BTNIMAGEARRAY"

typedef enum{
    placeLargeImg = 1212,
    placeOverLayImg,
    placeBottomImg
}tablTags;


#import "AuxilaryUIService.h"
#include <QuartzCore/CoreAnimation.h>
#import "ArrowImageView.h"

@implementation AuxilaryUIService
@synthesize disclaimerImage,disclaimerText;
@synthesize disclaimerCallback, disclaimerView_Caller;

static AuxilaryUIService *sharedInstance_ = nil;  // -- shared instacne class object

-(void)showDisclaimerOn_View:(UIView*)view withTarget:(id)target andSelector:(SEL)selector forText:(NSString*)text_{
    
    // -- iMDelegate.. window ...
    AppDelegate* appDelegate_ = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([self.disclaimerImage superview]) {
        //RDLog(@"\n %s --- %@ \n\n",__FUNCTION__,[self.disclaimerImage superview]);
        [self.disclaimerImage removeFromSuperview];
        self.disclaimerImage = nil;
        self.disclaimerText.text = nil;
        //[[appDelegate_ window] setGestureRecognizers:nil];
    }
    
    self.disclaimerView_Caller = target;
    self.disclaimerCallback = selector;

    // -- laoding a nib to show popup..
    [[NSBundle mainBundle] loadNibNamed:@"DisclaimerView" owner:self options:nil];
    
    if (text_!=nil) {
        self.disclaimerText.text = text_;
    }
    
    // -- Make the frame...
    //[self.disclaimerImage setFrame:CGRectMake((MAIN_SCREEN_BOUNDS.size.width-self.disclaimerImage.frame.size.width)/2, (MAIN_SCREEN_BOUNDS.size.height-self.disclaimerImage.frame.size.height)/2, self.disclaimerImage.frame.size.width, self.disclaimerImage.frame.size.height)];
    
    [self.disclaimerImage setFrame:CGRectMake((MAIN_SCREEN_BOUNDS.size.width-self.disclaimerImage.frame.size.width)/2, (MAIN_SCREEN_BOUNDS.origin.y), self.disclaimerImage.frame.size.width, MAIN_SCREEN_BOUNDS.size.height)];

    [self.disclaimerImageView setFrame:CGRectMake((MAIN_SCREEN_BOUNDS.size.width-self.disclaimerImageView.frame.size.width)/2, (MAIN_SCREEN_BOUNDS.size.height-self.disclaimerImageView.frame.size.height)/2, self.disclaimerImageView.frame.size.width, self.disclaimerImageView.frame.size.height)];
    [self.disclaimerText setFrame:CGRectMake((MAIN_SCREEN_BOUNDS.size.width-self.disclaimerText.frame.size.width)/2, (MAIN_SCREEN_BOUNDS.size.height-self.disclaimerText.frame.size.height)/2, self.disclaimerText.frame.size.width, self.disclaimerText.frame.size.height)];


    [[appDelegate_ window] addSubview:[self disclaimerImage]];
    
    // -- Add Gesture for the Ima App delete ....
    [AuxilaryUIService resignFirst_ResponderForView:[self disclaimerImage] onTarget:self withAction:@selector(removeDisclaimerView:)];
}

-(void)removeDisclaimerView:(id)sender{
    // -- Sender is a Tap Gesture Recognizer....
    //RDLog(@"\n %s --- %@ \n\n",__FUNCTION__,[self.disclaimerImage superview]);
    if ([self.disclaimerImage superview]) {
        //RDLog(@"\n %s --- %@ 1111\n\n",__FUNCTION__,[self.disclaimerImage superview]);
        [self.disclaimerImage removeFromSuperview];
        if (sender) {
            // -- if sender is not equal nil then its a gesture recogniser..
            //-- else its called from IbAction..
            UIGestureRecognizer *gesture = (UIGestureRecognizer*)sender;
            [gesture removeTarget:self action:@selector(removeDisclaimerView:)];

        }
        //[[self disclaimerImage] setGestureRecognizers:nil];
        self.disclaimerImage = nil;
        self.disclaimerText.text = nil;

    }
}

//-(void)showDisclaimerOn_View:(UIView*)view andAnchorPoint:(CGPoint)point withTarget:(id)target andSelector:(SEL)selector forDictionary:(NSDictionary*)disclaimerDict
//{
//  RDLog(@"\n %s --- %@ \n\n",__FUNCTION__,view);
//
//  if ([self.disclaimerImage superview]) {
//    RDLog(@"\n %s --- %@ \n\n",__FUNCTION__,[self.disclaimerImage superview]);
//    [self.disclaimerImage removeFromSuperview];
//    self.disclaimerImage = nil;
//    self.disclaimerText.text = nil;
//    self.disclaimerTitle.text = nil;
//  }
//  
//  self.disclaimerView_Caller = target;
//  self.disclaimerCallback = selector;
//  [[NSBundle mainBundle] loadNibNamed:@"DisclaimerView" owner:self options:nil];
//  
//  if ([disclaimerDict objectForKey:@"text"] && [disclaimerDict objectForKey:@"title"]) {
//    self.disclaimerText.text = [disclaimerDict objectForKey:@"text"];
//    self.disclaimerTitle.text = [disclaimerDict objectForKey:@"title"];
//  }
//
//  [self.disclaimerImage setFrame:CGRectMake((320-self.disclaimerImage.frame.size.width)/2, (460-self.disclaimerImage.frame.size.height)/2, self.disclaimerImage.frame.size.width, self.disclaimerImage.frame.size.height)];
//  AuxiliaryFunctions *auxFunctions = [[AuxiliaryFunctions alloc] init];
//  [auxFunctions jumpAnimationForView:self.disclaimerImage toPoint:(CGPoint){self.disclaimerImage.frame.size.width/2,self.disclaimerImage.frame.size.height/2}];
//  [view addSubview:self.disclaimerImage];
//  [self.disclaimerImage setFrame:CGRectMake((320-self.disclaimerImage.frame.size.width)/2, (460-self.disclaimerImage.frame.size.height)/2, self.disclaimerImage.frame.size.width, self.disclaimerImage.frame.size.height)];
//    [self.disclaimerImage setAlpha:1.0];
//  [auxFunctions release];
//  
//}


//-(IBAction)disclaimerBtn_Clicked:(id)sender{
//    [self removeDisclaimerView:nil];
//}

+(AuxilaryUIService*)auxFunctions{
    if (sharedInstance_ == nil) {
        sharedInstance_ = [[AuxilaryUIService alloc] init];
    }
    return sharedInstance_;
}
-(id)init{
    self = [super init];
    if (self) {
        // -- do the initialization here
    }
    return  self;
}
#pragma mark - Create Category Images && Table Headers
-(UIImageView *)createCategoryImages:(NSString*)image selectors:(NSArray*)selectrs target:(id)targ tagConsant:(NSInteger)tag{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    UIImage *img = [UIImage imageNamed:image];
    UIImageView* tempV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [tempV setImage:img];
    [tempV setContentMode:UIViewContentModeCenter];
    [tempV setUserInteractionEnabled:TRUE];
    
    int xOff = 0;
    int yOff = 0;
    int width = img.size.width/3;
    int hgt = img.size.height;
    
    for (int i = 0; i<[selectrs count]; i++) {
        //  button 
        UIButton* dobBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dobBtn setShowsTouchWhenHighlighted:TRUE];
        [dobBtn setFrame:CGRectMake(xOff,yOff,width,hgt)];
        [dobBtn setTag:tag+i];
        [dobBtn addTarget:targ action:NSSelectorFromString((NSString*)[selectrs objectAtIndex:i]) forControlEvents:UIControlEventTouchUpInside];
        [dobBtn setBackgroundColor:[UIColor clearColor]];
        [tempV addSubview:dobBtn];
        xOff = xOff+width;
    }
    
    [pool drain];
    return [tempV autorelease];
    
}

-(UIView *)getTableHeaderForPlace_Park:(NSDictionary*)details{

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    UIView* tempV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    
    UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 380)];
    [imgV setImage:[details objectForKey:PLACE_LARGE_IMG]];
    [imgV setContentMode:UIViewContentModeCenter];
    [imgV setUserInteractionEnabled:TRUE];
    [imgV setTag:placeLargeImg];
    
    [tempV addSubview:imgV];
    [tempV release];
    
    


    return [tempV autorelease];
    [pool drain];

}

-(UIButton*)showMoreBtn:(NSString *)title target:(id)target tag:(NSInteger)whichTag{
    
    //ShowMoreButton - Subview of ShowMoreView
    UIButton *showMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[showMoreButton setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
	[showMoreButton setTitleColor:RGB(215,215,215) forState:UIControlStateNormal];
	[showMoreButton setTitleShadowColor:[UIColor colorWithWhite:0.9f alpha:1.0f] forState:UIControlStateNormal];
	showMoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
	showMoreButton.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [showMoreButton setTag:whichTag];
	showMoreButton.backgroundColor = [UIColor clearColor];
	[showMoreButton addTarget:target action:@selector(showMoreResult:) forControlEvents:UIControlEventTouchUpInside];
	[showMoreButton setFrame:CGRectMake(0, 0, 320, 50)];
	showMoreButton.alpha = 1.0;
    
    return showMoreButton;
    
}

-(UILabel*)viewForNoResults:(NSString *)title frame:(CGRect)frame_{
    UILabel *lbl = [[UILabel alloc] initWithFrame:frame_];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:title];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [lbl setTextColor:RGB(51, 51, 51)];
    [lbl setAdjustsFontSizeToFitWidth:TRUE];
    [lbl setFont:[UIFont fontWithName:OPEN_SANS_REGULAR size:14]];
    return [lbl autorelease];
}

-(UIImageView *)tableHeaderViewWithText:(NSString*)text{
    UIImageView *hImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titleheader"]];
    [hImg setFrame:CGRectMake(0, 0, [UIImage imageNamed:@"titleheader"].size.width, [UIImage imageNamed:@"titleheader"].size.height)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, hImg.frame.size.width-10, hImg.frame.size.height)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:text];
    [lbl setTextColor:RGB(109, 159, 180)];
    [lbl setAdjustsFontSizeToFitWidth:TRUE];
    [lbl setFont:[UIFont fontWithName:OPEN_SANS_REGULAR size:14]];
    [hImg addSubview:lbl];
    [lbl release];
    return [hImg autorelease];
}

-(UIView *)tableHeaderViewWithImag:(NSString*)imageName frame:(CGRect)frame imageframe:(CGRect)imgframe{
  UIView *parentView = [[[UIView alloc] initWithFrame:frame] autorelease];
  [parentView setBackgroundColor:[UIColor clearColor]];
  UIImageView *hImg = nil;
  if (imageName!=nil) {
    hImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
  }
  else{
    hImg = [[UIImageView alloc] init];
  }
  [hImg setContentMode:UIViewContentModeScaleToFill];
  [hImg setFrame:imgframe];
  [parentView addSubview:hImg];
  return parentView;
}

-(UIImageView *)tableHeaderViewWithImag:(NSString*)imageName frame:(CGRect)frame{
  UIImageView *hImg = nil;
  if (imageName!=nil) {
    hImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
  }
  else{
    hImg = [[UIImageView alloc] init];
  }
  [hImg setContentMode:UIViewContentModeScaleToFill];
  [hImg setFrame:frame];
  return [hImg autorelease];
}

-(UIImageView *)tableHeaderViewWithText:(NSString*)text andImag:(NSString*)imageName frame:(CGRect)frame{
  UIImageView *hImg = nil;
  if (imageName!=nil) {
    hImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
      
  }
  else{
    hImg = [[UIImageView alloc] init];
  }
    
    [hImg setBackgroundColor:[UIColor clearColor]];
  [hImg setFrame:frame];
  UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, hImg.frame.size.width-10, hImg.frame.size.height)];
  [lbl setBackgroundColor:[UIColor clearColor]];
  if (text!=nil) {
    [lbl setText:text];
  }  
  [lbl setTextColor:RGB(0, 145, 211)];
  [lbl setAdjustsFontSizeToFitWidth:TRUE];
  [lbl setFont:[UIFont fontWithName:OPEN_SANS_REGULAR size:12]];
  [hImg addSubview:lbl];
  [lbl release];
  return [hImg autorelease];
}

-(UIView*)viewForHeaderWith:(UIImage*)image_ frame:(CGRect)frame text:(NSString*)text txtColor:(UIColor*)txtColor font:(CGFloat)font_{

    UIView *v = [[[UIView alloc] initWithFrame:frame] autorelease];
    [v setBackgroundColor:[UIColor clearColor]];
        
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, frame.size.height-20)] autorelease];
    if (IS_IOS6()) {
        [lbl setTextAlignment:NSTextAlignmentLeft];
    }
    else{
        [lbl setTextAlignment:UITextAlignmentLeft];
    }
    [lbl setFont:[UIFont fontWithName:OPEN_SANS_REGULAR size:font_]];
    [lbl setAdjustsFontSizeToFitWidth:TRUE];
    [lbl setTextColor:txtColor];
    [lbl setText:text];
    [lbl setNumberOfLines:0];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [v addSubview:lbl];
    return v;
    
}

-(UIView*)viewReportDetailHeaderWith:(UIImage*)image_ text:(NSString*)text txtColor:(UIColor*)txtColor font:(UIFont*)font_{
    
    CGRect frame = CGRectMake(0, 0, 320, image_.size.height);
    UIView *v = [[[UIView alloc] initWithFrame:frame] autorelease];
    [v setBackgroundColor:[UIColor colorWithPatternImage:image_]];
    //[v setBackgroundColor:[UIColor clearColor]];
    
    frame.origin.x = LEFT_MARGIN;
    frame.origin.y = 1;
    UILabel *lbl = [[[UILabel alloc] initWithFrame:frame] autorelease];
    if (IS_IOS6()) {
        [lbl setTextAlignment:NSTextAlignmentLeft];
    }
    else{
        [lbl setTextAlignment:UITextAlignmentLeft];
    }
    [lbl setFont:font_];
    [lbl setAdjustsFontSizeToFitWidth:TRUE];
    [lbl setTextColor:txtColor];
    [lbl setText:text];
    [lbl setNumberOfLines:0];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [v addSubview:lbl];
    [v bringSubviewToFront:lbl];
    return v;
}

#pragma mark -

+(CGFloat)getHeightOf_2xImage:(NSString*)imageName{
  return [UIImage imageNamed:imageName].size.height/2;
}
+(CGFloat)getwidthOf_2xImage:(NSString*)imageName{
  return [UIImage imageNamed:imageName].size.width/2;
}
+(CGFloat)getHeightOf_1xImage:(NSString*)imageName{
  return [UIImage imageNamed:imageName].size.height;
}
+(CGFloat)getwidthOf_1xImage:(NSString*)imageName{
  return [UIImage imageNamed:imageName].size.width;
}

-(UIButton*)detailInfoBtn:(NSString*)img lbl:(NSString*)lbl_Text categoryTag:(int)tag height:(CGRect)fram target:(id)target_ sel:(SEL)selector_{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"line_buttonsbar.png"]]];
    [btn setFrame:fram];
    
    UIImageView *hImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:img]];
    [hImg setFrame:CGRectMake(5, (38-25)/2, 25, 25)];
    [hImg setUserInteractionEnabled:TRUE];
    [hImg setBackgroundColor:[UIColor clearColor]];
    
    [btn addSubview:hImg];
    [hImg release];
    hImg = nil;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(5+25+5, 0, 107-(5+25+5), fram.size.height)];
    [lbl setBackgroundColor:[UIColor clearColor]];
    [lbl setText:lbl_Text];
  if (IS_IOS6()) {
    [lbl setTextAlignment:NSTextAlignmentLeft];
  }
  else{
    [lbl setTextAlignment:UITextAlignmentLeft];
  }
    [lbl setTextColor:RGB(51, 51, 51)];
    [lbl setAdjustsFontSizeToFitWidth:TRUE];
    [lbl setFont:[UIFont fontWithName:OPEN_SANS_REGULAR size:14]];
    [btn addSubview:lbl];
    [lbl release]; 
    lbl = nil;
    
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    [btn setTag:tag];
    [btn setShowsTouchWhenHighlighted:TRUE];
    [btn addTarget:target_ action:selector_ forControlEvents:UIControlEventTouchUpInside];
    
    return btn;

}



#pragma mark - Table Heights
+(CGFloat)getHeightOfTable:(NSString *)maintext subText:(NSString*)subText mainFont:(CGFloat)mF subFont:(CGFloat)sF imgWidth:(CGFloat)imgWid{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CGFloat hgt = 0;
    
    CGSize constraint = CGSizeMake((CELL_CONTENT_WIDTH - imgWid), FLT_MAX);
    if (maintext) {
        UIFont *font = [UIFont boldSystemFontOfSize:mF];
      CGSize textSize = (IS_IOS6()) ? [maintext sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping] : [maintext sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        hgt = textSize.height;
    }
    if (subText) {
        UIFont *fontDetail = [UIFont systemFontOfSize:sF];
      CGSize textDetailSize = (IS_IOS6()) ? [subText sizeWithFont:fontDetail constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping] : [subText sizeWithFont:fontDetail constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap] ;
        hgt = hgt + textDetailSize.height;
    }    
        
    [pool drain];
    return (hgt+10);

}

+(CGFloat)getHeightOfLabelFor_Text:(NSString *)text andfont:(UIFont*)font andWidthConstraint:(CGFloat)constrainWid{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
//  CGFloat hgt = 0;
//  
//  CGSize constraint = CGSizeMake(constrainWid, FLT_MAX);
//  if (text) {
//    CGSize textSize = (IS_IOS6()) ? [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping]:[text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//    hgt = textSize.height;
//  }
//  [pool drain];
//  return (hgt);
    
    
    CGFloat hgt = 0;
    
    CGSize constraint = CGSizeMake(constrainWid, FLT_MAX);
    if (text) {
        
        UIColor *color = [UIColor whiteColor];
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              font, NSFontAttributeName,
                                              color, NSForegroundColorAttributeName,
                                              nil];
        
        NSMutableAttributedString *string = [[[NSMutableAttributedString alloc] initWithString:text attributes:attributesDictionary] autorelease];
        
        CGRect getTextRect = [string boundingRectWithSize:constraint options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
        
        CGSize textSize = getTextRect.size;
        hgt = textSize.height;
        
    }
    [pool drain];
    return (hgt);

}

+(CGFloat)getWidthOfLabelFor_Text:(NSString *)text andfont:(UIFont*)font andHghtConstraint:(CGFloat)constrainHgt{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    CGFloat hgt = 0;
    
    CGSize constraint = CGSizeMake(FLT_MAX, constrainHgt);
    if (text) {
        CGSize textSize = (IS_IOS6()) ? [text sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping]:[text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        hgt = textSize.width;
    }
    [pool drain];
    return (hgt);
}

#pragma mark - TabBarItem
+(UITabBarItem*)getTabBar_ForTitle:(NSString*)title_ andImage:(UIImage*)tabImg withTag:(NSUInteger)tag{
  UITabBarItem *mapViewItem = [[[UITabBarItem alloc] initWithTitle:title_ image:tabImg tag:tag] autorelease];
  return mapViewItem;
}

//#pragma mark - iMPopupController
////-(iMPopupController*)showPopupWithMessage:(NSString*)text onController:(id)controller{
//-(void)showPopupWithMessage:(NSString*)text onController:(id)controller{
//    // -- show pop up with text
//    iMPopupController *popupControl = [[[iMPopupController alloc] initWithNibName:@"iMPopupController" bundle:nil text:text] autorelease];
//    [self setPopupController:popupControl];
//    [(UIViewController*)controller presentPopupViewController:popupControl animationType:MJPopupViewAnimationFade];
//}



#pragma mark - Table And View Background
+(void)setTableViewImg:(NSString*)imageName table:(UITableView*)table{
  [table setBackgroundView:nil];
    [table setBackgroundColor:[UIColor clearColor]];
    if (imageName)
        [table setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:imageName]]];
}

+(void)setViewController_BackgroundImg:(NSString*)imageName onView:(UIView*)view{
  UIImageView *backgroundImg = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
  [view addSubview:backgroundImg];
  [view sendSubviewToBack:backgroundImg];
}


#pragma mark - Cells

-(UITableViewCell*)lifestyleCellWithIdentifier:(NSString*)identifier mainString:(NSString*)mainStr subString:(id)subStr{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    //int gap = 10;
    
    // -- row height 65
    int xOff = 10;
    int yOff = 2; 
    
    // -- test case
    //mainStr = [mainStr stringByAppendingString:@" Now I am using only rough datas from the api for Nparks. Even if its a test environment I need a valuable data to move further in our iphone development."];

    CGFloat height = [AuxilaryUIService getHeightOfTable:mainStr subText:nil mainFont:14 subFont:0 imgWidth:0];
    
    // -- TITLE Lbl
    UILabel *titleLbl_ = [[UILabel alloc] initWithFrame:CGRectMake(xOff, yOff, 320-(2*xOff), height)];
    [titleLbl_ setTextColor:RGB(50, 50, 50)];
    [titleLbl_ setBackgroundColor:[UIColor clearColor]];
    //[titleLbl_ setBackgroundColor:[UIColor cyanColor]];
    [titleLbl_ setNumberOfLines:0];
    [titleLbl_ setTextAlignment:UITextAlignmentLeft];
    [titleLbl_ setFont:[UIFont fontWithName:OPEN_SANS_REGULAR size:14]];
    [titleLbl_ setTag:nameTag];
    [cell.contentView addSubview:titleLbl_];
    [cell.contentView bringSubviewToFront:titleLbl_];
    [titleLbl_ release];
    titleLbl_ = nil;
    
    // -- height of cell
    yOff = yOff+height+2;//+5;
    
    // -- distanceView
    UIView *distanceView = [[UIView alloc] initWithFrame:CGRectMake(xOff, yOff, 100, 25)];
    [distanceView setBackgroundColor:[UIColor clearColor]];
    [distanceView setBackgroundColor:RGB(247, 253, 212)];
    [cell.contentView addSubview:distanceView];
    [cell.contentView bringSubviewToFront:distanceView];
    
    // -- distanceViewImg
    UIImageView *distanceViewImg = [[UIImageView alloc] initWithImage:CONST_ARROW_IMAGE];
    [distanceViewImg setBackgroundColor:[UIColor clearColor]];
    [distanceViewImg setContentMode:UIViewContentModeScaleAspectFit];
    [distanceViewImg setFrame:CGRectMake(0,0,25,25)];  
    [distanceView addSubview:distanceViewImg];
    [distanceView bringSubviewToFront:distanceViewImg];
    [distanceViewImg release];
    distanceViewImg = nil;
    
    // --
    
    titleLbl_ = [[UILabel alloc] initWithFrame:CGRectMake(25+2, 0, distanceView.frame.size.width-25-2, 25)];
    [titleLbl_ setTextColor:RGB(50, 50, 50)];
    [titleLbl_ setBackgroundColor:[UIColor clearColor]];
    //[titleLbl_ setBackgroundColor:[UIColor blackColor]];
    [titleLbl_ setTextAlignment:UITextAlignmentLeft];
    [titleLbl_ setNumberOfLines:0];
    [titleLbl_ setTag:distanceTag];
    [titleLbl_ setFont:[UIFont fontWithName:OPEN_SANS_REGULAR size:12]];
    [distanceView addSubview:titleLbl_];
    [distanceView bringSubviewToFront:titleLbl_];
    [titleLbl_ release];
    titleLbl_ = nil;
    
    [distanceView release];
    distanceView = nil;
        
    xOff = xOff+102;
    // -- must try view
    UIView *must = [[UIView alloc] initWithFrame:CGRectMake(xOff, yOff, 320-(2*5)-xOff, 25)];
    [must setBackgroundColor:[UIColor clearColor]];
    [must setBackgroundColor:RGB(247, 253, 212)];
    //[cell.contentView addSubview:must]; // -- prototype
    [cell.contentView bringSubviewToFront:must];
    
    // -- must try
    UIImageView *parksImg_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_musttry_detail.png"]];
    [parksImg_ setBackgroundColor:[UIColor clearColor]];
    [parksImg_ setContentMode:UIViewContentModeScaleAspectFit];
    [parksImg_ setFrame:CGRectMake(0,0,25,25)];  
    [must addSubview:parksImg_];
    [must bringSubviewToFront:parksImg_];
    [parksImg_ release];
    parksImg_ = nil;
    
    // -- MUSTTRY Lbl
    titleLbl_ = [[UILabel alloc] initWithFrame:CGRectMake(25+2, 0, must.frame.size.width-25-2, 25)];
    [titleLbl_ setTextColor:RGB(50, 50, 50)];
    [titleLbl_ setBackgroundColor:[UIColor clearColor]];
    [titleLbl_ setTextAlignment:UITextAlignmentLeft];
    [titleLbl_ setNumberOfLines:0];
    [titleLbl_ setTag:mustTryTag];
    [titleLbl_ setFont:[UIFont fontWithName:OPEN_SANS_REGULAR size:12]];
    [must addSubview:titleLbl_];
    //[must setBackgroundColor:[UIColor grayColor]];
    [titleLbl_ release];
    titleLbl_ = nil;
    
    [must release];
    must = nil;    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell setFrame:CGRectMake(0, 0, 320, yOff)];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.layer.cornerRadius = 5.0f;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1;
    cell.layer.borderColor =  [RGB(208, 216, 165) CGColor];

    
    return [cell autorelease];
}

#pragma mark - Category Images
-(UIView *)createCategoryImages:(NSString*)image selectors:(NSArray*)selectrs target:(id)targ tagRef:(int)tagv{
    
    //NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    UIImage *img = [UIImage imageNamed:image];
    UIView* tempV = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    // -- temp
    [tempV setFrame:CGRectMake(0, 0, 320, 39)];
    [tempV setBackgroundColor:[UIColor colorWithPatternImage:img]];
    
    int xOff = 0;
    int yOff = 0;
    
    int width = 320;
    int hgt = 39;
    
    for (int i = 0; i<[selectrs count]; i++) {
        // -- button 
        UIButton* dobBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dobBtn setShowsTouchWhenHighlighted:TRUE];
        [dobBtn setFrame:CGRectMake(xOff,yOff,width/[selectrs count],hgt)];
        [dobBtn setTag:tagv+i];
        [dobBtn addTarget:targ action:NSSelectorFromString((NSString*)[selectrs objectAtIndex:i]) forControlEvents:UIControlEventTouchUpInside];
        [dobBtn setBackgroundColor:[UIColor clearColor]];
        [tempV addSubview:dobBtn];
        xOff = xOff+width/[selectrs count];
    }
    
    //[pool drain];
    return [tempV autorelease];

}

#pragma mark - Navigation Bar Images
-(UIView *)createNavigationImages:(NSString*)image selectors:(NSArray*)selectrs target:(id)targ tagRef:(int)tagv{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    UIImage *img = [UIImage imageNamed:image];
    UIView* tempV = [[UIView alloc] init];//WithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    // -- temp
    [tempV setFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [tempV setBackgroundColor:[UIColor colorWithPatternImage:img]];
    
    int xOff = 0;
    int yOff = 0;
    
    int width = img.size.width;
    int hgt = img.size.height;
    
    for (int i = 0; i<[selectrs count]; i++) {
        // -- button 
        UIButton* dobBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dobBtn setShowsTouchWhenHighlighted:TRUE];
        [dobBtn setFrame:CGRectMake(xOff,yOff,width/[selectrs count],hgt)];
        [dobBtn setTag:tagv+i];
        [dobBtn addTarget:targ action:NSSelectorFromString((NSString*)[selectrs objectAtIndex:i]) forControlEvents:UIControlEventTouchUpInside];
        [dobBtn setBackgroundColor:[UIColor clearColor]];
        [tempV addSubview:dobBtn];
        xOff = xOff+width/[selectrs count];
    }
    
    [pool drain];
    return [tempV autorelease];
    
}

+ (UIImage *)imageWithColor:(UIColor *)color frame:(CGRect)frame {
    CGRect rect = frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+(UITextField*)createTextFieldWithFrame:(CGRect)frame tag:(NSInteger)tag andPlaceHolder:(NSString*)placeHolderV selector:(SEL)selector_ withTarget:(id)target borderStyle:(UITextBorderStyle)borderStyl{
    
  UITextField *selectDistrict = [[UITextField alloc] initWithFrame:frame];
  if (IS_IOS6()) {
    [selectDistrict setTextAlignment:NSTextAlignmentLeft];
  }
  else{
    [selectDistrict setTextAlignment:UITextAlignmentLeft];
  }
  [selectDistrict setFont:[UIFont fontWithName:OPEN_SANS_REGULAR size:16]];
  [selectDistrict setTextColor:[UIColor blackColor]];
  [selectDistrict setPlaceholder:placeHolderV];
  if (selector_) {
    [selectDistrict addTarget:target action:selector_ forControlEvents:UIControlEventEditingChanged];
  }
  [selectDistrict setUserInteractionEnabled:TRUE];
  [selectDistrict setDelegate:target];
  [selectDistrict setBorderStyle:borderStyl];
  [selectDistrict setTag:tag];
  [selectDistrict setBackgroundColor:[UIColor clearColor]];
  return [selectDistrict autorelease];
    
    
    //selectDistrict.textAlignment = (IS_IOS6()) ? UITextAlignmentCenter : NSTextAlignmentCenter;
}

#pragma mark - Resign First REsponder
#pragma mark - Work as tap gesture
+(void)resignFirst_ResponderForView:(id)view onTarget:(id)target withAction:(SEL)selector{
  
  UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:target action:selector] autorelease];
  [view addGestureRecognizer:tapGesture];
  [tapGesture setNumberOfTapsRequired:1];
  [tapGesture setNumberOfTouchesRequired:1];
  
}
@end


#pragma mark - This class methods ends above

#pragma mark - Categories Below
#pragma categories
//@implementation UIImageView(PlaceholderImage)
//-(void)setPlaceHolderImage:(NSString*)imageName{
//  UIImageView *placeHolderImage = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
//  [placeHolderImage setBackgroundColor:[UIColor clearColor]];
//  [placeHolderImage setContentMode:UIViewContentModeScaleToFill];
//  [placeHolderImage setImage:[UIImage imageNamed:imageName]];
//  [placeHolderImage setTag:PLACEHOLDER_IMG_CONSTANT];
//  if ([self subviews].count>0) {
//    [self insertSubview:placeHolderImage belowSubview:[[self subviews] objectAtIndex:0]];
//  }
//  else{
//    [self addSubview:placeHolderImage];
//    [self sendSubviewToBack:placeHolderImage];
//  }
//  // -- insert this subview below all the objects
//}
//@end



#pragma mark - UITableViewCell Separator Image Categories
@implementation UITableViewCell(SeparatorImage)
-(void)custom_CellAccessoryView{
  UIImageView *cellAccessoryView = [[[UIImageView alloc] initWithImage:CELL_ACCESSORYVIEW] autorelease];
    [cellAccessoryView setBackgroundColor:[UIColor clearColor]];
  [cellAccessoryView setFrame:CGRectMake((320-CELL_ACCESSORYVIEW.size.width)-10, (self.frame.size.height-CELL_ACCESSORYVIEW.size.height)/2, CELL_ACCESSORYVIEW.size.width, CELL_ACCESSORYVIEW.size.height)];
  [cellAccessoryView setBackgroundColor:[UIColor clearColor]];
    [self setAccessoryView:cellAccessoryView];
}


-(void)custom_CellAccessoryViewWithImage:(UIImage *)image{
    UIImageView *cellAccessoryView = [[[UIImageView alloc] initWithImage:image] autorelease];
    [cellAccessoryView setBackgroundColor:[UIColor clearColor]];
    [cellAccessoryView setFrame:CGRectMake((320-image.size.width)-10, (self.frame.size.height-image.size.height)/2, image.size.width, image.size.height)];
    [cellAccessoryView setBackgroundColor:[UIColor clearColor]];
    [self setAccessoryView:cellAccessoryView];
}


-(void)removeSeparator_LineForThisCell{
  if ([self viewWithTag:SEPERATOR_IMG_CONSTANT]) {
    [[self viewWithTag:SEPERATOR_IMG_CONSTANT] removeFromSuperview];
  }
}

-(void)removeSeparatorseparatorLineWithOffset{
    if ([self viewWithTag:SEPERATOR_IMG_CONSTANT_OFFSET]) {
        [[self viewWithTag:SEPERATOR_IMG_CONSTANT_OFFSET] removeFromSuperview];
    }
}

-(void)separatorLine_ForThisCell{
    
    UIImageView *separatorImg = [[[UIImageView alloc] initWithImage:SEPERATOR_IMG] autorelease];
  [separatorImg setFrame:CGRectMake((320-SEPERATOR_IMG.size.width)/2, self.frame.size.height-1, SEPERATOR_IMG.size.width, SEPERATOR_IMG.size.height)];
  [separatorImg setTag:SEPERATOR_IMG_CONSTANT];
  [separatorImg setBackgroundColor:[UIColor clearColor]];
    
  [self addSubview:separatorImg];
    
}

-(void)separatorLine_ForThisCell_iPad{

    UIImageView *separatorImg = [[[UIImageView alloc] initWithImage:SEPERATOR_IMG_IPAD] autorelease];
    [separatorImg setFrame:CGRectMake((MAIN_SCREEN_BOUNDS.size.width-SEPERATOR_IMG_IPAD.size.width)/2, self.frame.size.height-1, SEPERATOR_IMG_IPAD.size.width, SEPERATOR_IMG_IPAD.size.height)];
    [separatorImg setTag:SEPERATOR_IMG_CONSTANT];
    [separatorImg setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:separatorImg];
}

-(void)separatorLineWithOffset:(CGFloat)offset{
    
    UIImage *seperator_img = SEPERATOR_IMG;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        seperator_img = SEPERATOR_IMG;

    
    UIImageView *separatorImg = [[[UIImageView alloc] initWithImage:seperator_img] autorelease];
    [separatorImg setFrame:CGRectMake((MAIN_SCREEN_BOUNDS.size.width-seperator_img.size.width)/2, self.frame.size.height-offset, seperator_img.size.width, seperator_img.size.height)];
    [separatorImg setTag:SEPERATOR_IMG_CONSTANT_OFFSET];
    [separatorImg setBackgroundColor:[UIColor clearColor]];
    [self addSubview:separatorImg];
}

-(void)removeSeparatorColorWithOffset{
    if ([self.contentView viewWithTag:SEPERATOR_COLOR_OFFSET]) {
        [[self.contentView viewWithTag:SEPERATOR_COLOR_OFFSET] removeFromSuperview];
    }
}

-(void)separatorLine_ForThisCellWithColor:(UIColor *)color height:(NSInteger)height andWidth:(NSInteger)width witXOff:(NSInteger)xOffset{
//    [self separatorLine_ForThisCellWithColor:color height:height andWidth:width witXOff:xOffset cellHeight:self.contentView.frame.size.height];
    UIView *separatorImg = [[[UIView alloc] initWithFrame:CGRectMake(xOffset, self.contentView.frame.size.height-height, width, height)] autorelease];
    
    [separatorImg setBackgroundColor:color];
    [separatorImg setTag:SEPERATOR_COLOR_OFFSET];
    
    [self.contentView addSubview:separatorImg];
    [self bringSubviewToFront:separatorImg];
}

-(void)separatorLine_ForThisCellWithColor:(UIColor *)color height:(NSInteger)height andWidth:(NSInteger)width witXOff:(NSInteger)xOffset cellHeight:(float) cellHeight{
    UIView *separatorImg = [[[UIView alloc] initWithFrame:CGRectMake(xOffset, cellHeight-height, width, height)] autorelease];
    
    [separatorImg setBackgroundColor:color];
    [separatorImg setTag:SEPERATOR_COLOR_OFFSET];
    
    [self.contentView addSubview:separatorImg];
    [self bringSubviewToFront:separatorImg];
    
}

-(NSIndexPath*)getIndexPath{
    UITableView *tableView_ = (UITableView*)[self superview];
    NSIndexPath *indexPath_ = [tableView_ indexPathForCell:self];
    return indexPath_;
}
@end


#pragma mark - Separator Image Categories
@implementation UIImageView(SeparatorImage)

+(UIImageView*)bottomImageView_ForThisViewFrame:(CGRect)thisFrame andImage:(UIImage*)image_{
  UIImageView *separatorImg = [[[UIImageView alloc] initWithImage:image_] autorelease];
  [separatorImg setFrame:CGRectMake((320-image_.size.width)/2, thisFrame.size.height-image_.size.height, image_.size.width, image_.size.height)];
  [separatorImg setBackgroundColor:[UIColor clearColor]];
  return separatorImg;
}

+(UIImageView*)separatorImageView_ForThisViewFrame:(CGRect)thisFrame{
  UIImageView *separatorImg = [[[UIImageView alloc] initWithImage:SEPERATOR_IMG] autorelease];
  [separatorImg setFrame:CGRectMake((320-SEPERATOR_IMG.size.width)/2, thisFrame.size.height-1, SEPERATOR_IMG.size.width, SEPERATOR_IMG.size.height)];
  [separatorImg setBackgroundColor:[UIColor clearColor]];
  return separatorImg;
}

+(UIImageView*)separatorForThisView:(CGRect)thisFrame withColor:(UIColor*)separtorColor{

    UIImageView *separatorImg = [[[UIImageView alloc] initWithImage:nil] autorelease];
    [separatorImg setFrame:thisFrame];
    [separatorImg setBackgroundColor:separtorColor];
    return separatorImg;
}

@end


#pragma mark - Resign First responder Class
@implementation UIView (FindAndResignFirstResponder)

- (void)putCellSeparatorImage{
  UIImageView *separatorImg = [[[UIImageView alloc] initWithImage:SEPERATOR_IMG] autorelease];
  [separatorImg setFrame:CGRectMake((320-SEPERATOR_IMG.size.width)/2, self.frame.size.height-1, SEPERATOR_IMG.size.width, SEPERATOR_IMG.size.height)];
  [separatorImg setBackgroundColor:[UIColor clearColor]];
    [separatorImg setTag:VIEW_SEPERATOR_IMG_CONSTANT];
  [self addSubview:separatorImg];

}

- (void)removeSeperatorImage{
    if ([self viewWithTag:VIEW_SEPERATOR_IMG_CONSTANT]) {
        [[self viewWithTag:VIEW_SEPERATOR_IMG_CONSTANT] removeFromSuperview];
    }
}


- (void)putCellSeparatorImageOffset:(CGFloat)offset withImg:(UIImage *)img{
    UIImageView *separatorImg = [[[UIImageView alloc] initWithImage:img] autorelease];
    [separatorImg setFrame:CGRectMake((320-img.size.width)/2, self.frame.size.height-offset, img.size.width, SEPERATOR_IMG.size.height)];
    [separatorImg setBackgroundColor:[UIColor clearColor]];
    [separatorImg setTag:VIEW_SEPERATOR_IMG_CONSTANT_OFFSET];
    [self addSubview:separatorImg];
    
}

- (void)removeSeperatorImageOffset:(CGFloat)offset{
    if ([self viewWithTag:VIEW_SEPERATOR_IMG_CONSTANT_OFFSET]) {
        [[self viewWithTag:VIEW_SEPERATOR_IMG_CONSTANT_OFFSET] removeFromSuperview];
    }
}

-(void)removeSeparatorColorWithOffsetForView{
    if ([self viewWithTag:SEPERATOR_COLOR_OFFSET]) {
        [[self viewWithTag:SEPERATOR_COLOR_OFFSET] removeFromSuperview];
    }

}

-(void)separatorLine_ForThisViewWithColor:(UIColor *)color height:(NSInteger)height andWidth:(NSInteger)width{

    UIView *separatorImg = [[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-height, width, height)] autorelease];
    
    [separatorImg setBackgroundColor:color];
    [separatorImg setTag:SEPERATOR_COLOR_OFFSET];
    
    [self addSubview:separatorImg];
    [self bringSubviewToFront:separatorImg];
}


- (BOOL)findAndResignFirstResponder
{
    if (self.isFirstResponder) {
        [self resignFirstResponder];
        return YES;
    }
    for (UIView *subView in self.subviews) {
        if ([subView findAndResignFirstResponder])
            return YES;
    }
    return NO;
}


- (BOOL)findAndResignFirstResponderForTextField{
  
  
  //RDLog(@"\n%s ************************************************** %@ \n",__FUNCTION__,self);
  
  if (([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]]) && self.isFirstResponder) {
    //RDLog(@"\n%s >>>>>>>>> %@  \n",__FUNCTION__,self);
    [self resignFirstResponder];
    return YES;
  }
//  else if(([self isKindOfClass:[UIButton class]] && ([((UIButton*)self).titleLabel.text isEqualToString:@"Done"] || [((UIButton*)self).titleLabel.text isEqualToString:@"Cancel"]))){
//    //RDLog(@"\n%s ^^^^^^^^^^^^ \n",__FUNCTION__);
//    RDLog(@"\n%s ************************************************** %@ \n",__FUNCTION__,self);
//    //[self becomeFirstResponder];
//    NSArray *actionsForTarget = [((UIButton*)self) actionsForTarget:[[[ShowImageView alloc] init] autorelease] forControlEvent:UIControlEventTouchUpInside];
//    RDLog(@"\n%s ********************* actionsForTarget %@ \n",__FUNCTION__,actionsForTarget);
//    return YES;
//  }
  for (UIView *subView in self.subviews) {
    if ([subView findAndResignFirstResponderForTextField])
      return YES;
  }
  
  //RDLog(@"\n%s !!!!!! \n",__FUNCTION__);
  
  return NO;
}

@end



