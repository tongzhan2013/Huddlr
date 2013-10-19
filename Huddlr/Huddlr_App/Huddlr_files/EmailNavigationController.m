//
//  EmailNavigationController.m
//  SettingsView
//
//  Created by Tong Zhan on 10/14/13.
//  Copyright (c) 2013 Tong Zhan. All rights reserved.
//

#import "EmailNavigationController.h"
#import "SettingsViewController.h"

@implementation EmailNavigationController

- (id)initWithRootViewController:(SettingsViewController *)rootViewController
{
    [super initWithRootViewController:rootViewController];
    [rootViewController setNavigationController:self];
}
- (void)pushViewControllerAnimatedHelper
{

}


@end
