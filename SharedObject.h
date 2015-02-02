//
//  SharedObject.h
//  CrowdSav
//
//  Created by Raja Saravanan on 11/8/11.
//  Copyright 2011 Shownearby. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "iMConstants.h"
#import "Constants.h"
#import "ApiClass.h"
#include <QuartzCore/CoreAnimation.h>


@class AppDelegate;
@interface SharedObject : NSObject {

}

@property (nonatomic, retain) NSString* userName_;
@property (nonatomic, retain) NSString* password_;

+(SharedObject*)sharedClass;

#pragma mark - FB USER ID AND AUTHENTICATION

#pragma mark - Authentication

#pragma mark - get App delegate Instance
+(AppDelegate*)appDelegate_Instance;

#pragma mark - fitnessChamp Account access storage
-(void)saveEmail:(NSString*)email password:(NSString*)password;
-(void)removeSaved_SUPER_SPORTS_CLUB_User;
-(void)save_SUPER_SPORTS_CLUB_AccessToken:(NSString*)accTok andAccID:(NSString*)accID;
-(void)save_SUPER_SPORTS_CLUB_AccessToken:(NSString*)accTok andAccID:(NSString*)accID forUser:(NSString*)user;
-(void)save_SUPER_SPORTS_CLUB_DeviceToken:(NSString*)deviceTok andAccID:(NSString*)accID;
-(void)saveAccount:(NSString *) account_id Email:(NSString*) email mobile:(NSString *) mobile username:(NSString *) username;
-(void)saveRoleId:(NSString *) role_id;
-(void)saveAccessTokenIfNeed:(NSDictionary *) dictData;
-(BOOL)isSSCUserSignedIn;
-(NSString*)getPhysicalABuseUsername;
-(NSString*)getPhysicalABuseUser_Email;
-(NSString*)getPhysicalABusePassword;
-(NSString*)getPhysicalABuseAccessToken;
-(NSString*)getPhysicalABuseAccounId;
-(NSString*)getPhysicalABuseRoleId;
-(NSString*)getPhysicalABuseDeviceToken;
-(id) getUserInfoByKey:(NSString *) key;
-(void)saveData:(NSData*)dataDictionary withKey:(NSString*)key;
-(bool) isAlphaNumericCharacters:(NSString *) str;
-(BOOL) isValidString:(NSString *) str;
-(BOOL) isValidName:(NSString *) str;
-(BOOL) isValidCommonString:(NSString *) str;

#pragma mark - Location Settings
+(void)setLocationRadius:(NSString*)locationRadius andIndex:(NSNumber*)index;
+(NSString*)getLocationRadius;
+(NSNumber*)getLocationRadius_Index;
+(NSString*)getRadius_Distance;


#pragma mark - Validation
-(BOOL) isValidEmail:(NSString*) emailId;
+ (NSString *) pharsePhone:(NSString *)phoneString;
- (BOOL) isMobileNoValid:(NSString*) mobile;

#pragma mark - File storing
-(NSString *)savePathWithlasComponent:(NSString*)keyValue;
-(void)saveDictionary:(NSDictionary*)dataDictionary withKey:(NSString*)key;
-(NSDictionary*)getDictionaryFromFilePath_ForKey:(NSString*)key;
-(NSData*)getDataFromFilePath_ForKey:(NSString*)key;

#pragma mark - utils
-(NSURL *) getAvailUrl:(id) str;
-(NSString *) getAvailStr:(id) str;
-(NSURL *) getAPIPhotoUrlBySize:(NSString *) size photoName:(NSString *) photoName apiResultData:(NSDictionary *) dataDict;

@end
