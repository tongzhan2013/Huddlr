//
//  FriendsDataController.h
//  Demo
//
//  Created by Xiaosheng Mu on 9/24/13.
//  Copyright (c) 2013 Xiaosheng Mu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Friend;

@interface FriendsDataController : NSObject
@property (nonatomic, copy) NSMutableArray *friendList;
-(NSUInteger) countOfFriends;
-(Friend *) friendAtIndex: (NSUInteger) index;
- (void) initializeDefaultList;
-(void) addFriend: (Friend *) newFriend;
-(void) removeFriendAtIndex: (NSUInteger) index;
//this is an array of friend names that will be used in searching
@property (nonatomic, copy) NSMutableArray *friendNames;
@end

