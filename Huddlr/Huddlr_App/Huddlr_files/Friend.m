//
//  Friend.m
//  Demo
//
//  Created by Xiaosheng Mu on 9/24/13.
//  Copyright (c) 2013 Xiaosheng Mu. All rights reserved.
//

#import "Friend.h"

@implementation Friend
-(id)initWithName:(NSString *)name location:(NSString *)location picture:(NSString *)picture selected:(BOOL)selected{
    self=[super init];
    // When you send a message to super, you are sending a message to self, but the search for the method skips the object's class and starts at the superclass. We send the init message to super. This calls NSObject's implementation of init
    // If an initializer message fails, it will return nil. Therefore, it is a good idea to save the return value of the superclass's initializer into the self variable and confirm that it is not nil before doing any further initialization. In Friend.m, edit your designated initializer to confirm the initialization of the superclass. 
    if (self){
        _name = name;
        _location = location;
        _picture = picture;
        _latitude= latitude;
        _longitude= longitude;
        _selected = selected;
        return self;
    }
    else return nil;
}
@end
