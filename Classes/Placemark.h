//
//  Placemark.h
//  VeloGuide
//
//  Created by Greg Lind on 3/10/12.
//  Copyright (c) 2012 Metro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h> 

@interface Placemark : NSObject<MKAnnotation>{
    CLLocationCoordinate2D  coordinate;
    NSString*               title;
    NSString*               subtitle;
    NSString*               type;
}

@property (nonatomic, assign)   CLLocationCoordinate2D  coordinate;
@property (nonatomic, copy)     NSString*               title;
@property (nonatomic,copy)      NSString*               subtitle;
@property (nonatomic,copy)      NSString*               type;

@end
