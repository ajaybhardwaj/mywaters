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
#define ABC_WATER_SITES_RESPONSE_NAME @"ListABCWaterSites"
#define ABC_WATER_SITES_TOTAL_COUNT @"TotalABCWaterSites"
#define EVENTS_RESPONSE_NAME @"ListEvents"
#define EVENTS_TOTAL_COUNT @"TotalEvents"
#define WLS_LISTING_RESPONSE_NAME @"ListWaterLevelSensorStation"
#define WLS_LISTING_TOTAL_COUNT @"TotalWaterLevelSensorStation"


# pragma mark - BASE URLS
#define BASE_URL @"https://pubapps.com.sg:8080/api/v1/"
#define BASE_MODULES_API_URL @"http://52.74.251.44/PUB.MyWater.Api.New/api/Modules"
#define BASE_FEEDBACK_API_URL @"http://52.74.251.44/PUB.MyWater.Api.New/api/Feedback"

//#define IMAGE_BASE_URL @"https://pubapps.com.sg:8080/images/"
#define IMAGE_BASE_URL @"http://52.74.251.44/PUB.MyWater.Api.New/uploads/"


# pragma mark - ABC WATERS
#define ABC_WATERS_LISTING @"ABCWaterSites"

# pragma mark - EVENTS
#define EVENTS_LISTING @"Events"

#endif
