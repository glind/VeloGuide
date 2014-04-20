//
//  BikeThere_TabsAppDelegate.h
//  BikeThere-Tabs
//
//  Created by Greg Lind on 8/20/10.
//  Copyright Metro 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MKReverseGeocoder.h>

@interface BikeThere_TabsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	UIToolbar *toolbar;
    UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end