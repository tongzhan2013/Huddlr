//
//  MobileViewController.m
//  Huddlr
//
//  Created by Xiaosheng Mu on 10/19/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import "MobileViewController.h"

@interface MobileViewController ()

@end

@implementation MobileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mobileInput.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
