//
//  EmailViewController.m
//  SettingsView
//
//  Created by Tong Zhan on 10/13/13.
//  Copyright (c) 2013 Tong Zhan. All rights reserved.
//

#import "EmailViewController.h"
#import "QuartzCore/QuartzCore.h"

@implementation EmailViewController

- (id)init
{
    CGRect emailTextFieldRect = CGRectMake(self.view.frame.size.width/10, 100, self.view.frame.size.width/1.25,50);
    UITextField *emailTextField = [[UITextField alloc] initWithFrame:emailTextFieldRect];
    [emailTextField setBackgroundColor:[UIColor colorWithRed:0 green:0.75 blue:0.5 alpha:1]];
    [[emailTextField layer] setCornerRadius:10];
    [emailTextField setDelegate:self];
    [self setTextField:emailTextField];
    [[self view] addSubview:emailTextField];
    CGRect emailLabel1Rect = CGRectMake(self.view.frame.size.width/10, 25, self.view.frame.size.width/1.25,50);
    UILabel *emailLabel1 = [[UILabel alloc] initWithFrame:emailLabel1Rect];
    [emailLabel1 setNumberOfLines:0];
    [emailLabel1 setTextAlignment:NSTextAlignmentCenter];
    [emailLabel1 setText:@"Your email address is used for login and password recovery."];
    [[self view] addSubview:emailLabel1];
    CGRect emailLabel2Rect = CGRectMake(self.view.frame.size.width/10, 175, self.view.frame.size.width/1.25,75);
    UILabel *emailLabel2 = [[UILabel alloc] initWithFrame:emailLabel2Rect];
    [emailLabel2 setNumberOfLines:0];
    [emailLabel2 setTextAlignment:NSTextAlignmentCenter];
    [emailLabel2 setText:@"We won't send you any junk mail or expose your information to other users on Huddlr."];
    [[self view] addSubview:emailLabel2];
    [[self navigationItem] setTitle:@"Email"];
    UIBarButtonItem *emailBackBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(popViewControllerAnimated:)];
    UIBarButtonItem *emailDoneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(pushViewController::animated:)];
    [[self navigationItem] setLeftBarButtonItem:emailBackBarButton];
    [[self navigationItem] setRightBarButtonItem:emailDoneBarButton];
    [self setName:@"EmailViewController"];
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == [self textField])
    {
        [textField resignFirstResponder];
        return FALSE;
    }

}

@end
