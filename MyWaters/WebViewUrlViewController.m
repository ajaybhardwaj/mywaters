//
//  WebViewUrlViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 13/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import "WebViewUrlViewController.h"

@interface WebViewUrlViewController ()

@end

@implementation WebViewUrlViewController
@synthesize webUrl,headerTitle,isShowingTermsAndConditions,termsConditionsHTML;


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



# pragma mark - UIWebviewDelegate Methods

-  (void)webViewDidStartLoad:(UIWebView *)webView {
    
    // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [loadingIndicator startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [loadingIndicator stopAnimating];
    defaultWebview.contentMode = UIViewContentModeScaleAspectFill;
    defaultWebview.scalesPageToFit = YES;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [loadingIndicator stopAnimating];
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    [defaultWebview loadHTMLString:errorString baseURL:nil];
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = headerTitle;
    self.view.backgroundColor = RGB(247, 247, 247);
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    defaultWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    defaultWebview.delegate = self;
    defaultWebview.backgroundColor = [UIColor clearColor];
    defaultWebview.opaque = NO;
    
    NSURL *nsurl=[NSURL URLWithString:webUrl];
    
    
    if ([CommonFunctions hasConnectivity]) {
        
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadingIndicator.hidesWhenStopped = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingIndicator];
        
        if (isShowingTermsAndConditions) {
            isShowingTermsAndConditions = NO;
            [defaultWebview loadHTMLString:termsConditionsHTML baseURL:nil];
        }
        else {
            defaultWebview.contentMode = UIViewContentModeScaleAspectFill;
            defaultWebview.scalesPageToFit = YES;
            
            NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9A334 Safari/7534.48.3", @"UserAgent", nil];
            [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
            
            NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
            [defaultWebview loadRequest:nsrequest];
        }
        
    }
    else {
        [CommonFunctions showAlertView:nil title:@"No internet connectivity." msg:nil cancel:@"OK" otherButton:nil];
    }
    [self.view addSubview:defaultWebview];
    
    
    UIScrollView *sv = [[defaultWebview subviews] objectAtIndex:0];
    [sv zoomToRect:CGRectMake(0, 0, sv.contentSize.width, sv.contentSize.height+100) animated:YES];
    [sv setZoomScale:50];
    
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:NO];
    [CommonFunctions googleAnalyticsTracking:@"Page: Web View"];
    [appDelegate setShouldRotate:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
