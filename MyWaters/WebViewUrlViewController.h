//
//  WebViewUrlViewController.h
//  MyWaters
//
//  Created by Ajay Bhardwaj on 13/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface WebViewUrlViewController : UIViewController <UIWebViewDelegate> {
    
    AppDelegate *appDelegate;
    UIWebView *defaultWebview;
}
@property (nonatomic, strong) NSString *webUrl,*headerTitle;

@end
