//
//  GalleryViewController.m
//  MyWaters
//
//  Created by Ajay Bhardwaj on 10/10/15.
//  Copyright © 2015 iAppsAsia. All rights reserved.
//

#import "GalleryViewController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

@synthesize isABCGallery,isUserGallery,isPOIGallery;
@synthesize galleryImages = galleryImages_;
@synthesize imageHostScrollView = imageHostScrollView_;
@synthesize currentIndex = currentIndex_;


@synthesize prevImgView;
@synthesize centerImgView;
@synthesize nextImgView;

#define safeModulo(x,y) ((y + x % y) % y)


//*************** Method To Pop View Controller To Parent Controller

- (void) pop2Dismiss:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


//*************** Method To Handle Tap Gesture

- (void)handleTap:(UITapGestureRecognizer *) recognizer {
    
    UIScrollView *scrollView = (UIScrollView*)self.centerImgView.superview;
    float scale = scrollView.zoomScale;
    scale += 1.0;
    if(scale > 2.0) scale = 1.0;
    
    [scrollView setZoomScale:scale animated:YES];
}



//*************** Method For Image Loading

-(UIImage *)imageAtIndex:(NSInteger)inImageIndex {
    
    // limit the input to the current number of images, using modulo math
    inImageIndex = safeModulo(inImageIndex, [self totalImages]);
    
    __block UIImage *storedImage = nil;
    
    if (storedImage==nil) {
    NSArray *pathsArray=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
    NSString *destinationPath;// = [doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserProfileUpload"]];
    if (isUserGallery) {
        destinationPath = [doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"ABCUserUploadImages"]];
    }
    else if (isABCGallery) {
        destinationPath = [doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"UserProfileUpload"]];
    }
    else if (isPOIGallery) {
        destinationPath = [doumentDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"POIGallery"]];
    }

    NSString *imageName = [self.galleryImages objectAtIndex:inImageIndex];
    DebugLog(@"Image name %@",imageName);
    DebugLog(@"Image path %@",[destinationPath stringByAppendingPathComponent:imageName]);
    
    NSString *localFile = [destinationPath stringByAppendingPathComponent:imageName];
    
    DebugLog(@"%@",localFile);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:localFile]) {
        if ([[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]] != nil)
            storedImage = [[UIImage alloc] initWithContentsOfFile:[destinationPath stringByAppendingPathComponent:imageName]];
        
        DebugLog(@"Image name %@",[destinationPath stringByAppendingPathComponent:[self.galleryImages objectAtIndex:inImageIndex]]);

    }
    else {
        
        NSString *imageURLString = [NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,imageName];
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center = CGPointMake(self.centerImgView.bounds.size.width/2, self.centerImgView.bounds.size.height/2);
        [self.centerImgView addSubview:activityIndicator];
        [activityIndicator startAnimating];

        
        [CommonFunctions downloadImageWithURL:[NSURL URLWithString:imageURLString] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                
                storedImage = image;
                
                NSFileManager *fileManger=[NSFileManager defaultManager];
                NSError* error;
                
                if (![fileManger fileExistsAtPath:destinationPath]){
                    
                    if([[NSFileManager defaultManager] createDirectoryAtPath:destinationPath withIntermediateDirectories:NO attributes:nil error:&error])
                        ;// success
                    else
                    {
                        DebugLog(@"[%@] ERROR: attempting to write create MyTasks directory", [self class]);
                        NSAssert( FALSE, @"Failed to create directory maybe out of disk space?");
                    }
                }
                
                NSData *data = UIImageJPEGRepresentation(image, 0.8);
                [data writeToFile:[destinationPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]] atomically:YES];
            }
            [activityIndicator stopAnimating];

        }];
    }
    }
    
//    NSString *filePath = [self.galleryImages objectAtIndex:inImageIndex];
//    
//    //Otherwise load from the file path
//    if (nil == image)
//    {
//        NSString *imagePath = filePath;
//        if(imagePath){
//            if([imagePath isAbsolutePath]){
//                image = [UIImage imageWithContentsOfFile:imagePath];
//            }
//            else{
//                image = [UIImage imageNamed:imagePath];
//            }
//            
//            if(nil == image){
//                image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
//                
//            }
//        }
//    }
//    
    
    return storedImage;
}


# pragma mark - Methods For Index

- (NSInteger) totalImages {
    
    return [self.galleryImages count];
}
- (NSInteger)currentIndex {
    
    return safeModulo(currentIndex_, [self totalImages]);
}

- (void)setCurrentIndex:(NSInteger)inIndex {

    currentIndex_ = inIndex;
    
    if([galleryImages_ count] > 0){
//        [self.prevImgView setImage:[self imageAtIndex:[self relativeIndex:-1]]];
        [self.centerImgView setImage:[self imageAtIndex:[self relativeIndex: 0]]];
        [self.nextImgView setImage:[self imageAtIndex:[self relativeIndex: 1]]];
    }
}


- (NSInteger)relativeIndex:(NSInteger)inIndex {

    return safeModulo(([self currentIndex] + inIndex), [self totalImages]);
}

- (void)setRelativeIndex:(NSInteger)inIndex {
    
    [self setCurrentIndex:self.currentIndex + inIndex];
}



# pragma mark - UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;  {
    //incase we are zooming the center image view parent
    if (self.centerImgView.superview == scrollView){
        return self.centerImgView;
    }
    
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    //    CGFloat pageWidth = sender.frame.size.width;
    //    pageNumber_ = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;{
    CGFloat pageWidth = scrollView.frame.size.width;
    previousPage_ = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    //incase we are still in same page, ignore the swipe action
    if(previousPage_ == page) return;
    
    if(sender.contentOffset.x >= sender.frame.size.width) {
        //swipe left, go to next image
        [self setRelativeIndex:1];
        
        // center the scrollview to the center UIImageView
        [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0)  animated:NO];
    }
    else if(sender.contentOffset.x < sender.frame.size.width) {
        //swipe right, go to previous image
        [self setRelativeIndex:-1];
        
        // center the scrollview to the center UIImageView
        [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0)  animated:NO];
    }
    
    UIScrollView *scrollView = (UIScrollView *)self.centerImgView.superview;
    scrollView.zoomScale = 1.0;
}



# pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(242, 242, 242);
    self.title = @"Gallery";
    
    appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [self.navigationItem setLeftBarButtonItem:[[CustomButtons sharedInstance] _PYaddCustomBackButton2Target:self]];
    
    
    self.imageHostScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.imageHostScrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageHostScrollView];
    self.imageHostScrollView.delegate = self;
    
    self.imageHostScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.imageHostScrollView.frame)*3, CGRectGetHeight(self.imageHostScrollView.frame));
    
    CGRect rect = CGRectZero;
    rect.origin.y = -20;
    rect.size = CGSizeMake(CGRectGetWidth(self.imageHostScrollView.frame), CGRectGetHeight(self.imageHostScrollView.frame));

    // add prevView as first in line
    UIImageView *prevView = [[UIImageView alloc] initWithFrame:rect];
    self.prevImgView = prevView;
    
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:rect];
    [self.imageHostScrollView addSubview:scrView];
    
    scrView.delegate = self;
    [scrView addSubview:self.prevImgView];
    scrView.minimumZoomScale = 0.5;
    scrView.maximumZoomScale = 2.5;
    self.prevImgView.frame = scrView.bounds;
    
    // add currentView in the middle (center)
    rect.origin.x += CGRectGetWidth(self.imageHostScrollView.frame);
    UIImageView *currentView = [[UIImageView alloc] initWithFrame:rect];
    self.centerImgView = currentView;
    //    [self.imageHostScrollView addSubview:self.centerImgView];
    
    scrView = [[UIScrollView alloc] initWithFrame:rect];
    scrView.delegate = self;
    scrView.minimumZoomScale = 0.5;
    scrView.maximumZoomScale = 2.5;
    [self.imageHostScrollView addSubview:scrView];
    
    [scrView addSubview:self.centerImgView];
    self.centerImgView.frame = scrView.bounds;
    
    // add nextView as third view
    rect.origin.x += CGRectGetWidth(self.imageHostScrollView.frame);
    UIImageView *nextView = [[UIImageView alloc] initWithFrame:rect];
    self.nextImgView = nextView;
    //    [self.imageHostScrollView addSubview:self.nextImgView];
    
    scrView = [[UIScrollView alloc] initWithFrame:rect];
    [self.imageHostScrollView addSubview:scrView];
    scrView.delegate = self;
    scrView.minimumZoomScale = 0.5;
    scrView.maximumZoomScale = 2.5;
    
    [scrView addSubview:self.nextImgView];
    self.nextImgView.frame = scrView.bounds;
    
    // center the scrollview to show the middle view only
    [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0)  animated:NO];
    self.imageHostScrollView.userInteractionEnabled=YES;
    self.imageHostScrollView.pagingEnabled = YES;
    self.imageHostScrollView.delegate = self;
    
    self.prevImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.centerImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.nextImgView.contentMode = UIViewContentModeScaleAspectFit;
    
//    //some data for testing
//    self.galleryImages = [[NSMutableArray alloc] init];
//    [self.galleryImages insertObject:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"] atIndex:0];
//    [self.galleryImages insertObject:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"png"] atIndex:1];
//    [self.galleryImages insertObject:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"png"] atIndex:2];
//    [self.galleryImages insertObject:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"png"] atIndex:3];
    
    self.currentIndex = 0;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 2;
    recognizer.delegate = self;
    [self.imageHostScrollView addGestureRecognizer:recognizer];
    
    
    DebugLog(@"%@",self.galleryImages);

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
