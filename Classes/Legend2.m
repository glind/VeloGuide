//
//  Legend2.m
//  BikeThere-Tabs
//
//  Created by Greg Lind on 9/13/10.
//  Copyright 2010 Metro. All rights reserved.
//

#import "Legend2.h"


@implementation Legend2

@synthesize scrollView1, scrollView2;

const CGFloat kScrollObjHeight	= 199.0;
const CGFloat kScrollObjWidth	= 280.0;
const NSUInteger kNumImages		= 5;


- (void)layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [scrollView1 subviews];
	
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			
			curXLoc += (kScrollObjWidth);
		}
	}
	
	// set the content size so it can be scrollable
	[scrollView1 setContentSize:CGSizeMake((kNumImages * kScrollObjWidth), [scrollView1 bounds].size.height)];
}

- (void)viewDidLoad
{
	self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	
	// 1. setup the scrollview for multiple images and add it to the view controller
	//
	// note: the following can be done in Interface Builder, but we show this in code for clarity
	[scrollView1 setBackgroundColor:[UIColor blackColor]];
	[scrollView1 setCanCancelContentTouches:NO];
	scrollView1.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView1.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	scrollView1.scrollEnabled = YES;
	
	// pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
	// if you want free-flowing scroll, don't set this property.
	scrollView1.pagingEnabled = YES;
	
	//setup the scrollview for one image and add it to the view controller
	[scrollView2 setBackgroundColor:[UIColor blackColor]];
	[scrollView2 setCanCancelContentTouches:NO];
	scrollView2.clipsToBounds = YES;	// default is NO, we want to restrict drawing within our scrollview
	scrollView2.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"legend.png"]];
	[scrollView2 addSubview:imageView];
	[scrollView2 setContentSize:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)];
	[scrollView2 setScrollEnabled:YES];
	[imageView release];
}

- (void)dealloc
{	
	[scrollView1 release];
	[scrollView2 release];
	
	[super dealloc];
}

- (void)didReceiveMemoryWarning
{
	// invoke super's implementation to do the Right Thing, but also release the input controller since we can do that	
	// In practice this is unlikely to be used in this application, and it would be of little benefit,
	// but the principle is the important thing.
	//
	[super didReceiveMemoryWarning];
}


@end
