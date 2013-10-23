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
/*- (void)setFriendList:(NSMutableArray *) newList {
    if (_friendList != newList) {
        _friendList = [newList mutableCopy];
    }
}
*/

///////// It would be very helpful to initialize the friendsWithinFiveHundredFeet and similar arrays directly here

-(void) initializeStaticLists {
    _allFriends = [[NSMutableArray alloc] init];
    _friendsWithinFiveHundredFeet =[[NSMutableArray alloc]init];
    _friendsWithinHalfAMile=[[NSMutableArray alloc]init];
    _friendsFarAway=[[NSMutableArray alloc]init];
    _friendNames=[[NSMutableArray alloc] init];
    
    // Initialize friendArray from staticfrienddata.txt
    NSString *fileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"staticfrienddata" ofType: @"txt"] encoding:NSUTF8StringEncoding error:NULL];
   
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    for(NSString *line in lines){
        NSArray *values = [[NSArray alloc] init];
        values = [line componentsSeparatedByString:@","];
        if ([values count]>1){
            Friend *myFriend = [[Friend alloc] initWithName:[values objectAtIndex:0] location: [values objectAtIndex:1] picture: [values objectAtIndex:2] latitude:[[values objectAtIndex:3] doubleValue] longitude:[[values objectAtIndex:4] doubleValue] selected: NO];
            [_allFriends addObject:myFriend];
        
            // The zeroth component in each line of the file is the name
            [_friendNames addObject:[[values objectAtIndex:0] mutableCopy]];
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
        [self initializeStaticLists];
        return self;
    }
    return nil;
}

-(void) initializeFriendListsWithUserId:(NSString *)objectId{
    ////////// Use this method to implement dynamic data
}

@end
