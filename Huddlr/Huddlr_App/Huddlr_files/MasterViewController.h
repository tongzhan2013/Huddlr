//
//  MasterViewController.h
//  Demo
//
//  Created by Xiaosheng Mu on 9/24/13.
//  Copyright (c) 2013 Xiaosheng Mu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class FriendsDataController;

// The following declarations are used for calculating static distance as well as for reverse geocoding

@interface MasterViewController : UITableViewController <UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) FriendsDataController *dataController;
@property double myLatitude;
@property double myLongitude;

// This array contains friend names from which to search
@property (nonatomic, copy) NSArray *friendNames;

- (IBAction)huddle:(id)sender;
- (IBAction)refresh:(id)sender;

@end
