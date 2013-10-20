//
//  UserDataController.h
//  Huddlr
//
//  Created by Xiaosheng Mu on 10/19/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataController : NSObject
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *locationService;
////need to add block list
@end