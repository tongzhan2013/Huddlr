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
#import <AWSRuntime/AWSRuntime.h>
#import <AWSDynamoDB/AWSDynamoDB.h>
#import "User.h"
#import "AmazonKeyChainWrapper.h"
#import "AmazonTVMClient.h"
#import "MasterViewController.h"

@interface MapViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    NSMutableArray *huddleList;
}

@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,copy) NSMutableArray *huddleList;

@end
