//
//  PasswordViewController.m
//  Huddlr
//
//  Created by Xiaosheng Mu on 10/19/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import "PasswordViewController.h"
#import "SettingsViewController.h"
#import "UserDataController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.oldPasswordInput.delegate=self;
    self.passwordInput.delegate=self;
    self.confirmPasswordInput.delegate=self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

/////////Use KeyChainItem to increase security 

- (IBAction)done:(id)sender {
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    NSString *passwordCheck=[prefs objectForKey:@"password"];
    
    if (![_oldPasswordInput.text isEqualToString:passwordCheck]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Invalid old password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (![_passwordInput.text isEqualToString:_confirmPasswordInput.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Confirmed new password does not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        [prefs setObject:_passwordInput.text forKey:@"password"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
