//
//  Legal.h
//  VeloGuide
//
//  Created by Greg Lind on 7/4/11.
//  Copyright 2011 Metro. All rights reserved.
//

#import <UIKit/UIKit.h> 


@interface Legal : UIViewController <UISearchBarDelegate>{
	IBOutlet UIWebView *legalWebView;
    IBOutlet UISearchBar *doSearch;
    
}

@property (nonatomic, retain) IBOutlet UIWebView *legalWebView;
@property (nonatomic, retain) IBOutlet UISearchBar *doSearch;

- (NSInteger)highlightAllOccurencesOfString:(NSString*)str;
- (void)removeAllHighlights;


@end
