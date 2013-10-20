//
//  EmailViewController.m
//  Huddlr
//
//  Created by Xiaosheng Mu on 10/19/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import "EmailViewController.h"

@interface EmailViewController ()

@end

@implementation EmailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailInput.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
