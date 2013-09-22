//
//  Person.m
//  MorseMap
//
//  Created by William Zhao on 7/16/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize name,object_id,/*timestamp,*/latitude,longitude;

-(id)init
{
    NSLog(@"Error! This method must be called with arguments!");
    exit(1);
}

-(id)initWithName:(NSString *)name1
         objectId:(NSString *)object_id1
        /*timeStamp:(NSString *)timestamp1*/
         latitude:(double)latitude1
        longitude:(double)longitude1
{
    self = [super init];
    
    if (self) {
        self.name = [NSMutableString stringWithString:name1];
        self.object_id = [NSMutableString stringWithString:object_id1];
        /*self.timestamp = [NSMutableString stringWithString:timestamp1];*/
        self.latitude = latitude1;
        self.longitude = longitude1;
    }
    
    return self;

}

@end
