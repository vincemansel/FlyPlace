//
//  PhotoDetailViewController.h
//  FlyPlace
//
//  Created by Vince Mansel on 11/19/11.
//  Copyright (c) 2011 Wave Ocean Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailViewController : UIViewController <UIScrollViewDelegate, UISplitViewControllerDelegate>
{
    NSDictionary *flickrInfo;
    UIImageView *imageView;
}

@property (retain, nonatomic) NSDictionary *flickrInfo;
@property (retain, nonatomic) UIImageView *imageView;

@end
