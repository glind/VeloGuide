//
//  FirstViewController.h
//  BikeThere-Tabs
//
//  Created by Greg Lind on 8/20/10.
//  Copyright Metro 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ArcGIS.h"

#define kTiledMapServiceURL @"http://server.arcgisonline.com/ArcGIS/rest/services/ESRI_StreetMap_World_2D/MapServer"
#define kDynamicMapServiceURL @"http://drc06/ArcGIS/rest/services/bikethere2010/MapServer"

@interface FirstViewController : UIViewController <AGSMapViewDelegate,CLLocationManagerDelegate> {

	AGSMapView *_mapView;
	CLLocationManager *locationManager;
	UIToolbar *toolbar;
	UIBarButtonItem *locateButton;
	
}
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet AGSMapView *mapView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *locateButton;

- (IBAction)showLocation:(id)sender;

@end


