//
//  ViewController.h
//  MorseMap
//
//  Created by William Zhao on 6/30/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
//#import "MasterViewController.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) NSMutableArray *huddleList;

@end
