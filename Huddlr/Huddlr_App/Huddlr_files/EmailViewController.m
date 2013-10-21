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

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailInput.delegate=self;
    CGRect frame = CGRectMake(0, 0, 320, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textColor = [UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.text = @"Email";
    self.navigationItem.titleView = label;
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
