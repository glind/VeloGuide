//
//  about.m
//  BikeThere-Tabs
//
//  Created by Greg Lind on 9/21/10.
//  Copyright 2010 Metro. All rights reserved.
//

#import "About.h"

@implementation About

@synthesize aboutWebView;

- (void)viewDidLoad {
#define BASEURL [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]
	
	// Load Web View
	NSLog(@"Starting Web View");
	
	NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"veloguide-about" ofType:@"html"];
	
	NSURL *url = [NSURL fileURLWithPath:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[aboutWebView loadRequest:requestObj];
	
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
	[aboutWebView release];
    [super dealloc];
}


@end
