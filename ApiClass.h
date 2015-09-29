//
//  ApiClass.h
//  PUBDemoApp
//
//  Created by Ajay Bhardwaj on 23/1/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#ifndef PUBDemoApp_ApiClass_h
#define PUBDemoApp_ApiClass_h


# pragma mark - DEFAULT SETTINGS
#define DEVICE_TYPE_ @"iOS"
#define APP_VERSION_ @"1"
#define APP_NAME_ @"Public App"
#define DEVICE_TYPE_KEY @"device_type"
#define APP_VERSION_KEY @"app_version"
#define APP_NAME_KEY @"app_name"
#define AUTHORIZATION_TOKEN @"X-authorization"
#define SERVER_COMMON_ERROR @"Server is currently busy. Please try again later."
#define SERVER_STATUSCODE @"status_code"
#define SERVER_ERRORCODE @"errorCode"
#define REQUEST_SUCCESS 0
#define REQUEST_FAILURE 400
#define REQUEST_FAILURE_401 401
#define SERVER_MESSAGE @"message"
#define INVALID_OAUTH_CREDENTIAL 403
#define ACCOUNT_ACCESS_TOKEN @"AccessToken"

// API Parameters
#define API_ACKNOWLEDGE @"Acknowledge"
#define API_MESSAGE @"Message"
#define API_STATUS_CODE @"StatusCode"

#define API_CLIENT_TAG_VALUE @"f4fn5qkg1id"
#define API_CLIENT_TAG @"ClientTag"

#define ABC_WATER_SITES_RESPONSE_NAME @"ListABCWaterSites"
#define ABC_WATER_SITES_TOTAL_COUNT @"TotalABCWaterSites"
#define EVENTS_RESPONSE_NAME @"ListEvents"
#define EVENTS_TOTAL_COUNT @"TotalEvents"
#define WLS_LISTING_RESPONSE_NAME @"ListWaterLevelSensorStation"
#define WLS_LISTING_TOTAL_COUNT @"TotalWaterLevelSensorStation"
#define CCTV_LISTING_RESPONSE_NAME @"ListCCTV"
#define CCTV_LISTING_TOTAL_COUNT @"TotalCCTV"


# pragma mark - BASE URLS
#define BASE_URL @"https://pubapps.com.sg:8080/api/v1/"

#define API_BASE_URL @"http://52.74.251.44/PUB.MyWater.Api.New/api/"
#define MODULES_API_URL @"Modules/"
#define FEEDBACK_API_URL @"Feedback/"
#define SIGNUP_API_URL @"SignUp/"
#define VERIFICATION_API_URL @"Verification/"
#define LOGIN_API_URL @"Login/"


#define IMAGE_BASE_URL @"https://pubapps.com.sg:8080/images/"
//#define UPLOAD_IMAGE_BASE_URL @"http://52.74.251.44/PUB.MyWater.Api.New/uploads/"


#define TWELVE_HOUR_FORECAST @"http://www.nea.gov.sg/api/WebAPI/?dataset=12hrs_forecast&keyref=781CF461BB6606ADE5BD65643F17817407DD6DBD4D056893"
#define NOWCAST_WEATHER_URL @"http://www.nea.gov.sg/api/WebAPI/?dataset=nowcast&keyref=781CF461BB6606ADE5BD65643F17817407DD6DBD4D056893"
#define THREE_DAYS_FORECAST @"http://www.nea.gov.sg/api/WebAPI/?dataset=3days_outlook&keyref=781CF461BB6606ADE5BD65643F17817407DD6DBD4D056893"

# pragma mark - ABC WATERS
#define ABC_WATERS_LISTING @"ABCWaterSites"

# pragma mark - EVENTS
#define EVENTS_LISTING @"Events"

#endif
