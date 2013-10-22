//
//  FriendsDataController.m
//  Demo
//
//  Created by Xiaosheng Mu on 9/24/13.
//  Copyright (c) 2013 Xiaosheng Mu. All rights reserved.
//

#import "FriendsDataController.h"
#import "Friend.h"



@implementation FriendsDataController
- (void)setFriendList:(NSMutableArray *) newList {
    if (_friendList != newList) {
        _friendList = [newList mutableCopy];
    }
}

///////// It would be very helpful to initialize the friendsWithinFiveHundredFeet and similar arrays directly here
-(void) initializeDefaultList {
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    _friendNames = [[NSMutableArray alloc] init];
    self.friendList=newArray;
    _friendNames=[[NSMutableArray alloc] init];
 
    NSString *fileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"staticfrienddata" ofType: @"txt"] encoding:NSUTF8StringEncoding error:NULL];
   
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    for(NSString *line in lines){
        NSArray *values = [[NSArray alloc] init];
        values = [line componentsSeparatedByString:@","];
        if ([values count]>1){
            Friend *myFriend = [[Friend alloc] initWithName:[values objectAtIndex:0] location: [values objectAtIndex:1] picture: [values objectAtIndex:2] latitude:[[values objectAtIndex:3] doubleValue] longitude:[[values objectAtIndex:4] doubleValue] selected: NO];
            [self addFriend:myFriend];
        
            //the zeroth component in each line of the file is the name
            [_friendNames addObject:[[values objectAtIndex:0] mutableCopy]];
        }
    }
}

-(id) init{
    if (self = [super init]){
        [self initializeDefaultList];
        return self;
    }
    return nil;
}

-(NSUInteger) countOfFriends{
    return [self.friendList count];
}

-(Friend *) friendAtIndex:(NSUInteger)index{
    return [self.friendList objectAtIndex:index];
}

-(void) addFriend:(Friend *)newFriend{
    [self.friendList addObject: newFriend];
}

-(void) removeFriendAtIndex:(NSUInteger)index{
    [self.friendList removeObjectAtIndex:index];
}


@end
