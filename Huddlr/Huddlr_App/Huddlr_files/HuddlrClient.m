//
//  HuddlrClient.m
//  MorseMap
//
//  Created by William Zhao on 9/1/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import "HuddlrClient.h"
#import <AWSRuntime/AWSRuntime.h>
#import <AWSDynamoDB/AWSDynamoDB.h>
#import "RegisterDeviceRequest.h"
#import "GetTokenRequest.h"
#import "AmazonKeyChainWrapper.h"


@implementation HuddlrClient

/*
-(id)initWithEndpoint:(NSString *)endpoint useSSL:(bool)useSSL
{
    self = [super initWithEndpoint:endpoint useSSL:useSSL];
    
    if (self) {
        RegisterDeviceRequest *request = [[RegisterDeviceRequest alloc] initWithEndpoint:self.endpoint
                                                                                   andUid:@"AKIAIDWRKQCV3QXWD4BQ"
                                                                                   andKey:@"HN+nY0y/9YWpzOOfbYmel15XmA1qYuPzXWVEqZYA"
                                                                                 usingSSL:self.useSSL];
        ResponseHandler *handler = [[ResponseHandler alloc] init];
        
        Response *response = [self processRequest:request responseHandler:handler];
        if ( [response wasSuccessful]) {
            [AmazonKeyChainWrapper registerDeviceId:@"AKIAIDWRKQCV3QXWD4BQ" andKey:@"HN+nY0y/9YWpzOOfbYmel15XmA1qYuPzXWVEqZYA"];
            
            NSLog(@"Amazon response was successful");
        }
        else{
            NSLog(@"Error! Amazon response was not successful");
        }
    }
    
    return self;
    
    
}
 */

-(AmazonCredentials *)getCredentials {
    Response *tvmResponse = nil;
    AmazonCredentials *credentials = nil;
    
    AmazonTVMClient *tvm = [[AmazonTVMClient alloc] initWithEndpoint: @"http://default-environment-ti2kr6z2qm.elasticbeanstalk.com/" useSSL: NO];
    tvmResponse = [tvm anonymousRegister];
    if ([tvmResponse wasSuccessful]) {
        tvmResponse = [tvm getToken];
    }
    
    if ([tvmResponse wasSuccessful]) {
        credentials = [AmazonKeyChainWrapper getCredentialsFromKeyChain];
    }
    
    return credentials;
}
    

@end
