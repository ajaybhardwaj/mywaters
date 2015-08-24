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

@implementation NSDate (category)
- (NSDate *)shortDateFromFullDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

-(NSString *)getTimeDifference
{
    // -- convert seconds to hours 
    //2012-04-21 17:41:55
    NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:self]; 
    seconds = (double)seconds;
    double hours = seconds/(60.0 * 60.0);

    //RDLog(@"\n\n hours %f \n\n",hours);
    if (hours>=24.0) {
        hours = hours/24.0;
        //return [NSString stringWithFormat:@"%d days ago",(int)hours];
        if (((int)hours)>1)
            return [NSString stringWithFormat:@"%d days ago",(int)hours];
        else
            return [NSString stringWithFormat:@"%d day ago",(int)hours];

    }
    else {
        // -- hours
        if (hours>1.0) {
            //return [NSString stringWithFormat:@"%d hours ago",(int)hours];
            if (((int)hours)>1)
                return [NSString stringWithFormat:@"%d hours ago",(int)hours];
            else
                return [NSString stringWithFormat:@"%d hour ago",(int)hours];
            
        }
        else {
            // -- minutes
            hours = seconds/60.0;
            //RDLog(@"\n\n seconds 1 %f \n\n",hours);
            if (hours>=1.0) {
                //return [NSString stringWithFormat:@"%.2f minutes ago",(float)hours];
                if (((int)hours)>1)
                    return [NSString stringWithFormat:@"%d minutes ago",(int)hours];
                else
                    return [NSString stringWithFormat:@"%d minute ago",(int)hours];

                
            }
            // -- seconds
            else {
                //RDLog(@"\n\n seconds 2 %f \n\n",seconds);
                //return [NSString stringWithFormat:@"%.2f seconds ago",(float)seconds];
                return [NSString stringWithFormat:@"%d seconds ago",(int)seconds];
            }
            
        }

    }
}

-(NSString *)getShortStyleDate{
    // -- convert seconds to hours
    // -- 2012-04-21 17:41:55
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    //RDLog(@" Date Formatter Values %@" ,[dateFormatter stringFromDate:self]);
    return [dateFormatter stringFromDate:self];
}

-(NSString *)userFriendlyDate{

    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"EEEE, MMM dd, yyyy"];
    return [dateFormatter stringFromDate:self];

}

-(NSString *)getDaysLeftStyleDate{
    // -- convert seconds to hours
    //2012-04-21 17:41:55
    NSTimeInterval seconds = [self timeIntervalSinceDate:[NSDate date]];
    seconds = (double)seconds;
    double hours = seconds/(60.0 * 60.0);
    
    //RDLog(@"\n\n hours %f \n\n",hours);
    
    if (hours>=24.0) {
        hours = hours/24.0;
        if (((int)hours)>1)
            return [NSString stringWithFormat:@"%d days left",(int)hours];
        else
            return [NSString stringWithFormat:@"%d day left",(int)hours];
        
    }
    else{
        return @"";
    }
}

-(NSString *)getDayOfDate{
    
    NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
    NSDateComponents *dateComp = [gregorian components:NSWeekdayCalendarUnit fromDate:self];
    
    //RDLog(@"\n\n --- [dateComp weekday] %d ",[dateComp weekday]);
    
    switch ([dateComp weekday]) {
        case 1:
            return [NSString stringWithFormat:@"Sun"];
            break;
        case 2:
            return [NSString stringWithFormat:@"Mon"];
            break;
        case 3:
            return [NSString stringWithFormat:@"Tue"];
            break;
        case 4:
            return [NSString stringWithFormat:@"Wed"];
            break;
        case 5:
            return [NSString stringWithFormat:@"Thu"];
            break;
        case 6:
            return [NSString stringWithFormat:@"Fri"];
            break;
        case 7:
            return [NSString stringWithFormat:@"Sat"];
            break;
            
        default:
            return @"";
            break;
    }
    
    return @"";
    
}

-(NSString*)getCouponDate{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy hh:mm a"];
    return [dateFormatter stringFromDate:self];
}


-(NSString*)getTimeFromDate{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"hh:mm a"];
    return [dateFormatter stringFromDate:self];
}

@end

#pragma mark - String Categories

@interface NSString (category)
-(NSDate *)getDateFromString;
-(BOOL)isNull;
-(BOOL)isNullString;
-(NSString *)md5String;
@end

@implementation NSString (category)

-(NSDate *)getDateFromString
{
    
    //RDLog(@"\n\n self String %@ \n\n",self);
    // -- 2012-04-21 17:41:55
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];    
    /*Change here for other format*/
    /*2012-04-21 -- got 10 characters so */
    if ([self length] == 10) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateStr = [dateFormatter dateFromString:self];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//        self = [dateFormatter stringFromDate:dateStr];
        dateStr = [dateFormatter dateFromString:[dateFormatter stringFromDate:dateStr]];
        //RDLog(@"\n\n self Date 000000000 %@ \n\n",dateStr);
        return dateStr;

    }    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateStr = [dateFormatter dateFromString:self];
    //RDLog(@"\n\n self Date 11111111 %@ \n\n",dateStr);
    return dateStr;
}

-(BOOL)isNull{
  BOOL isNull_ = FALSE;
  if ([self isKindOfClass:[NSNull class]]) {
    return (isNull_ = TRUE);
  }
  if ([self length]==0) {
    return (isNull_ = TRUE);
  }
  if ([self isEqualToString:@""]) {
    return (isNull_ = TRUE);
  }
  return isNull_;
}


-(BOOL)isNullString{
    BOOL isNull_ = TRUE;
    if ([self rangeOfString:@"null" options:NSCaseInsensitiveSearch].location==NSNotFound) {
        isNull_ = FALSE;
    }
    return isNull_;
}

-(NSString *)md5String{
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
