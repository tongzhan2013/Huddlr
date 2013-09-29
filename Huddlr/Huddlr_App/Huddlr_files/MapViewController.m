//
//  ViewController.m
//  MorseMap
//
//  Created by William Zhao on 6/30/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import "MapViewController.h"


@interface MapViewController (){
}

@end


@implementation MapViewController {
GMSMapView *mapView_;
}

    @synthesize locationManager;

// You don't need to modify the default initWithNibName:bundle: method.

- (void)viewDidLoad {
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    double latitude=locationManager.location.coordinate.latitude;
    double longitude=locationManager.location.coordinate.longitude;
    NSLog(@"%f, %f", latitude,longitude);
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: latitude                                                            longitude: longitude zoom:10];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    
    self.view = mapView_;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;
    
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = mapView_.myLocation.coordinate;
    marker.title = @"William Zhao";
    marker.snippet = @"Swag";
    marker.map = mapView_;
}

- (void)viewDidAppear:(BOOL)animated {
    
}
 

@end