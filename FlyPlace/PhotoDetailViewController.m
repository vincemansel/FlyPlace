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
    imageView = [[UIImageView alloc] initWithImage:image];
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:applicationFrame];
    scrollView.contentSize = image.size;
    [scrollView addSubview:imageView];
    scrollView.bounces = YES;
    scrollView.bouncesZoom = YES;
    scrollView.minimumZoomScale = 0.5;
    scrollView.maximumZoomScale = 5.0;
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

@end
