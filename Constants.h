//
//  Constants.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 22/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#ifndef PUBDemoApp_Constants_h
#define PUBDemoApp_Constants_h


#endif

#define CELL__SECTION_HEADER_TEXT @"cell_SECTION_HEADER_TEXT"
#define TABLE__SECTION_ARRAY @"cell_SECTION_ARRAY"

#define CELL__MAIN_TXT @"cell_main_text"
#define CELL__SUB_TXT @"cell_sub_text"
#define CELL__IMG @"cell_image"


#pragma mark - FB
#define FB_ACCESSTOKEN @"com.supersportsclub.sg.fb.accesstoken"
#define FB_ID @"com.supersportsclub.sg.fb.userid"

#pragma mark - authentication
#define USER_EMAIL @"com.supersportsclub.user_email"
#define USER_ROLE @"com.supersportsclub.user_role"
#define USERNAME @"com.supersportsclub.username"
#define PASSWORD @"com.supersportsclub.password"
#define IS_USER_SIGNED_IN @"com.supersportsclub.isuser.signedin"
#define ACCOUNT_ID @"com.supersportsclub.account_id"
#define ACCESS_TOKEN @"com.supersportsclub.access_token"
#define DEVICE_TOKEN @"com.supersportsclub.device_token"
#define USER_MOBILE_NUMBER @"com.supersportsclub.user_mobile_number"

#define LOCATION_RADIUS_INDEX @"com.supersportsclub.LOCATION_RADIUS_INDEX"
#define LOCATION_RADIUS @"com.supersportsclub.LOCATION_RADIUS"
#define LOCATION_ACCURACY @"com.supersportsclub.LOCATION_ACCURACY"

#define SUPER_SPORTS_CLUB_ACCESSTOKEN_KEY_GET @"AccessToken"
#define SUPER_SPORTS_CLUB_ACCOUNT_ID_KEY_GET @"account_id"

#define _API_FOLDER               @"folder"




#if DEBUG == 0
#define DebugLog(...)
#elif DEBUG == 1
#define DebugLog(...) NSLog(__VA_ARGS__)
#endif



#define SIDE_MENU_CELL_FONT @"Opensans"
#define BEBAS_NEUE_FONT @"BebasNeue"
#define OPEN_SANS_REGULAR @"Opensans"
#define OPEN_SANS_BOLD @"Opensans-Bold"
#define OPTIMA_BOLD @"Optima-Bold"
#define OPTIMA_REGULAR @"Optima-Regular"
#define ROBOTO_BOLD @"Roboto-Bold"
#define ROBOTO_REGULAR @"Roboto-Regular"
#define ROBOTO_MEDIUM @"Roboto-Medium"
#define PLACE_NAME @"name"


#ifndef RGB
#define RGB(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#endif

#ifndef RGBALPHA
#define RGBALPHA(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]
#endif




# pragma mark - Social network Variables
#define FACEBOOK_APP_ID @"363122567221033"


#pragma mark - Device Screen Sizes For UI

//#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
//#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


