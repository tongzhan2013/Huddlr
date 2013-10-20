//
//  ViewController.m
//  MorseMap
//
//  Created by William Zhao on 6/30/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import "MapViewController.h"
#import "Friend.h"
#import <QuartzCore/QuartzCore.h>

@implementation MapViewController {
GMSMapView *mapView_;
}

    @synthesize locationManager;
    @synthesize huddleList;

- (void)viewWillAppear:(BOOL)animated{
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
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: latitude longitude: longitude zoom:10];
    CGFloat height=[[UIScreen mainScreen] applicationFrame].size.height;
    CGFloat width=[[UIScreen mainScreen] applicationFrame].size.width;
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0,20,width,height-50) camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view=mapView_;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;
    
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position=CLLocationCoordinate2DMake(latitude,longitude);
    marker.title = @"William Zhao";
    marker.snippet = @"Swag";
    marker.map = mapView_;
    
    // Creates a marker in the center of the map.
    for (int i=0; i<[huddleList count]; i++){
        Friend *friend=[huddleList objectAtIndex:i];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position=CLLocationCoordinate2DMake(friend.latitude, friend.longitude);
        marker.title=friend.name;
        marker.snippet =@"Great!";
        marker.map=mapView_;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
 

@end