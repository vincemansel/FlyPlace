//
//  PhotosTableViewController.h
//  FlyPlace
//
//  Created by Vince Mansel on 11/19/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosTableViewController : UITableViewController
{
    NSDictionary *place;
    NSArray *photosAtPlace;
}

@property (retain, nonatomic) NSDictionary *place;

@end
