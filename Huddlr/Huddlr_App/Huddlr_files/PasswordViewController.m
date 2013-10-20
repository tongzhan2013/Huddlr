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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.oldPasswordInput.delegate=self;
    self.passwordInput.delegate=self;
    self.confirmPasswordInput.delegate=self;
	// Do any additional setup after loading the view.
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

- (IBAction)done:(id)sender {
    if (![_oldPasswordInput.text isEqualToString:_passwordCheck]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Invalid old password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else if (![_passwordInput.text isEqualToString:_confirmPasswordInput.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Confirmed new password does not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        SettingsViewController *controller=(SettingsViewController *)[[self.navigationController viewControllers] objectAtIndex:0];
        controller.dataController.password=self.passwordInput.text;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

@end
