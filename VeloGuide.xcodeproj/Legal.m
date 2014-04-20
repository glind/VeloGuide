//
//  Legend.m
//  BikeThere-Tabs
//
//  Created by Greg Lind on 9/14/10.
//  Copyright 2010 Metro. All rights reserved.
//

#import "Legal.h"

@class WebView;

@implementation Legal;
@synthesize legalWebView;
@synthesize doSearch;

- (void)viewDidLoad {
#define BASEURL [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]
	
	NSString *urlAddress = [[NSBundle mainBundle] pathForResource:@"veloguide-legal" ofType:@"html"];
	
	NSURL *url = [NSURL fileURLWithPath:urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[legalWebView loadRequest:requestObj];
    
}

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str
{
    // The JS File   
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"searchWebView" ofType:@"js" inDirectory:@""];
    NSData *fileData    = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString  = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    [legalWebView stringByEvaluatingJavaScriptFromString:jsString];
    [jsString release];
    
    // The JS Function
    NSString *startSearch   = [NSString stringWithFormat:@"uiWebview_HighlightAllOccurencesOfString('%@')",str];
    [legalWebView stringByEvaluatingJavaScriptFromString:startSearch];
    
    // Search Occurence Count
    // uiWebview_SearchResultCount - is a javascript var
    NSString *result        = [legalWebView stringByEvaluatingJavaScriptFromString:@"uiWebview_SearchResultCount"];
    return [result integerValue];
}

- (void)removeAllHighlights
{
    [legalWebView stringByEvaluatingJavaScriptFromString:@"uiWebview_RemoveAllHighlights()"];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self removeAllHighlights];
    
    int resultCount = [self highlightAllOccurencesOfString:searchBar.text];
    
    // If no occurences of string, show alert message
    if (resultCount <= 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Complete" 
                                                        message:[NSString stringWithFormat:@"No results found for string: %@", searchBar.text]
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Complete" 
                                                        message:[NSString stringWithFormat:@"Results found: Results will be hilighted below"]
                                                       delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    // remove kkeyboard
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)legalPage:(id)sender {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[legalWebView release];
    [super dealloc];
}


@end