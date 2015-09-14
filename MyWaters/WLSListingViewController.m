//
//  WLSListingViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 13/7/15.
//  Copyright (c) 2015 iAppsAsia. All rights reserved.
//

#import "WLSListingViewController.h"

@interface WLSListingViewController ()

@end

@implementation WLSListingViewController
@synthesize responseData;

//*************** Method To Open Side Menu

- (void) openDeckMenu:(id) sender {
    
    self.view.alpha = 0.5;
    self.navigationController.navigationBar.alpha = 0.5;
    [[ViewControllerHelper viewControllerHelper] enableDeckView:self];
}



//*************** Method To Get WLS Listing

- (void) loadWLSListing {
    
    NSString *soapMsg = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                         "<soap:Body>\n"
                         "<GetWaterLevelDetails xmlns=\"http://www.pub.gov.sg/\">\n"
                         "<strAuthToken>skmNyEq1fPWGPkNnhlTzzw==</strAuthToken>\n"
                         "</GetWaterLevelDetails>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>"];
    
    NSLog(@"SoapMsg=%@",soapMsg);
    
    NSString *club_url = [NSString stringWithFormat:@"https://app.pub.gov.sg/ShareWaterLevelDetails/WaterLevelDetails.asmx?op=GetWaterLevelDetails"];
    
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:club_url]];
    
    
    NSString *msgLength = [NSString stringWithFormat:@"%ld", [soapMsg length]];
    NSLog(@"Message Length..%@",msgLength);
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest setTimeoutInterval:20];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (theConnection)
    {
        [theConnection cancel];
        theConnection = nil;
    }
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    
//    if( theConnection )
//    {
//        if(responseData)
//        {
//            responseData = nil;
//        }
//    }
//    else
//    {
//        NSLog(@"theConnection is NULL");
//    }
}


# pragma mark - NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
//    NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    
//    responseString = [responseString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
//    responseString = [responseString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
//    
//    DebugLog(@"%@",responseString);
//    
//    NSDictionary *responseDict = [NSDictionary dictionaryWithObject:[responseString dataUsingEncoding:NSUTF8StringEncoding] forKey:@"CCTVS"];
    
    NSError *error = nil;
//    DebugLog(@"%@",responseData);
    NSDictionary *responseDict = [XMLReader dictionaryForXMLData:responseData
                                                 options:XMLReaderOptionsProcessNamespaces
                                                   error:&error];
    
    //method to remove extra node
    NSMutableDictionary *dic_removeKeyNode = [[XMLReader recursionRemoveTextNode:responseDict] mutableCopy];
    
//    NSDictionary *clearXMLDict = [CommonFunctions extractXML:[[responseDict mutableCopy] copy]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic_removeKeyNode
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        DebugLog(@"Got an error: %@", error);
    } else {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        DebugLog(@"%@",jsonString);
    }
}



# pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WaterLevelSensorsDetailViewController *viewObj = [[WaterLevelSensorsDetailViewController alloc] init];
    [self.navigationController pushViewController:viewObj animated:YES];
}


# pragma mark - UITableViewDataSource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return wlsDataSource.count - 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    
    cell.backgroundColor = RGB(247, 247, 247);
    
    UIImageView *cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    //    cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/w%ld.png",appDelegate.RESOURCE_FOLDER_PATH,indexPath.row+1]];
    if (indexPath.row==2 || indexPath.row==4) {
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_below75_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else if (indexPath.row==1) {
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_90_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    else {
        cellImage.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/icn_waterlevel_75-90_big.png",appDelegate.RESOURCE_FOLDER_PATH]];
    }
    [cell.contentView addSubview:cellImage];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, wlsListingtable.bounds.size.width-90, 50)];
    //    titleLabel.text = [[cctvDataSource objectAtIndex:indexPath.row] objectForKey:@"eventTitle"];
    titleLabel.text = [wlsDataSource objectAtIndex:indexPath.row];
    titleLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:14.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.numberOfLines = 0;
    [cell.contentView addSubview:titleLabel];
    
    
    //    UILabel *cellDistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 60, cctvListingTable.bounds.size.width-100, 20)];
    //    cellDistanceLabel.text = @"10 KM";
    //    cellDistanceLabel.font = [UIFont fontWithName:ROBOTO_MEDIUM size:12.0];
    //    cellDistanceLabel.backgroundColor = [UIColor clearColor];
    //    cellDistanceLabel.textColor = [UIColor lightGrayColor];
    //    cellDistanceLabel.numberOfLines = 0;
    //    cellDistanceLabel.textAlignment = NSTextAlignmentLeft;
    //    [cell.contentView addSubview:cellDistanceLabel];
    
    
    UIImageView *seperatorImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 59.5, wlsListingtable.bounds.size.width, 0.5)];
    [seperatorImage setBackgroundColor:[UIColor lightGrayColor]];
    [cell.contentView addSubview:seperatorImage];
    
    
    return cell;
}


# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Water Level Sensor";
    self.view.backgroundColor = RGB(247, 247, 247);
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary *titleBarAttributes = [NSMutableDictionary dictionaryWithDictionary: [[UINavigationBar appearance] titleTextAttributes]];
    [titleBarAttributes setValue:[UIFont fontWithName:ROBOTO_MEDIUM size:19] forKey:NSFontAttributeName];
    [titleBarAttributes setValue:RGB(255, 255, 255) forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setTitleTextAttributes:titleBarAttributes];
    
    
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomRightBarButton2Target:self withSelector:@selector(openDeckMenu:) withIconName:@"icn_menu_white"]];
    
    
    wlsDataSource = [[NSArray alloc] initWithObjects:@"Adam Rd OD (Camden Pk)",@"Alex Canal (Zion Rd)",@"Balmoral Rd",@"Bedok Canal (Jln Greja)",@"Bishan Rd / Bishan St 21",@"Cambridge Rd OD (CTE)",@"Derbyshire Road",@"Eng Neo OD (End Neo Ave)",@"Fort Rd/Katong Pk",@"Grover Dr", nil];
    
    wlsListingtable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    wlsListingtable.delegate = self;
    wlsListingtable.dataSource = self;
    [self.view addSubview:wlsListingtable];
    wlsListingtable.backgroundColor = [UIColor clearColor];
    wlsListingtable.backgroundView = nil;
    wlsListingtable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    responseData = [[NSMutableData alloc] init];
    
    if (appDelegate.WLS_LISTING_ARRAY.count==0) {
        [self loadWLSListing];
    }
}


- (void) viewWillAppear:(BOOL)animated {
    
    self.view.alpha = 1.0;
    self.navigationController.navigationBar.alpha = 1.0;

    UIImage *pinkImg = [AuxilaryUIService imageWithColor:RGB(52,158,240) frame:CGRectMake(0, 0, 1, 1)];
    [[[self navigationController] navigationBar] setBackgroundImage:pinkImg forBarMetrics:UIBarMetricsDefault];
    
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
