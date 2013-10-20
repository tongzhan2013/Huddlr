//
//  UserDataController.m
//  Huddlr
//
//  Created by Xiaosheng Mu on 10/19/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import "UserDataController.h"

@implementation UserDataController

-(id) init{
    if (self=[super init]){
        NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
        _username = [prefs stringForKey:@"username"];
        _email = [prefs stringForKey:@"email"];
        _mobile = [prefs stringForKey:@"mobile"];
        _locationService= [prefs stringForKey:@"locationService"];
        return self;
    }
    return nil;
}
@end
