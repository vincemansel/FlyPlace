//
//  PhotosTableViewController.h
//  FlyPlace
//
//  Created by Vince Mansel on 11/19/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoDetailViewController.h"

@interface PhotosTableViewController : UITableViewController
{
    NSDictionary *place;
    NSArray *photosAtPlace;
    
    PhotoDetailViewController *photoDetailViewController;
}

@property (retain, nonatomic) NSDictionary *place;
@property (readonly) PhotoDetailViewController *photoDetailViewController;

@end
