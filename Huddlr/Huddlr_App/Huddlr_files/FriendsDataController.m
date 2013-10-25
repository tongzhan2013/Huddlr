//
//  FriendsDataController.m
//  Demo
//
//  Created by Xiaosheng Mu on 9/24/13.
//  Copyright (c) 2013 Xiaosheng Mu. All rights reserved.
//

#import "FriendsDataController.h"
#import "Friend.h"
#import <Parse/Parse.h>
const double RADIANS=0.0174532925;

@implementation FriendsDataController

-(void) initializeLists {
    _allFriends = [[NSMutableArray alloc] init];
    _friendsWithinFiveHundredFeet =[[NSMutableArray alloc]init];
    _friendsWithinHalfAMile=[[NSMutableArray alloc]init];
    _friendsFarAway=[[NSMutableArray alloc]init];
    _friendNames=[[NSMutableArray alloc] init];
    NSArray *friendIds=[[NSUserDefaults standardUserDefaults]objectForKey:@"friendIds"];
    
    /////////// Initialize friendArray from Parse. How to minimize requests here? Perhaps by only updating those friends who were decently close to the user. 
    
    PFQuery *friendQuery = [PFUser query];
    [friendQuery whereKey:@"fbId" containedIn:friendIds];
    NSArray *friendUsers = [friendQuery findObjects];
    
    for (PFUser *user in friendUsers){
        Friend *myFriend=[[Friend alloc] initWithName:[user objectForKey:@"name"] location:[user objectForKey:@"location"] pictureFilePath:nil latitude:[[user objectForKey:@"latitude"]doubleValue] longitude:[[user objectForKey:@"longitude"]doubleValue] selected:NO];
        myFriend.pictureURL=[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=100&height=100&return_ssl_resources=1", [user objectForKey:@"fbId"]]];
        [_allFriends addObject:myFriend];
        [_friendNames addObject:[myFriend.name mutableCopy]];
    }

    
    // Initialize friendArray from staticfrienddata.txt
    NSString *fileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"staticfrienddata" ofType: @"txt"] encoding:NSUTF8StringEncoding error:NULL];
   
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    for(NSString *line in lines){
        NSArray *values = [[NSArray alloc] init];
        values = [line componentsSeparatedByString:@","];
        if ([values count]>1){
            Friend *myFriend = [[Friend alloc] initWithName:[values objectAtIndex:0] location: [values objectAtIndex:1] pictureFilePath: [values objectAtIndex:2] latitude:[[values objectAtIndex:3] doubleValue] longitude:[[values objectAtIndex:4] doubleValue] selected: NO];
            [_allFriends addObject:myFriend];
            [_friendNames addObject:[myFriend.name mutableCopy]];
        }
    }
    
    // Sort friends into different distance zones
    PFUser *user=[PFUser currentUser];
    double myLatitude=[[user objectForKey:@"latitude"]doubleValue];
    double myLongitude=[[user objectForKey:@"longitude"]doubleValue];
    for (Friend *friend in _allFriends){
        double distance=acos(cos(RADIANS*(90-myLatitude))*cos(RADIANS*(90-friend.latitude)) +sin(RADIANS*(90-myLatitude)) *sin(RADIANS*(90-friend.latitude)) *cos(RADIANS*(myLongitude-friend.longitude))) * 4300;
        
        friend.distance=distance;
        if (distance < 0.1){[_friendsWithinFiveHundredFeet addObject:friend];}
        else if (distance <0.5){[_friendsWithinHalfAMile addObject:friend];}
        else {[_friendsFarAway addObject:friend];}
    }
}

-(id) init{
    if (self = [super init]){
        ///////
        [self initializeLists];
        return self;
    }
    return nil;
}


@end
