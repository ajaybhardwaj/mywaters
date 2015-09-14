//
//  AuxilaryService.h
//  NParks
//
//  Created by Raja Saravanan on 1/29/12.
//  Copyright (c) 2012 Shownearby. All rights reserved.
//

// --- animation helpers
#define ANIMATION_TIME 0.3
#define STYLE_FONT_DEFAULT [UIFont systemFontOfSize:14.0];
#define STYLE_FONT_DEFAULT_BOLD [UIFont boldSystemFontOfSize:14.0];

#define STYLE_FONT_COLOR_DEFAULT_RGB RGB(85,85,85)
#define STYLE_FONT_COLOR_TITLE_DEFAULT_RGB RGB(90,90,90)
#define STYLE_FONT_COLOR_TITLE_DEFAULT [UIColor colorWithHexString:@"#FAFAF5"]
#define STYLE_FONT_COLOR_DEFAULT [UIColor colorWithHexString:@"#FDFDFD"]

#define STYLE_BUTTON_BACKGROUND_COLOR_DEFAULT [AuxilaryService getColorFromHexString:@"#CCCCCC"]
#define STYLE_SEARCH_BAR_TINT_COLOR [AuxilaryService getColorFromHexString:@"#CCCCCC"]

#define PLACENAME @"name"
#define PLACEURL @"permalink"
#define ADDRESS_S @"address"
#define ADDRESS @"Address"
#define LOCATION @"location"
#define PHONE_S @"phone_no"
#define PHONE @"Phone Number"
#define LAT @"latitude"
#define LONG @"longitude"
#define MAP @"viewmap"
#define SEND @"send"
#define BOOKMARK @"bookmark"
#define DIRECTIONS @"directions"
#define EMAIL_S @"email_address"
#define EMAIL @"Email Address"
#define WEBSITE @"Website URL"
#define WEBSITE_S @"website_url"
#define REPORT @"report"
#define CUSTOM @"custom"
#define TAGS @"tags"
#define PLACEID @"id"
#define DESCRIPTION_S @"description"
#define POI @"POI"

// -- data parsers
#import "ControllerHeaders.h"
#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "UIViewCategories.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ShowImageView.h"
#import <CommonCrypto/CommonDigest.h>
#import "Constants.h"

//#import "ServerDAO.h"
@protocol AuxilaryServiceDelegate <NSObject>
@optional
-(void)selectedImage_Data:(NSData *)imageData;
-(void)deleteImageData:(BOOL)deleteImg;
@end

// --UISearchBarDelegate,
@interface AuxilaryService : NSObject<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate, ShowImageViewDelegate>//,ServerDaoDelegate>

@property (nonatomic, assign) BOOL withDeletePhoto;
@property (nonatomic, assign) id controller;
@property (nonatomic, assign) BOOL withShowImgView;
@property (nonatomic, assign) ShowImageView *showImageV;
@property (nonatomic, assign) id <AuxilaryServiceDelegate> imageDelegate;

+(AuxilaryService*)auxFunctions;


#pragma mark - Show Alert
-(void)showAlertWithTitle:(NSString*)title msg:(NSString*)msg_ delegate:(id)delegt cancelTitle:(NSString*)cTitle;
-(void)showAlertDelegate:(id)delegt msg:(NSString*)msg_ title:(NSString*)title cancelTitle:(NSString*)cTitle otherTitle:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
-(void)showWC_AlertDelegate:(id)delegt msg:(NSString *)msg_ title:(NSString *)title cancelTitle:(NSString *)cTitle otherTitle:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
-(void)showWC_AlertDelegate:(id)delegt withTag:(NSInteger)tag msg:(NSString *)msg_ title:(NSString *)title cancelTitle:(NSString *)cTitle otherTitle:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
-(void)showError_AlertDelegate:(id)delegt withTag:(NSInteger)tag Error:(NSError *) error;
-(void)showInfoButtonAlertWithMessage:(NSString*)msg;
-(void)showUniversalPopUpsWithTitle:(NSString *)title description:(NSString *)description imageURL:(NSString *)imageURL OnClose:(void (^) ()) onClose;
-(void)showInfoButtonAlertWithMessage:(NSString*)msg ButtonTitle:(NSString *) buttonTitle;

#pragma mark - UIImagePicker Helpers
+(void)removeShowImageView:(id)controller;
-(UIImage*)scaleToSize:(CGSize)size;
-(UIImage*)scaleToSize:(CGSize)size forImage:(UIImage*)imageD;
-(void)browseBtnClicked:(id)sender withShowImgView_:(BOOL)yes_no;
-(void)browseBtnClicked:(id)sender withShowImgView_:(BOOL)yes_no andShowInView:(id)hostView;
-(void)browseBtnClicked:(id)sender withShowImgView_:(BOOL)yes_no andDeletBtn:(BOOL)showDeleteBtn;
-(void)browseBtnClicked:(id)sender withShowImgView_:(BOOL)yes_no andDeletBtn:(BOOL)showDeleteBtn andShowInView:(id)hostView;

#pragma mark - EMail global and sms Global
-(void)showEmailModalWithReceipients:(NSArray*)receipients subject:(NSString*)sub body:(NSString*)body_ onTarget:(id)target;
-(void)showEmailModalWithReceipients_:(NSArray*)receipients subject_:(NSString*)sub body_:(NSString*)body_ onTarget:(id)target ishtml:(BOOL)html attachData_:(NSData*)attachData;
-(void)showSmsModalWithReceipients:(NSArray*)receipients body:(NSString*)body_ onTarget:(id)target;

#pragma mark - helpers
-(BOOL)isDictionaryHaveData:(NSDictionary*)dict;
+ (void) setObjectAtDictionary:(NSMutableDictionary *) dictionary object:(id) object forKey:(NSString *) key;
-(BOOL)isStringAvailable:(NSString*)str inArray:(NSArray*)arr;
+(void)enableSubviews:(UIView*)view;

#pragma mark - Animation helpers
- (void) jumpAnimationForView:(UIView*)animatedView
					  toPoint:(CGPoint)point; 
+ (UIButton *) getDefaultButton: (NSString *) title image:(NSString*)img tag:(int)tagV target:(id)target selector:(NSString*)selectorStr;
+ (UIColor *) getColorFromHexString:(NSString *) hexString;
+(UIImage*)scaleImage: (UIImage *) image ToSize:(CGSize)size;

#pragma mark - Device helper
+ (BOOL) canDeviceCall;
+ (BOOL) canDeviceMutlitask;

#pragma mark - Controller Helpers
+(UIImageView*)getBadgeIcons_WithCount:(NSString*)countV frame:(CGRect)frame_;
+(NSString*)getCsv_ForInterests:(NSArray*)interest_name;
+(NSString*)splitNameFrom_FriendsName:(NSString*)friends_name;


#pragma mark - Facebook Helper
+(void)set_FacebookDictionary_Data:(NSMutableDictionary*)fbDict name:(NSString*)name caption:(NSString*)caption description:(NSString*)desc link:(NSString*)link pictureLink:(NSString*)picLink;

#pragma mark - Navigation Bar & Navigation Item Helper
+(void)setNavigationTitleStyle_ToPY:(UINavigationBar*)navBar;
+(void)setNavigationTitleStyle_ForDict:(NSDictionary*)txtColor nav_Bar:(UINavigationBar*)navBar;
-(void)pop2Dismiss:(id)sender;
+(void)addNotificationForObserver:(id)observer withSelector:(SEL)selector name:(NSString*)name andObject:(id)object;
#pragma mark - Pop Up Dismiss Navigation Controller


#pragma mark - FilePath
- (NSString *)getDocumentDirectory:(NSString *)filePath;
#pragma mark - Write & Read.. Data CSV to file
-(BOOL)isFileExists:(NSString*)fileName;



@end


#pragma  mark Date UTC format
@interface NSDate (category)
-(NSString *)getTimeDifference;
-(NSString *)getShortStyleDate;
-(NSString *)getDaysLeftStyleDate;
-(NSString *)getDayOfDate;
-(NSString*)getCouponDate;
-(NSDate *)shortDateFromFullDate;
-(NSString*)getTimeFromDate;
-(NSString *)userFriendlyDate;
@end


