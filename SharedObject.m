//
//  SharedObject.m
//  CrowdSav
//
//  Created by Raja Saravanan on 11/8/11.
//  Copyright 2011 Shownearby. All rights reserved.
//



#import "SharedObject.h"
#import "SFHFKeychainUtils.h"
#import "AppDelegate.h"

@implementation SharedObject
@synthesize userName_;
@synthesize password_;

static SharedObject *sharedInstance_ = nil;  // -- shared instacne class object

+(SharedObject*)sharedClass{
    
    if (sharedInstance_ == nil) {
        sharedInstance_ = [[SharedObject alloc] init];
    }
    
    return sharedInstance_;
}
-(void) dealloc{
    
    if (password_) {
        [password_ release];
        password_ = nil;
    }
    if (userName_) {
        [userName_ release];
        userName_ = nil;
    }
    [super dealloc];
}
-(id)init{
    
    self = [super init];
    
    if (self) {
        // -- do the initialization here
    }
    
    return  self;
}
#pragma mark - get App delegate Instance
+(AppDelegate*)appDelegate_Instance{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}


# pragma mark - User Defaults For PUB App

- (void) savePUBUserData:(NSDictionary*) dict {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([[dict objectForKey:@"UserProfile"] valueForKey:@"ID"] != (id)[NSNull null])
        [prefs setValue:[[dict objectForKey:@"UserProfile"] valueForKey:@"ID"] forKey:@"userID"];
    if ([[dict objectForKey:@"UserProfile"] valueForKey:@"Name"] != (id)[NSNull null])
        [prefs setValue:[[dict objectForKey:@"UserProfile"] valueForKey:@"Name"] forKey:@"userName"];
    if ([[dict objectForKey:@"UserProfile"] valueForKey:@"Email"] != (id)[NSNull null])
        [prefs setValue:[[dict objectForKey:@"UserProfile"] valueForKey:@"Email"] forKey:@"userEmail"];
    if ([[dict objectForKey:@"UserProfile"] valueForKey:@"Password"] != (id)[NSNull null])
        [prefs setValue:[[dict objectForKey:@"UserProfile"] valueForKey:@"Password"] forKey:@"userPassword"];
    if ([[dict objectForKey:@"UserProfile"] valueForKey:@"FacebookID"] != (id)[NSNull null])
        [prefs setValue:[[dict objectForKey:@"UserProfile"] valueForKey:@"FacebookID"] forKey:@"userFacebookID"];
    if ([[dict objectForKey:@"UserProfile"] valueForKey:@"ImageName"] != (id)[NSNull null])
        [prefs setValue:[[dict objectForKey:@"UserProfile"] valueForKey:@"ImageName"] forKey:@"userProfileImageName"];
    if ([[dict objectForKey:@"UserProfile"] valueForKey:@"ImageBase64"] != (id)[NSNull null])
        [prefs setValue:[[dict objectForKey:@"UserProfile"] valueForKey:@"ImageBase64"] forKey:@"userProfileImageBase64"];
    if ([[dict objectForKey:@"UserProfile"] valueForKey:@"IsFriendofWater"] != (id)[NSNull null])
        [prefs setValue:[[dict objectForKey:@"UserProfile"] valueForKey:@"IsFriendofWater"] forKey:@"userIsFriendOfWater"];
    if ([[dict objectForKey:@"UserProfile"] valueForKey:@"IsEmailVerified"] != (id)[NSNull null])
        [prefs setValue:[[dict objectForKey:@"UserProfile"] valueForKey:@"IsEmailVerified"] forKey:@"isEmailVerified"];
    if ([[dict objectForKey:@"UserProfile"] valueForKey:@"IsAllowChangePassword"] != (id)[NSNull null])
        [prefs setValue:[[dict objectForKey:@"UserProfile"] valueForKey:@"IsAllowChangePassword"] forKey:@"isAllowChangePassword"];
    if ([[dict objectForKey:@"UserProfile"] valueForKey:@"Status"] != (id)[NSNull null])
        [prefs setValue:[[dict objectForKey:@"UserProfile"] valueForKey:@"Status"] forKey:@"userStatus"];
    if ([[dict objectForKey:@"UserProfile"] valueForKey:@"CurrentRewardPoints"] != (id)[NSNull null])
        [prefs setValue:[[dict objectForKey:@"UserProfile"] valueForKey:@"CurrentRewardPoints"] forKey:@"userRewardPoints"];
    if ([dict valueForKey:@"AccessToken"] != (id)[NSNull null])
        [prefs setValue:[dict valueForKey:@"AccessToken"] forKey:@"AccessToken"];

    [prefs synchronize];
    
}


- (void) clearPUBUserSavedData {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs removeObjectForKey:@"userID"];
    [prefs removeObjectForKey:@"userName"];
    [prefs removeObjectForKey:@"userEmail"];
    [prefs removeObjectForKey:@"userPassword"];
    [prefs removeObjectForKey:@"userFacebookID"];
    [prefs removeObjectForKey:@"userProfileImageName"];
    [prefs removeObjectForKey:@"userProfileImageBase64"];
    [prefs removeObjectForKey:@"userIsFriendOfWater"];
    [prefs removeObjectForKey:@"isEmailVerified"];
    [prefs removeObjectForKey:@"isAllowChangePassword"];
    [prefs removeObjectForKey:@"userStatus"];
    [prefs removeObjectForKey:@"userRewardPoints"];
    [prefs removeObjectForKey:@"AccessToken"];
    [prefs synchronize];
}


- (NSString*) getPUBUserSavedDataValue:(NSString*) keyName {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs objectForKey:keyName];
}



#pragma mark - FB USER ID AND AUTHENTICATION
-(void)saveFBID:(NSString*)fbId{
    NSUserDefaults *deflts = [NSUserDefaults standardUserDefaults];
    [deflts setObject:fbId forKey:FB_ID];
    [deflts synchronize];
}
-(NSString*)getFBID{
    NSUserDefaults *deflts = [NSUserDefaults standardUserDefaults];
    if ([deflts objectForKey:FB_ID]) {
        return (NSString*)[deflts objectForKey:FB_ID];
    }
    else{
        return nil;
    }

}
-(void)saveFBAccessToken:(NSString*)fbId{
    NSUserDefaults *deflts = [NSUserDefaults standardUserDefaults];
    [deflts setObject:fbId forKey:FB_ACCESSTOKEN];
    [deflts synchronize];

}
-(NSString*)getFBAccessToken{
    NSUserDefaults *deflts = [NSUserDefaults standardUserDefaults];
    if ([deflts objectForKey:FB_ACCESSTOKEN]) {
        return (NSString*)[deflts objectForKey:FB_ACCESSTOKEN];
    }
    else{
        return nil;
    }

}



#pragma mark - Temporary storage
-(void)saveEmail:(NSString*)email password:(NSString*)password{
  NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
  [defaults setObject:email forKey:USER_EMAIL];
  [defaults setObject:password forKey:PASSWORD];
  [defaults synchronize];
  
}

-(void)saveAccount:(NSString *) account_id Email:(NSString*) email mobile:(NSString *) mobile username:(NSString *) username
{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setObject:email forKey:USER_EMAIL];
    [defaults setObject:account_id forKey:ACCOUNT_ID];
    [defaults setObject:mobile forKey:USER_MOBILE_NUMBER];
    [defaults setObject:username forKey:USERNAME];
    [defaults synchronize];
}

-(void)saveRoleId:(NSString *) role_id
{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setObject:role_id forKey:USER_ROLE];
    [defaults synchronize];
}

-(void)removeSaved_SUPER_SPORTS_CLUB_User{
    // FBSample logic
    // if the app is going away, we close the session object; this is a good idea because
    // things may be hanging off the session, that need releasing (completion block, etc.) and
    // other components in the app may be awaiting close notification in order to do cleanup
    //[FBSession.activeSession close];

    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USER_EMAIL];
    [defaults removeObjectForKey:PASSWORD];
    [defaults removeObjectForKey:ACCESS_TOKEN];
    [defaults removeObjectForKey:ACCOUNT_ID];
    [defaults removeObjectForKey:USERNAME];
    [defaults removeObjectForKey:USER_MOBILE_NUMBER];
    [defaults synchronize];
}

-(void)save_SUPER_SPORTS_CLUB_AccessToken:(NSString*)accTok andAccID:(NSString*)accID{
  NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
  [defaults setObject:accTok forKey:ACCESS_TOKEN];
  [defaults setObject:accID forKey:ACCOUNT_ID];
  [defaults synchronize];
}

-(void)save_SUPER_SPORTS_CLUB_AccessToken:(NSString*)accTok{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setObject:accTok forKey:ACCESS_TOKEN];
    [defaults synchronize];
}


-(void)save_SUPER_SPORTS_CLUB_DeviceToken:(NSString*)deviceTok andAccID:(NSString*)accID{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceTok forKey:DEVICE_TOKEN];
    [defaults synchronize];

}
-(void)save_SUPER_SPORTS_CLUB_AccessToken:(NSString*)accTok andAccID:(NSString*)accID forUser:(NSString*)user{
  NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
  [defaults setObject:accTok forKey:ACCESS_TOKEN];
  [defaults setObject:accID forKey:ACCOUNT_ID];
  [defaults setObject:user forKey:USERNAME];
  [defaults synchronize];
}

-(BOOL)isSSCUserSignedIn{
  NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
  if ([defaults objectForKey:ACCESS_TOKEN] && [defaults objectForKey:ACCOUNT_ID]) {
    return YES;
  }
  else{
    return NO;
  }
}


#pragma mark - 
-(NSString*)getPhysicalABuseDeviceToken{
    NSString *user_email = ([[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_TOKEN]) ? [[NSUserDefaults standardUserDefaults] objectForKey:DEVICE_TOKEN] : nil;
    return user_email;
    
}


-(NSString*)getPhysicalABuseUsername{
  NSString *user_email = ([[NSUserDefaults standardUserDefaults] objectForKey:USERNAME]) ? [[NSUserDefaults standardUserDefaults] objectForKey:USERNAME] : nil;
  return user_email;

}
-(NSString*)getPhysicalABuseUser_Email{
 NSString *user_email = ([[NSUserDefaults standardUserDefaults] objectForKey:USER_EMAIL]) ? [[NSUserDefaults standardUserDefaults] objectForKey:USER_EMAIL] : nil;
  return user_email;
}
-(NSString*)getPhysicalABusePassword{
  NSString *user_email = ([[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD]) ? [[NSUserDefaults standardUserDefaults] objectForKey:PASSWORD] : nil;
  return user_email;

}
-(NSString*)getPhysicalABuseAccessToken{
  NSString *user_email = ([[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN]) ? [[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN] : nil;
    if ([user_email isKindOfClass:[NSString class]]) {
        return user_email;
    }else{
        return @"";
    }
}
-(NSString*)getPhysicalABuseAccounId{
  NSString *user_email = ([[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ID]) ? [[NSUserDefaults standardUserDefaults] objectForKey:ACCOUNT_ID] : nil;
  return user_email;

}
-(NSString*)getPhysicalABuseRoleId{
    NSString *role_id = ([[NSUserDefaults standardUserDefaults] objectForKey:USER_ROLE]) ? [[NSUserDefaults standardUserDefaults] objectForKey:USER_ROLE] : nil;
    if (role_id==nil) {
        role_id = @"-999999";
    }

    return role_id;
}

-(BOOL) isValidName:(NSString *) str
{
//    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789'\\<>,.?/:;}{[]|)(*&^!@#$%+=-\"_"];
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"0123456789'\\<>,.?/:;}{[]|)(*&^!@#$%+=\"_"];
    return [str rangeOfCharacterFromSet:set].location == NSNotFound;
}

-(BOOL) isValidCommonString:(NSString *) str
{
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ.)(*&@#"] invertedSet];
    
    return [str rangeOfCharacterFromSet:set].location == NSNotFound;
}

//-(BOOL) isValidNumericString:(NSString *) str
//{
//    NSCharacterSet *set1 = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.?/:;}{[]|)(*&^!@#$%+=-_"];
//    
//}

-(BOOL) isValidString:(NSString *) str
{
    if (str==nil) {
        return true;
    }
    
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSCharacterSet *blockedCharacters = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    return [str rangeOfCharacterFromSet:blockedCharacters].location ==  NSNotFound;
}


-(bool) isAlphaNumericCharacters:(NSString *) str
{
    NSCharacterSet *blockedCharacterset = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
    NSCharacterSet *letterCharacterset = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *numericCharacterset = [NSCharacterSet decimalDigitCharacterSet];
    
    if ([str rangeOfCharacterFromSet:blockedCharacterset].location==NSNotFound) {
        if([str rangeOfCharacterFromSet:letterCharacterset].location != NSNotFound && [str rangeOfCharacterFromSet:numericCharacterset].location != NSNotFound)
        {
            return YES;
        }
    }
    
    return NO;
}


#pragma mark - Location Settings

+(void)setLocationRadius:(NSString*)locationRadius andIndex:(NSString*)index{

  NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
  [defaults setObject:locationRadius forKey:LOCATION_RADIUS];
  [defaults setObject:index forKey:LOCATION_RADIUS_INDEX];
  [defaults synchronize];

}

+(NSString*)getRadius_Distance{
  NSString *radius_Dist = @"0";
  switch ([[SharedObject getLocationRadius_Index] intValue]) {
    case 0:
      radius_Dist = @"1";
      break;
    case 1:
      radius_Dist = @"5";
      break;
    case 2:
      radius_Dist = @"10";
      break;
    case 3:
      radius_Dist = @"0";
      break;
      
      
    default:
      radius_Dist = @"0";
      break;
  }
  return radius_Dist;
}

+(NSString*)getLocationRadius{
  NSString* locationRadius = ([[NSUserDefaults standardUserDefaults] objectForKey:LOCATION_RADIUS]) ? [[NSUserDefaults standardUserDefaults] objectForKey:LOCATION_RADIUS] : nil;
  return locationRadius;

}
+(NSNumber*)getLocationRadius_Index{
  NSNumber* locationRadius_Index = ([[NSUserDefaults standardUserDefaults] objectForKey:LOCATION_RADIUS_INDEX]) ? [[NSUserDefaults standardUserDefaults] objectForKey:LOCATION_RADIUS_INDEX] : nil;
  return locationRadius_Index;

}


#pragma mark - dummy for prototype
//
//-(void)saveAccessTokenValue:(NSString*)accTok andAccID:(NSString*)accID{
//    NSError* err;
//    [SFHFKeychainUtils storeUsername:ACCESS_TOKEN andPassword:accTok forServiceName:SERVICE_NAME updateExisting:TRUE error:&err];
//    [SFHFKeychainUtils storeUsername:ACCOUNT_ID andPassword:accID forServiceName:SERVICE_NAME updateExisting:TRUE error:&err];
//}
//
//-(NSString*)getAccessToken{
//    NSError* err;
//    if ([SFHFKeychainUtils getPasswordForUsername:ACCESS_TOKEN andServiceName:SERVICE_NAME error:&err]){
//		
//        return [SFHFKeychainUtils getPasswordForUsername:ACCESS_TOKEN andServiceName:SERVICE_NAME error:&err];
//	}
//    else{
//
//        return nil;
//    }
//}
//-(NSString*)getAccounId{
//    NSError* err;
//    if ([SFHFKeychainUtils getPasswordForUsername:ACCOUNT_ID andServiceName:SERVICE_NAME error:&err]){
//		
//        return [SFHFKeychainUtils getPasswordForUsername:ACCOUNT_ID andServiceName:SERVICE_NAME error:&err];
//	}
//    else{
//        
//        return nil;
//    } 
//}


//-(void)saveUserName:(NSString*)user accessToken:(NSString*)acc;{
//
////    [[NSUserDefaults standardUserDefaults] setObject:user forKey:USERNAME];
////    [[NSUserDefaults standardUserDefaults] setObject:acc forKey:ACCESS_TOKEN];
////    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    //-- STORE USER NAME FIRST TIME AND AT UPDATION
//    
//    NSError* err;
//    [SFHFKeychainUtils storeUsername:USERNAME andPassword:user forServiceName:SERVICE_NAME updateExisting:TRUE error:&err];
//    [SFHFKeychainUtils storeUsername:PASSWORD andPassword:acc forServiceName:SERVICE_NAME updateExisting:TRUE error:&err];
//    [SFHFKeychainUtils storeUsername:IS_USER_SIGNED_IN andPassword:@"1" forServiceName:SERVICE_NAME updateExisting:TRUE error:&err];
//    
//}
//
//-(void)removeUser{
//    
//    NSError* err;
//    
//    if([SFHFKeychainUtils getPasswordForUsername:USERNAME andServiceName:SERVICE_NAME error:&err] && [SFHFKeychainUtils getPasswordForUsername:PASSWORD andServiceName:SERVICE_NAME error:&err]){
//		
//        [SFHFKeychainUtils deleteItemForUsername:USERNAME andServiceName:SERVICE_NAME error:&err];
//        [SFHFKeychainUtils deleteItemForUsername:PASSWORD andServiceName:SERVICE_NAME error:&err];     
//        [SFHFKeychainUtils storeUsername:IS_USER_SIGNED_IN andPassword:@"0" forServiceName:SERVICE_NAME updateExisting:TRUE error:&err];
//        
//	} 
//}

//-(BOOL)isUserSignedIn{
//
//    NSError* err;
//    
//    NSInteger isUserSigned = [(NSString*)[SFHFKeychainUtils getPasswordForUsername:IS_USER_SIGNED_IN andServiceName:SERVICE_NAME error:&err] integerValue];
//    
//    //return (BOOL)isUserSigned;
//    return isUserSigned;
//}

//
//-(NSString*)getUsername{
//    
//    NSError* err;
//    if ([SFHFKeychainUtils getPasswordForUsername:USERNAME andServiceName:SERVICE_NAME error:&err]){
//		
//        userName_=[SFHFKeychainUtils getPasswordForUsername:USERNAME andServiceName:SERVICE_NAME error:&err];
//	}
//    
//    RDLog(@"\n\n REturn getUsername %@ \n\n\n",password_);
//    
//    return userName_;
//}
//-(NSString*)getPassword{
//    
//    NSError* err;
//    if ([SFHFKeychainUtils getPasswordForUsername:PASSWORD andServiceName:SERVICE_NAME error:&err]){
//		
//        password_=[SFHFKeychainUtils getPasswordForUsername:PASSWORD andServiceName:SERVICE_NAME error:&err];
//	}
//    RDLog(@"\n\n REturn password %@ \n\n\n",password_);
//    return password_;
//}


#pragma mark - Validation
/*!
 @function
 @discussion validates the entries and sends "userreg" service request to the server and confirms the status to the users.
 */
-(id) getUserInfoByKey:(NSString *) key
{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    return [defaults valueForKey:key];
}

-(BOOL) isValidEmail:(NSString*) emailId{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL result = [emailTest evaluateWithObject:emailId];
    return result;
	
    /*
	BOOL isValid;
	NSString *emailRegEx =
    @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@[A-Za-z0-9-.]+\\.[A-Za-z]{2,4}";
	
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];  
    if ([emailTest evaluateWithObject:emailId]){
        isValid = YES;
	}
    
    else{ 
		isValid = NO;
	}
	
	return isValid;
    */
}

- (BOOL) NSStringIsValidEmail:(NSString *)checkString {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL result = [emailTest evaluateWithObject:checkString];
    return result;
}

+ (NSString *) pharsePhone:(NSString *)phoneString
{
	NSMutableString *cleanedString = [NSMutableString stringWithCapacity:phoneString.length];
	
	NSScanner *scanner = [NSScanner scannerWithString:phoneString];
	NSCharacterSet *phoneCharacters = [NSCharacterSet characterSetWithCharactersInString:@"+0123456789"];
	
	while ([scanner isAtEnd] == NO)
	{
		NSString *buffer;
		if ([scanner scanCharactersFromSet:phoneCharacters intoString:&buffer]) 
		{
			[cleanedString appendString:buffer];
		} 
		else
		{
			[scanner setScanLocation:([scanner scanLocation] + 1)];
		}
	}
	
	return (NSString*)cleanedString;
}

- (BOOL) isMobileNoValid:(NSString*) mobile{
	BOOL isValid;
	
    mobile = [mobile stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@"+" withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobile = [mobile stringByReplacingOccurrencesOfString:@"-" withString:@""];
	
	NSString *emailRegEx = @"[0-9]{8,}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];  
    if ([emailTest evaluateWithObject:mobile]){
        isValid = YES;
	}
	
    else{ 
		isValid = NO;
	}
	
	return isValid;
}



#pragma mark - Storing values
// -- SAVING FILE TO DICTIONARY.
-(NSDictionary*)getDictionaryFromFilePath_ForKey:(NSString*)key{
    
    NSString *filePath = [self savePathWithlasComponent:key];
    BOOL fileExit = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    NSDictionary *fileDict = nil;
    if (fileExit) {
        fileDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        //RDLog(@"file path values == %@",fileDict);
    }
    else{
        
    }
    return fileDict;

}

-(void)saveDictionary:(NSDictionary*)dataDictionary withKey:(NSString*)key{
  
    [dataDictionary writeToFile:[self savePathWithlasComponent:key] atomically:YES];
}

-(NSData*)getDataFromFilePath_ForKey:(NSString*)key{
    NSString *filePath = [self savePathWithlasComponent:key];
    BOOL fileExit = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    NSData *fileDict = nil;
    if (fileExit) {
        fileDict = [NSData dataWithContentsOfFile:filePath];
        //RDLog(@"file path values == %@",fileDict);
    }
    else{
        
    }
    return fileDict;
}
-(void)saveData:(NSData*)dataDictionary withKey:(NSString*)key{
    [dataDictionary writeToFile:[self savePathWithlasComponent:key] atomically:YES];
}


-(NSString *)savePathWithlasComponent:(NSString*)keyValue{
 
    //NSString* imageName = @"Questions.plist";
	
	// Now, we have to find the documents directory so we can save it
	// Note that you might want to save it elsewhere, like the cache directory,
	// or something similar.
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* documentsDirectory = [paths objectAtIndex:0];
	
	// Now we get the full path to the file
	NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:keyValue];
	
	// and then we write it out	
	return fullPathToFile;
 
}

-(void)saveAccessTokenIfNeed:(NSDictionary *) dictData
{
    NSString *access_token = nil;
    
    if ([dictData valueForKey:SUPER_SPORTS_CLUB_ACCESSTOKEN_KEY_GET]) {
        access_token = [dictData valueForKey:SUPER_SPORTS_CLUB_ACCESSTOKEN_KEY_GET];
    }
    
    if (access_token) {
        [self save_SUPER_SPORTS_CLUB_AccessToken:access_token];
        
    }
    
}

#pragma mark utils
-(NSString *) getAvailStr:(id) str
{
    if (nil!=str && str!=[NSNull null]) {
        if ([str isKindOfClass:[NSString class]]) {
            if (![str isEqualToString:@"<null>"] && ![str isEqualToString:@"NaN"]) {
                return str;
            }else{
                return @"";
            }
        }
        
        return str;
    }
    
    return @"";
}

-(NSURL *)getAvailUrl:(id)str
{
    NSString *strUrl = [self getAvailStr:str];
    return [NSURL URLWithString:[strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

-(NSURL *) getAPIPhotoUrlBySize:(NSString *) size photoName:(NSString *) photoName apiResultData:(NSDictionary *) dataDict
{
    return [self getAvailUrl:[NSString stringWithFormat:@"%@%@",[[dataDict valueForKey:_API_FOLDER] valueForKey:size],photoName]];
}

@end
