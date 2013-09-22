//
//  Person.h
//  MorseMap
//
//  Created by William Zhao on 7/16/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    NSMutableString *name;
    NSMutableString *object_id;
    /*NSMutableString *timestamp;*/
    double latitude;
    double longitude;
    
}

// function prototypes
-(id)initWithName:(NSString *)name1
         objectId:(NSString *)object_id1
        /*timeStamp:(NSString *)timestamp1*/
         latitude:(double)latitude1
        longitude:(double)longitude1;

@property (nonatomic,copy) NSMutableString *name;
@property (nonatomic,copy) NSMutableString *object_id;
/*@property (nonatomic,copy) NSMutableString *timestamp;*/
@property (nonatomic,assign) double latitude;
@property (nonatomic,assign) double longitude;


@end
