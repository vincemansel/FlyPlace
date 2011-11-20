//
//  PhotoDetailViewController.m
//  FlyPlace
//
//  Created by Vince Mansel on 11/19/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "FlickrFetcher.h"

@implementation PhotoDetailViewController

@synthesize flickrInfo;
@synthesize imageView;

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

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    UIImage *image = [UIImage imageWithData:[FlickrFetcher imageDataForPhotoWithFlickrInfo:flickrInfo
                                                                                format:FlickrFetcherPhotoFormatLarge]];
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
                    scale = image.size.width/applicationFrame.size.width;
                else
                    scale = applicationFrame.size.width/image.size.width;
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
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 2.0;
    scrollView.delegate = self;
    
    self.view = scrollView;
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
    [super dealloc];
}

@end
