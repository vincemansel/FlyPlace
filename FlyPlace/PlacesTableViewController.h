//
//  PlacesTableViewController.h
//  FlyPlace
//
//  Created by Vince Mansel on 11/19/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosTableViewController.h"

@interface PlacesTableViewController : UITableViewController
{
    NSMutableArray *topPlaces;
    PhotosTableViewController *locationPhotosTVC;
}

@property (readonly) PhotosTableViewController *locationPhotosTVC;
@property (retain) PhotoDetailViewController *detailViewController;

@end
