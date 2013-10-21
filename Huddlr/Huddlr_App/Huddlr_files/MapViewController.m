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
    
    double radius;
    if (huddleList==nil) {radius=0.6;}
    else {radius=0;
          for (int i=0; i<[huddleList count]; i++){
              Friend *friend=[huddleList objectAtIndex:i];
              if (radius<friend.distance){
                 radius=friend.distance;
              }
          }
    }
    
    NSUInteger zoomLevel;
    if (radius<0.25){zoomLevel=16;}
    else if (radius<0.5){zoomLevel=15;}
    else if (radius<1){zoomLevel=14;}
    else if (radius<2){zoomLevel=13;}
    else if (radius<3){zoomLevel=12;}
    else if (radius<5){zoomLevel=11;}
    else if (radius<7){zoomLevel=10;}
    else if (radius<15){zoomLevel=9;}
    else if (radius<30){zoomLevel=8;}
    else if (radius<60){zoomLevel=7;}
    else if (radius<120){zoomLevel=6;}
    else if (radius<240){zoomLevel=5;}
    else if (radius<480){zoomLevel=4;}
    else {zoomLevel=1;}
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: latitude longitude: longitude zoom:zoomLevel];
    CGFloat height=[[UIScreen mainScreen] applicationFrame].size.height;
    CGFloat width=[[UIScreen mainScreen] applicationFrame].size.width;
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0,20,width,height-50) camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view=mapView_;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;

    
    // Creates a marker for each friend in the huddleList
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