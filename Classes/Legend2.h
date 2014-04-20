//
//  Legend2.h
//  BikeThere-Tabs
//
//  Created by Greg Lind on 9/13/10.
//  Copyright 2010 Metro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Legend2;

@interface Legend2 : UIViewController
{
	IBOutlet UIScrollView *scrollView1;	// holds five small images to scroll horizontally
	IBOutlet UIScrollView *scrollView2;	// holds one large image to scroll in both directions
}

@property (nonatomic, retain) UIView *scrollView1;
@property (nonatomic, retain) UIView *scrollView2;

@end