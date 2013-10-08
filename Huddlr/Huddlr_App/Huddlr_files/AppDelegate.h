//
//  AppDelegate.h
//  MorseMap
//
//  Created by William Zhao on 6/30/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

/**
 * This is the the DNS domain name of the endpoint your Token Vending
 * Machine is running.  (For example, if your TVM is running at
 * http://mytvm.elasticbeanstalk.com this parameter should be set to
 * mytvm.elasticbeanstalk.com.)
 */
#define TOKEN_VENDING_MACHINE_URL    @"http://default-environment-ti2kr6z2qm.elasticbeanstalk.com/"

/**
 * This indiciates whether or not the TVM is supports SSL connections.
 */
#define USE_SSL                      NO

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) UIWindow *window;


@end
