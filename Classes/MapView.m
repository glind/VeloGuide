//
//  MapView.m
//  VeloGuide
//
//  Created by Greg Lind on 12/15/10.
//  Copyright 2010 NullRecords. All rights reserved.
//

#import "MapView.h"

@implementation MapView;

@synthesize _mapView;
@synthesize locationManager;
@synthesize toolbar;
@synthesize addressField;
@synthesize goButton;
@synthesize locateButton;
@synthesize tweet;
@synthesize parkingButton;
@synthesize bikeMapButton;
@synthesize poi;
@synthesize coordinate;

#define METERS_PER_MILE 1609.344

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    [self.view addSubview:parkingButton];
    [self.view addSubview:bikeMapButton];
    [self.view addSubview:poi];
    
    // initialize the GPS
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
}

-(CLLocationCoordinate2D) addressLocation {
    NSString *urlString = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv", 
						   [addressField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSArray *listItems = [locationString componentsSeparatedByString:@","];
	
    double latitude = 0.0;
    double longitude = 0.0;
	
    if([listItems count] >= 4 && [[listItems objectAtIndex:0] isEqualToString:@"200"]) {
        latitude = [[listItems objectAtIndex:2] doubleValue];
        longitude = [[listItems objectAtIndex:3] doubleValue];
    }
    else {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Address not Found"
                                                            message:@"Sorry that address was not found" delegate:self 
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
	
    return location;
}

- (IBAction) showAddress {
	//Hide the keypad
	[addressField resignFirstResponder];
	MKCoordinateRegion region;
	MKCoordinateSpan span;
    //zoom level
	span.latitudeDelta=0.03;
	span.longitudeDelta=0.03;
	
	CLLocationCoordinate2D thisAddressLocation = [self addressLocation];
	region.span=span;
	region.center=thisAddressLocation;
	[_mapView setRegion:region animated:TRUE];
	[_mapView regionThatFits:region];
    
}

- (IBAction) parkingKml:(id)sender {

    //User pressed bikemap button so show them the bike map for there current location
    CLLocationCoordinate2D mapLocationUser;
    mapLocationUser.latitude = self._mapView.userLocation.location.coordinate.latitude;
    mapLocationUser.longitude = self._mapView.userLocation.location.coordinate.longitude;
    
    //DEBUG
    NSLog(@"%f,%f",mapLocationUser.latitude,mapLocationUser.longitude);
    
    if (mapLocationUser.latitude > 44 && mapLocationUser.latitude < 46 && mapLocationUser.longitude < -121 && mapLocationUser.longitude > -123) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"bike_parking" ofType:@"kml"];
        kml = [[KMLParser parseKMLAtPath:path] retain];
         NSLog(@"PDX PARKING");
    //CHICAGO
    } else if (mapLocationUser.latitude > 41 && mapLocationUser.latitude < 42 && mapLocationUser.longitude < -87 && mapLocationUser.longitude > -88) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Chicago-Bike-Parking" ofType:@"kml"];
            kml = [[KMLParser parseKMLAtPath:path] retain];
            NSLog(@"CHICAGO PARKING");
    //NEW YORK
    } else if (mapLocationUser.latitude > 41 && mapLocationUser.latitude < 42 && mapLocationUser.longitude < -87 && mapLocationUser.longitude > -88) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"NYC-Bike-Parking" ofType:@"kml"];
        kml = [[KMLParser parseKMLAtPath:path] retain];
         NSLog(@"NYC PARKING");
    }
    
    //DEBUG
    NSLog(@"Parking Click");
   
    // Add all of the MKAnnotation objects parsed from the KML file to the map.
    NSArray *annotations = [kml points];
    [_mapView addAnnotations:annotations];

}


#pragma mark MKMapViewDelegate

- (MKOverlayView *) mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
    
    //NSLog(@"overlay called");
    return [kml viewForOverlay:overlay];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    } else if ([annotation isKindOfClass:[Placemark class]]){
    
        // try to dequeue an existing pin view first
        static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
        MKPinAnnotationView* pinView = [[[MKPinAnnotationView alloc]
                                         initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier] autorelease];
        pinView.animatesDrop=YES;
        pinView.canShowCallout=YES;
        pinView.pinColor=MKPinAnnotationColorPurple;
        
        
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton setTitle:annotation.title forState:UIControlStateNormal];
        [rightButton addTarget:self
                        action:@selector(twitter:)
              forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        
        UIImageView *profileIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi.png"]];
        pinView.leftCalloutAccessoryView = profileIconView;
        [profileIconView release];
        
        return pinView;
    }else{
        
        return nil;
    }
    
}


- (IBAction)showLocation:(id)sender {
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = locationManager.location.coordinate.latitude;
    zoomLocation.longitude = locationManager.location.coordinate.longitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];  
    _mapView.showsUserLocation = YES;
    [_mapView setRegion:adjustedRegion animated:YES]; 
    
    }

- (IBAction) bikeMapKml:(id)sender {
        
    //User pressed bikemap button so show them the bike map for there current location
    CLLocationCoordinate2D mapLocationUser;
    mapLocationUser.latitude = self._mapView.userLocation.location.coordinate.latitude;
    mapLocationUser.longitude = self._mapView.userLocation.location.coordinate.longitude;
    
    //DEBUG
    NSLog(@"%f,%f",mapLocationUser.latitude,mapLocationUser.longitude);
    
    NSString *currentCity = @"Portland";
    NSString *currentState = @"Oregon";

    if (mapLocationUser.latitude > 44 && mapLocationUser.latitude < 46 && mapLocationUser.longitude < -121 && mapLocationUser.longitude > -123) {
        //PDX
        currentCity = @"Portland";
        currentState = @"Oregon";
        NSLog(@"PDX BIKE");
       
    } else if (mapLocationUser.latitude > 41 && mapLocationUser.latitude < 42 && mapLocationUser.longitude < -87 && mapLocationUser.longitude > -88) {
        //CHICAGO
        currentCity = @"Chicago";
        currentState = @"Illinois";
        NSLog(@"CHICAGO BIKE");
        
    } else if (mapLocationUser.latitude > 36 && mapLocationUser.latitude < 38 && mapLocationUser.longitude < -121 && mapLocationUser.longitude > -123) {
        //SF
        currentCity = @"SanFrancisco";
        currentState = @"California";

        NSLog(@"SF BIKE");    
    } else if (mapLocationUser.latitude > 40 && mapLocationUser.latitude < 41 && mapLocationUser.longitude < -72 && mapLocationUser.longitude > -73) {
        //NEW YORK
        currentCity = @"NewYork";
        currentState = @"NewYork";
        NSLog(@"NYC BIKE");
    }

    if ([currentCity isEqual:@"Portland"] || [currentState isEqual:@"Oregon"]){
        //PORTLAND
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PDXBIKE3" ofType:@"kml"];
        kml = [[KMLParser parseKMLAtPath:path] retain];
    }else if ([currentCity isEqual:@"NewYork"] || [currentState isEqual:@"NewYork"]){
        //NEW YORK
        NSString *path = [[NSBundle mainBundle] pathForResource:@"NYC-Bike" ofType:@"kml"];
        kml = [[KMLParser parseKMLAtPath:path] retain];
    }else if ([currentCity isEqual:@"Chicago"] || [currentState isEqual:@"Illinois"]){
        //CHICAGO
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Chicago-bikeroutes" ofType:@"kml"];
        kml = [[KMLParser parseKMLAtPath:path] retain];
    }else if ([currentCity isEqual:@"SanFrancisco"] || [currentState isEqual:@"California"]){
        //San Francisco
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SF Bike Routes" ofType:@"kml"];
        kml = [[KMLParser parseKMLAtPath:path] retain];
    }else {
        //PORTLAND
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PDXBIKE3" ofType:@"kml"];
        kml = [[KMLParser parseKMLAtPath:path] retain];
    }
    
    // Add all of the MKOverlay objects parsed from the KML file to the map.
    NSArray *overlays = [kml overlays];
    
    //DEBUG
    //NSLog(@"LOAD: %@",[overlays lastObject]);
    //NSLog(@"%@",[NSString stringWithFormat:@"%d array count", [overlays count]]);
    
    [self._mapView addOverlays:overlays];
    
    // Add all of the MKAnnotation objects parsed from the KML file to the map.
    NSArray *annotations = [kml points];
    [_mapView addAnnotations:annotations];
    
    // Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    if (currentCity){
        MKMapRect flyTo = MKMapRectNull;
        for (id <MKOverlay> overlay in overlays) {
            if (MKMapRectIsNull(flyTo)) {
                flyTo = [overlay boundingMapRect];
            } else {
                flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
            }
        }
        
        for (id <MKAnnotation> annotation in annotations) {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
            if (MKMapRectIsNull(flyTo)) {
                flyTo = pointRect;
            } else {
                flyTo = MKMapRectUnion(flyTo, pointRect);
            }
        }
        
        // Position the map so that all overlays and annotations are visible on screen.
        _mapView.visibleMapRect = flyTo;
    }
    
}

-(IBAction)twitter:(id)sender {
    
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    [twitter setInitialText:@"#VeloGuide"];
    [twitter addImage:[UIImage imageNamed:@"image.png"]];
    
    [self presentViewController:twitter animated:YES completion:nil];
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
        
        if(res == TWTweetComposeViewControllerResultDone) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"The Tweet was posted successfully." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            
            [alert show];    
            
        }
        if(res == TWTweetComposeViewControllerResultCancelled) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cancelled" message:@"You Cancelled posting the Tweet." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            
            [alert show];    
            
        }
        [self dismissModalViewControllerAnimated:YES];
        
    };
    
}

-(IBAction)getLocalTweets:(id)sender {
    
    CLLocationCoordinate2D mapLocationUser;
    mapLocationUser.latitude = locationManager.location.coordinate.latitude;
    mapLocationUser.longitude = locationManager.location.coordinate.longitude;
    
    NSString *latString = [NSString stringWithFormat:@"%f", mapLocationUser.latitude];
    NSString *longString = [NSString stringWithFormat:@"%f", mapLocationUser.longitude];
    
    // Create a request, which in this example, grabs local tweets with VeloGuide hashtag
    NSString *twitterURL1 = @"http://search.twitter.com/search.json?q=VeloGuide&geocode=";
    NSString *twitterURL2 = [twitterURL1 stringByAppendingString:latString];
    NSString *twitterURL3 = [twitterURL2 stringByAppendingString:@","];
    NSString *twitterURL4 = [twitterURL3 stringByAppendingString:longString];
    NSString *twitterURL5 = [twitterURL4 stringByAppendingString:@",10mi"];
    
    NSLog(@"URL: %@", twitterURL5);
    
   // TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"http://search.twitter.com/search.json?&geocode=45.518857,-122.674713,10mi"] parameters:nil requestMethod:TWRequestMethodGET];
    
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:twitterURL5] parameters:nil requestMethod:TWRequestMethodGET];

    
    // Perform the request created above and create a handler block to handle the response.
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        if ([urlResponse statusCode] == 200) 
        {
            // The response from Twitter is in JSON format
            // Move the response into a dictionary and print
            NSError *error;        
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
            //NSLog(@"Twitter response: %@", dict);   
            
            NSMutableArray* annotations=[[NSMutableArray alloc] init];
            
            //Create a status window to display while twitter is downloading
            int *count = 0;
            UIAlertView *alert;
            
           /*
            alert = [[[UIAlertView alloc] initWithTitle:@"Looking for Recent Tweets near you.\nPlease Wait..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil] autorelease];
            [alert show];
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            // Adjust the indicator so it is up a few pixels from the bottom of the alert
            indicator.center = CGPointMake(alert.bounds.size.width / 2, alert.bounds.size.height - 50);
            [indicator startAnimating];
            [alert addSubview:indicator];
            [indicator release];
            */
            //end status window
            
            for (NSDictionary *localTweet in [dict objectForKey:@"results"]) {
               
                NSDictionary *geo = [localTweet objectForKey:@"geo"];
                
                if ([geo isKindOfClass:[NSDictionary class]]){ 
                
                    NSLog(@"Coords: %@", [geo objectForKey:@"coordinates"]);
                    
                    NSArray *latLong = [geo objectForKey:@"coordinates"];
                    
                    NSString *lati = [latLong objectAtIndex:0];
                    NSString *longi = [latLong objectAtIndex:1];
                    
                    CLLocationCoordinate2D c1;
                    // Point one
                    c1.latitude = [lati doubleValue];
                    c1.longitude = [longi doubleValue];
                    
                    Placemark* myAnnotation=[[Placemark alloc] init];
                    
                    myAnnotation.coordinate=c1;
                    //twwtter from_user
                    myAnnotation.title=[localTweet objectForKey:@"from_user"];
                    //twitter text
                    myAnnotation.subtitle=[localTweet objectForKey:@"text"];
 
                    [_mapView addAnnotation:myAnnotation];
                    [annotations addObject:myAnnotation];
                    
                    MKMapRect flyTo = MKMapRectNull;

                    for (id <MKAnnotation> annotation in annotations) {
                        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
                        if (MKMapRectIsNull(flyTo)) {
                            flyTo = pointRect;
                        } else {
                            flyTo = MKMapRectUnion(flyTo, pointRect);
                        }
                    }
                    
                    // Position the map so that all overlays and annotations are visible on screen.
                    _mapView.visibleMapRect = flyTo;
                     
                    count++;
                }
            }
            
            //dismiss status window
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            
            //no tweets were found send message to user
            if (count == 0){
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Points Found" message:@"Sorry, No recent tweets were found in your region.  Try sending your own location tweet using the hashtag #VeloGuide" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
                
                [alert show];  
                
            }
           
            
        } else {
            NSLog(@"Twitter error, HTTP response: %i", [urlResponse statusCode]);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Points Found" message:@"Sorry, No recent tweets were found in your region.  Try sending your own location tweet using the hashtag #VeloGuide" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        
            [alert show];  
        
        }
                
    }];
}



- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [locationManager startUpdatingLocation];
    
}

#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidUnload {
	[super viewDidUnload];
	self._mapView = nil;
	self.toolbar = nil;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [_mapView release];
    [toolbar release];
    [super dealloc];
}	

@end
