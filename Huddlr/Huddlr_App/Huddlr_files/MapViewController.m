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
#import <Parse/Parse.h>
#import "MasterViewController.h"

@implementation MapViewController {
    GMSMapView *mapView_;
}

@synthesize huddleList;


- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    CGRect frame = CGRectMake(0, 0, 320, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:24.0];
    label.textColor = [UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.text = @"Map";
    self.navigationItem.titleView = label;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0;  //user must hold for 1 second
    [self.view addGestureRecognizer:lpgr];
}


- (void)viewWillAppear:(BOOL)animated{
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
    
    // Set zoom level based on radius/maximum distance to any friend in the huddleList
    NSUInteger zoomLevel;
    if (radius<0.25){zoomLevel=15;}else if (radius<0.5){zoomLevel=14;}else if (radius<1){zoomLevel=13;}else if (radius<2){zoomLevel=12;}else if (radius<4){zoomLevel=11;}else if (radius<8){zoomLevel=10;}else if (radius<15){zoomLevel=9;}
    else if (radius<30){zoomLevel=8;}else if (radius<60){zoomLevel=7;}else if (radius<120){zoomLevel=6;}else if (radius<240){zoomLevel=5;} else {zoomLevel=2;}
    
    UINavigationController *navController=[[self.tabBarController viewControllers]objectAtIndex:0];
    MasterViewController *masterController=[[navController viewControllers]objectAtIndex:0];
    double latitude=masterController.myLatitude;
    double longitude=masterController.myLongitude;
    
    // Create the GMS mapview
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


- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded){NSLog(@"Haha");}
    /*CGPoint touchPoint = [gestureRecognizer locationInView:self.view];
    GMSProjection *projection=[[GMSProjection alloc]init];
    CLLocationCoordinate2D touchCoordinate=[projection coordinateForPoint:touchPoint];
    GMSMarker *marker=[[GMSMarker alloc]init];
    marker.position=touchCoordinate;
    marker.title=@"Success!";
    marker.map=mapView_;*/
    
}

 

@end