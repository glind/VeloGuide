//
//  Legend.m
//  BikeThere-Tabs
//
//  Created by Greg Lind on 9/8/10.
//  Copyright 2010 Metro. All rights reserved.
//

#import "Legend.h"


@implementation Legend

//@synthesize scrollView, imageView;
@synthesize scrollViewer;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	/*// Load Web View
	NSLog(@"Starting Scroll View");
	
	UIImageView *tempImageView = [[UIImageView alloc] 
								  initWithImage:[UIImage imageNamed:@"legend.png"]];
	self.imageView = tempImageView;
	[tempImageView release];
	
	scrollView.contentSize = CGSizeMake
	(imageView.frame.size.width, imageView.frame.size.height);
	scrollView.maximumZoomScale = 4.0;
	scrollView.minimumZoomScale = 0.75;
	scrollView.clipsToBounds = YES;
	scrollView.delegate = self;
	[scrollView addSubview:imageView];
	 */
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[super dealloc];
	//[imageView release];
	[scrollViewer release];
}
@end
