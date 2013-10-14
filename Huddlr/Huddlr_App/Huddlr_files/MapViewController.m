//
//  ViewController.m
//  MorseMap
//
//  Created by William Zhao on 6/30/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController {
GMSMapView *mapView_;
}

    @synthesize locationManager;
    @synthesize huddleList;

// You don't need to modify the default initWithNibName:bundle: method.

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create location manager object
    locationManager = [[CLLocationManager alloc] init];
    
    // There will be a warning from this line of code; ignore it for now
    [locationManager setDelegate:self];
    
    // We want all results from the location manager
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    
    // And we want it to be as accurate as possible
    // regardless of how much time/power it takes
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    // Tell our manager to start looking for its location immediately
    [locationManager startUpdatingLocation];
    
    double latitude=locationManager.location.coordinate.latitude;
    double longitude=locationManager.location.coordinate.longitude;
    
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: latitude                                                            longitude: longitude zoom:10];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;
    
    NSLog(@"%f, %f", latitude,longitude);
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position=CLLocationCoordinate2DMake(latitude,longitude);
    marker.title = @"William Zhao";
    marker.snippet = @"Swag";
    marker.map = mapView_;
    
    // Creates a marker in the center of the map.
    for(id friend in huddleList)
    {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position=CLLocationCoordinate2DMake(latitude,longitude);
        marker.title = @"William Zhao";
        marker.snippet = @"Swag";
        marker.map = mapView_;
        NSLog(@"Found a friend: %@",friend);
    }
    
}
 

@end