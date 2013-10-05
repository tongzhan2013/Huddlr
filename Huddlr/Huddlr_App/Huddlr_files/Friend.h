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
@property (nonatomic, copy) NSString *picture;
@property (nonatomic) BOOL selected;
-(id)initWithName:(NSString *)name location:(NSString *)location picture:(NSString *)picture selected:(BOOL) selected;
@end

