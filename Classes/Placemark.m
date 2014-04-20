//
//  Placemark.m
//  VeloGuide
//
//  Created by Greg Lind on 3/10/12.
//  Copyright (c) 2012 Metro. All rights reserved.
//

#import "Placemark.h"

@implementation Placemark

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize type;


- (void)dealloc
{
    NSLog(@"Placemark called");
    [super dealloc];
    self.title =nil;
    self.subtitle = nil;
    self.type = nil;
}

@end
