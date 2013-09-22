//
//  HuddlrClient.h
//  MorseMap
//
//  Created by William Zhao on 9/1/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import "AmazonTVMClient.h"

@interface HuddlrClient : AmazonTVMClient

-(id)initWithEndpoint:(NSString *)endpoint useSSL:(bool)useSSL;

@end
