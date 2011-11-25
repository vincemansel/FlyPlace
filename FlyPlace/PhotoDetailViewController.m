//
//  PhotoDetailViewController.m
//  FlyPlace
//
//  Created by Vince Mansel on 11/19/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "FlickrFetcher.h"

@interface PhotoDetailViewController()
{
    UIActivityIndicatorView *activityIndicator;
}
@property (retain) UIActivityIndicatorView *activityIndicator;
@end

@implementation PhotoDetailViewController

#define MAX_RECENTLY_VIEWED 25

@synthesize flickrInfo;
@synthesize imageView;
@synthesize activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark -
#pragma mark SplitView Delegation methods

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = aViewController.title;
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
{
    self.navigationItem.rightBarButtonItem = nil;
}

/*
 ------------------------------------------------------------------------
 Private methods used only in this file
 ------------------------------------------------------------------------
 */

#pragma mark -
#pragma mark Private methods


/* show the user that loading activity has started */

- (void) startAnimation
{
    if (!activityIndicator) activityIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    [self.activityIndicator startAnimating];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = YES;
}


/* show the user that loading activity has stopped */

- (void) stopAnimation
{
    [self.activityIndicator stopAnimating];
	UIApplication *application = [UIApplication sharedApplication];
	application.networkActivityIndicatorVisible = NO;
}

#pragma mark - View lifecycle

- (void)storeflickInfoInRecentlyViewedArray:(NSDictionary *)flickrInfoToStore
{
//    NSLog(@"storeflickInfoInRecentlyViewedArray: IN");
    NSMutableArray *recentlyViewedArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"recentlyViewedArray"] mutableCopy];
    if (!recentlyViewedArray) recentlyViewedArray = [[NSMutableArray alloc] init];

//    NSLog(@"storeflickInfoInRecentlyViewedArray: IN = %@", recentlyViewedArray);
    
    NSNumber *keyID = [[flickrInfoToStore objectForKey:@"id"] copy];
//    NSLog(@"storeflickInfoInRecentlyViewedArray: keyID = %@", keyID);
    BOOL keyFound = NO;
    
    for (NSDictionary *storedDictionary in recentlyViewedArray) {
        if ([keyID isEqual:[storedDictionary objectForKey:@"id"]]) {
            keyFound = YES;
            break;
        }
    }
    
    if (!keyFound) {
        if (recentlyViewedArray.count == MAX_RECENTLY_VIEWED) {
            [recentlyViewedArray removeLastObject];
        }
        [recentlyViewedArray insertObject:flickrInfoToStore atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:recentlyViewedArray forKey:@"recentlyViewedArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        NSLog(@"PhotoDetailViewController: storeflickInfoInRecentlyViewedArray: posting Notificaction");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"storeflickInfoInRecentlyViewedArray" object:self];
//        NSLog(@"PhotoDetailViewController: storeflickInfoInRecentlyViewedArray: Notification posted");
    }
    
//    NSLog(@"storeflickInfoInRecentlyViewedArray: OUT = %@", recentlyViewedArray);
//    NSLog(@"storeflickInfoInRecentlyViewedArray: OUT");

    [recentlyViewedArray release];
    [keyID release];
    
}

#define MIN_ZOOM_SCALE 0.1
#define MAX_ZOOM_SCALE 3.0

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{    
//    NSLog(@"PhotoDetailViewController: loadView: IN");
    if (flickrInfo) {
        //    [self startAnimation];
        
        UIImage *image = [UIImage imageWithData:[FlickrFetcher imageDataForPhotoWithFlickrInfo:flickrInfo
                                                                                        format:FlickrFetcherPhotoFormatLarge]];
        //    [self stopAnimation];
        
        CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:applicationFrame];
        
        NSString *statBarOrientation;
        CGFloat scale;
        
        // The iPhone/iPad applicationFrame w and h does not change with interfaceOrientation.
        
        switch ([self interfaceOrientation]) {
            case UIInterfaceOrientationPortrait:
            case UIInterfaceOrientationPortraitUpsideDown:
                statBarOrientation = @"UIInterfaceOrientationPortrait";
                if (image.size.width >= image.size.height) {
                    if (image.size.width > applicationFrame.size.width)
                        scale = applicationFrame.size.width/image.size.width;
                    else
                        scale = image.size.width/applicationFrame.size.width;
                }
                else {
                    if (image.size.height > applicationFrame.size.height)
                        scale = image.size.height/applicationFrame.size.height;
                    else
                        scale = applicationFrame.size.height/image.size.height;
                } 
                break;
            case UIInterfaceOrientationLandscapeLeft:
            case UIInterfaceOrientationLandscapeRight:
                statBarOrientation = @"UIInterfaceOrientationLandscape";
                if (image.size.height >= image.size.width) {
                    if (image.size.height > applicationFrame.size.width)
                        scale = image.size.height/applicationFrame.size.width;
                    else
                        scale = applicationFrame.size.width/image.size.height;
                }
                else {
                    if (image.size.width > applicationFrame.size.height)
                        scale = image.size.width/applicationFrame.size.height;
                    else
                        scale = applicationFrame.size.height/image.size.width;
                }
                break;
                
            default:
                break;
        }
        //    NSLog(@"Orientation      = %@", statBarOrientation);
        //    NSLog(@"Scroll View  w:h = %g:%g", scrollView.bounds.size.width, scrollView.bounds.size.height);
        //    NSLog(@"Application w:h = %g:%g", applicationFrame.size.width, applicationFrame.size.height);
        //    NSLog(@"Image        w:h = %g:%g", image.size.width, image.size.height);
        //    NSLog(@"Scale            = %g", scale);
        [statBarOrientation release];
        
        //imageView = [[UIImageView alloc] initWithImage:image];
        CGRect imageRect = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
        imageView = [[UIImageView alloc] initWithFrame:imageRect];
        imageView.image = image;
        
        scrollView.contentSize = image.size;
        [scrollView addSubview:imageView];
        scrollView.bounces = YES;
        scrollView.bouncesZoom = YES;
        scrollView.minimumZoomScale = MIN_ZOOM_SCALE;
        scrollView.maximumZoomScale = MAX_ZOOM_SCALE;
        scrollView.delegate = self;
        
        [self storeflickInfoInRecentlyViewedArray:self.flickrInfo];
        self.view = scrollView;
    }
    else {
//        NSLog(@"PhotoDetailViewController: loadView: flickrInfo = %@", flickrInfo);
    }
   
//    NSLog(@"PhotoDetailViewController: loadView: OUT");

    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;

}

- (void)dealloc
{
    [flickrInfo release]; //This is a copy. The original info is actually "owned" by the PhotosTableViewController
    [imageView release];
    [activityIndicator release];
    [super dealloc];
}

@end
