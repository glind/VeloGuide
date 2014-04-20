//
//  FirstViewController.m
//  BikeThere-Tabs
//
//  Created by Greg Lind on 8/20/10.
//  Copyright Metro 2010. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController

@synthesize mapView;
@synthesize locationManager;
@synthesize locateButton;

- (void)viewWillAppear:(BOOL)animated {
	// Setup location manager
	NSLog(@"Starting core location");
	self.locationManager = [[CLLocationManager alloc] init];
	self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
	self.locationManager.delegate = self;
	[self.locationManager startUpdatingLocation];
	self.locateButton.enabled = NO;
}


// Implement viewDidLoad to do additional setup after loading
// view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.mapView.mapViewDelegate = self;
	AGSDynamicMapServiceLayer *dynamicLayer = [[AGSDynamicMapServiceLayer alloc] initWithURL:[NSURL URLWithString:kDynamicMapServiceURL]];
	AGSTiledMapServiceLayer *tiledLayer = [[AGSTiledMapServiceLayer alloc] initWithURL:[NSURL URLWithString:kTiledMapServiceURL]];
	
	[self.mapView addMapLayer:tiledLayer withName:@"Tiled Layer"];
	[self.mapView addMapLayer:dynamicLayer withName:@"Dynamic Layer"];
	
	// Create a graphics layer to display the push pin
	AGSGraphicsLayer *graphicsLayer = [AGSGraphicsLayer graphicsLayer];
	[self.mapView addMapLayer:graphicsLayer withName:@"GraphicsLayer"];
	
	[tiledLayer release];
	[dynamicLayer release];
	
	// Setup location manager
	NSLog(@"Load the View");
	
}

- (IBAction)showLocation:(id)sender {
	NSLog(@"Show Location");
	
	CLLocation *location = self.locationManager.location;
	double lat = location.coordinate.latitude;
	double lon = location.coordinate.longitude;
	NSLog(@"%.3f, %.3f", lat, lon);
	
	double size = 0.05;
	AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:lon - size 
													 ymin:lat - size
													 xmax:lon + size 
													 ymax:lat + size
										 spatialReference:self.mapView.spatialReference];
	[self.mapView zoomToEnvelope:envelope animated:YES];
	
	// Get reference to the graphics layer
	id<AGSLayerView> graphicsLayerView = [self.mapView.mapLayerViews objectForKey:@"GraphicsLayer"];
	AGSGraphicsLayer *graphicsLayer = (AGSGraphicsLayer*)graphicsLayerView.agsLayer;
	
	// Clear graphics
	[graphicsLayer removeAllGraphics];
	
	// Create a marker symbol using the Location.png graphic
	AGSPictureMarkerSymbol *markerSymbol = [AGSPictureMarkerSymbol pictureMarkerSymbolWithImageNamed:@"Location.png"];
	
	// Create a new graphic using the location and marker symbol
	AGSGraphic* graphic = [AGSGraphic graphicWithGeometry:[envelope center]
												   symbol:markerSymbol
											   attributes:nil
											 infoTemplate:nil];
	
	// Add the graphic to the graphics layer
	[graphicsLayer addGraphic:graphic];
}


- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	NSLog(@"Core location has a new position");
	self.locateButton.enabled = YES;
}

- (void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"Core location failed to get position");
	self.locateButton.enabled = NO;
}




- (void)mapViewDidLoad:(AGSMapView *)mapView {
	//create extent to be used as default
	AGSEnvelope *envelope = [AGSEnvelope envelopeWithXmin:-122.698367609889 ymin:45.4708030767242 xmax:-122.558218920704  ymax:45.5464181834474  spatialReference:self.mapView.spatialReference];
	
	//call method to set extent, pass in envelope
	[self.mapView performSelector:@selector(zoomToEnvelope:animated:) 
                       withObject:envelope
                       afterDelay:0.5];
}	


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	NSLog(@"Shutting down core location");
	[self.locationManager stopUpdatingLocation];
	self.locationManager = nil;
}

- (void)dealloc {
	self.mapView = nil;
	[locateButton release];
    [super dealloc];
	
}

@end
