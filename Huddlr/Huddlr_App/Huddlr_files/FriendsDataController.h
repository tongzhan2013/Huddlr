//
//  FriendsDataController.h
//  Demo
//
//  Created by Xiaosheng Mu on 9/24/13.
//  Copyright (c) 2013 Xiaosheng Mu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Friend;
extern const double RADIANS;

@interface FriendsDataController : NSObject
@property (nonatomic, copy) NSMutableArray *allFriends;
@property (nonatomic, copy) NSMutableArray *friendsWithinFiveHundredFeet;
@property (nonatomic, copy) NSMutableArray *friendsWithinHalfAMile;
@property (nonatomic, copy) NSMutableArray *friendsFarAway;

- (void) initializeStaticLists;

// Implement this to retrieve actual server data;
- (void) initializeFriendListsWithUserId: (NSString *)objectId;

// This is an array of friend names that will be used in searching
@property (nonatomic, copy) NSMutableArray *friendNames;
@end

