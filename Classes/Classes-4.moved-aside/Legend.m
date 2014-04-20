//
//  Legend.m
//  BikeThere-Tabs
//
//  Created by Greg Lind on 9/10/10.
//  Copyright 2010 Metro. All rights reserved.
//

#import "Legend.h"

@implementation Legend

@synthesize webView;

- (void)viewDidLoad {
#define BASEURL [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]
	
	// Load Web View
	NSLog(@"Starting Web View");
	
	NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"legend" ofType:@"png"];
	
	NSURL *url = [NSURL fileURLWithPath:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webView loadRequest:requestObj];
	
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
	[webView release];
    [super dealloc];
}


@end


@end
