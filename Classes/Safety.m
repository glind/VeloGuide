//
//  Safety.m
//  BikeThere-Tabs
//
//  Created by Greg Lind on 9/14/10.
//  Copyright 2010 Metro. All rights reserved.
//

#import "Safety.h"

@implementation Safety

@synthesize safetyWebView;

- (void)viewDidLoad {
#define BASEURL [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]
	
	// Load Web View
	NSLog(@"Starting Web View");
	
	NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"veloguide-safety_v2" ofType:@"html"];
	
	NSURL *url = [NSURL fileURLWithPath:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[safetyWebView loadRequest:requestObj];
	
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
	[safetyWebView release];
    [super dealloc];
}


@end
