//
//  BookingWebViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 15/5/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "BookingWebViewController.h"

@interface BookingWebViewController ()

@end

@implementation BookingWebViewController


//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
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
    [bookingWebView loadHTMLString:errorString baseURL:nil];
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Booking";
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];

    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    bookingWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    bookingWebView.delegate = self;
    bookingWebView.backgroundColor = [UIColor clearColor];
    bookingWebView.opaque = NO;
    bookingWebView.contentMode = UIViewContentModeScaleAspectFill;
    bookingWebView.scalesPageToFit = YES;
    
    
    [self.view addSubview:bookingWebView];
    
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;
    [appDelegate setShouldRotate:NO];
    
    NSString *bookingUrl;
    
    for (int i=0; i<appDelegate.APP_CONFIG_DATA_ARRAY.count; i++) {
        if ([[[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Code"] isEqualToString:@"BookingURL"]) {
            bookingUrl = [[appDelegate.APP_CONFIG_DATA_ARRAY objectAtIndex:i] objectForKey:@"Value"];
            break;
        }
    }
    
    NSURL *nsurl=[NSURL URLWithString:bookingUrl];
    
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    if ([CommonFunctions hasConnectivity]) {
        
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        loadingIndicator.hidesWhenStopped = YES;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loadingIndicator];
        
        [bookingWebView loadRequest:nsrequest];
    }
    else {
        [CommonFunctions showAlertView:nil title:@"Sorry" msg:@"No internet connectivity." cancel:@"OK" otherButton:nil];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(openDeckMenu:)];
    swipeGesture.numberOfTouchesRequired = 1;
    swipeGesture.direction = (UISwipeGestureRecognizerDirectionRight);
    
    [self.view addGestureRecognizer:swipeGesture];
    
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
