//
//  BikeThere_TabsAppDelegate.m
//  BikeThere-Tabs
//
//  Created by Greg Lind on 8/20/10.
//  Copyright Metro 2010. All rights reserved.
//

#import "VeloGuideAppDelegate.h"

@implementation BikeThere_TabsAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize toolbar;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
	[tabBarController.view addSubview:toolbar];
	[window makeKeyAndVisible];
	
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)dealloc {
	[toolbar release];
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

