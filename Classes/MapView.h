//
//  MapView.h
//  VeloGuide
//
//  Created by Greg Lind on 8/20/10.
//  Copyright Metro 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyTabBarController.h"//;
#import <MapKit/MapKit.h> 
#import "KMLParser.h"
#import "Placemark.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>


@interface MapView : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate,MKAnnotation> {

	
	CLLocationManager *locationManager;
	UIToolbar *toolbar;
	UITextField *addressField;
	UIBarButtonItem *goButton;
	UIBarButtonItem *locateButton;
    UIBarButtonItem *tweet;
    UIButton *parkingButton;
    UIButton *bikeMapButton;
	UIImageView * imageView;
	MKMapView *_mapView;
    KMLParser *kml;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) IBOutlet MKMapView *_mapView;
@property (nonatomic, retain) IBOutlet UITextField *addressField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *goButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *locateButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *tweet;
@property (nonatomic, retain) IBOutlet UIButton *parkingButton;
@property (nonatomic, retain) IBOutlet UIButton *bikeMapButton;
@property (nonatomic, retain) IBOutlet UIButton *poi;

- (IBAction)twitter:(id)sender;
- (IBAction) showAddress;
- (IBAction) showLocation:(id)sender;
- (IBAction) parkingKml:(id)sender;
- (IBAction) bikeMapKml:(id)sender;
- (IBAction) getLocalTweets:(id)sender;
- (CLLocationCoordinate2D) addressLocation;

@end
