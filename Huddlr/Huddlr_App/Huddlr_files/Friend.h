//
//  Friend.h
//  Demo
//
//  Created by Xiaosheng Mu on 9/24/13.
//  Copyright (c) 2013 Xiaosheng Mu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *location;
@property (nonatomic, copy) NSString *pictureFilePath;
@property (nonatomic, copy) NSURL *pictureURL;
@property (nonatomic) UIImage *profilePicture;

@property double latitude;
@property double longitude;
@property double distance;
@property (nonatomic) BOOL selected;
-(id)initWithName:(NSString *)name location:(NSString *)location pictureFilePath:(NSString *)path latitude:(double)latitude longitude:(double)longitude  selected:(BOOL) selected;
@end

