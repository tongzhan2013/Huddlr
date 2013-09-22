//
//  ViewController.m
//  MorseMap
//
//  Created by William Zhao on 6/30/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import "ViewController.h"


@interface ViewController (){
}

@end


@implementation ViewController {
GMSMapView *mapView_;
}

    @synthesize locationManager;

// You don't need to modify the default initWithNibName:bundle: method.

- (void)viewDidLoad {
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    
    [locationManager startUpdatingLocation];
    
    double latitude = locationManager.location.coordinate.latitude;
    double longitude = locationManager.location.coordinate.longitude;
    
    //NSMutableData *receivedData;
    NSString *listOfStrings;
    NSMutableString *theURL = [[NSMutableString alloc] initWithFormat:@"http://69.249.203.161/cgi-bin/location.cgi?lat=%lf&lon=%lf&name=ben",latitude,longitude];
    
    // Create the request for uploading to server.
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:theURL]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    // create the connection with the request
    // and start loading the data
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        // receivedData = [NSMutableData data];
        NSLog(@"Response received");
    } else {
        // Inform the user that the connection failed.
        NSLog(@"No Response received");
    }
    
    // getting data from the server after we updated it
    [theURL setString:@"http://69.249.203.161/cgi-bin/see_users.cgi"];
    NSURL *url2 = [NSURL URLWithString:theURL];
    NSData *data = [NSData dataWithContentsOfURL:url2];
    listOfStrings = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    // NSLog(@"2nd response: %@",listOfStrings);
    
    // regex matching
    // <p> {u'lat': 25.0, u'_id': ObjectId('51dddc90a4a6a3475844ffbe'), u'lon': 40.0, u'name': u'havingfun'}
    
    
    NSLog(@"Regex:");
    NSString *sample = listOfStrings;
    
    NSError *regex_error = nil;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\{(.*)\\}" options:0 error:&regex_error];
    
    NSArray *matches = [regex matchesInString:sample options:0 range:NSMakeRange(0,[sample length])];
    
    NSMutableArray *list_of_people = [[NSMutableArray alloc] init];
    
    NSArray *userInfo = [[NSArray alloc] init];
    NSString *matchText = [[NSString alloc] init];
    NSString *matchTextWithoutBraces = [[NSString alloc] init];
    NSString *userDataPointCurtailed = [[NSString alloc] init];
    NSMutableArray *userInfo2 = [[NSMutableArray alloc] init];

    for (NSTextCheckingResult *match in matches) {
        matchText = [sample substringWithRange:[match range]];
        matchTextWithoutBraces = [matchText substringWithRange:NSMakeRange(1, [matchText length]-2)];
        userInfo = [matchTextWithoutBraces componentsSeparatedByString:@" "];
        for (int i = 1; i < [userInfo count]; i+=2) {
            NSString *userDataPoint = [userInfo objectAtIndex:i];
            userDataPointCurtailed = [userDataPoint substringWithRange:NSMakeRange(0, [userDataPoint length]-1)];
            [userInfo2 addObject:userDataPointCurtailed];
        }
        //something with userInfo2
        NSString *a2 = [userInfo2 objectAtIndex:0];
        double a = [a2 doubleValue];
        NSString *b = [userInfo2 objectAtIndex:1];
        NSString *c2 = [userInfo2 objectAtIndex:2];
        double c = [c2 doubleValue];
        NSString *d = [userInfo2 objectAtIndex:3];
        // NSString *e = [userInfo2 objectAtIndex:4];
        
        // for loop:
        // for each line, make new person
        // example:
        User *rando = [[User alloc] initWithName:d objectId:b /*timeStamp:e*/ latitude:a longitude:c];

        
        // add that person to list_of_people
        [list_of_people addObject:rando];
        
    }
    
    NSLog (@"%@", userInfo2);
    
    NSLog(@"Done");
    
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude: locationManager.location.coordinate.latitude
                                                            longitude: locationManager.location.coordinate.longitude
                                                                 zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;
    
    // Creates a marker in the center of the map.    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake( locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude);
    marker.title = @"William Zhao";
    marker.snippet = @"Swag";
    marker.map = mapView_;
    
    for (int i = 0; i < [userInfo2 count]; i+=4) {
        NSString *a2 = [userInfo2 objectAtIndex:i];
        double a = [a2 doubleValue];
        NSString *b = [userInfo2 objectAtIndex:i+1];
        NSString *c2 = [userInfo2 objectAtIndex:i+2];
        double c = [c2 doubleValue];
        NSString *d = [userInfo2 objectAtIndex:i+3];
        //NSString *e = [userInfo2 objectAtIndex:4];

        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake( a, c);
        marker.title = d;
        marker.snippet = b;
        marker.map = mapView_;
        NSLog(@"%@",marker);
    }
}

@end