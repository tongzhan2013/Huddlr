//
//  SettingsViewController.h
//  Huddlr
//
//  Created by Xiaosheng Mu on 10/19/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserDataController;

@interface SettingsViewController : UITableViewController <UITableViewDelegate>

@property (nonatomic, strong) UserDataController* dataController;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *mobile;
- (IBAction)switchOff:(id)sender;

@end
