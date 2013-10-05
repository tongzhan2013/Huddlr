//
//  MasterViewController.h
//  Demo
//
//  Created by Xiaosheng Mu on 9/24/13.
//  Copyright (c) 2013 Xiaosheng Mu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendsDataController;

@interface MasterViewController : UITableViewController <UITableViewDelegate>
@property (strong, nonatomic) FriendsDataController *dataController;
@property (weak, nonatomic) IBOutlet UISwitch *serviceSwitch;
- (IBAction)huddle:(id)sender;
- (IBAction)refresh:(id)sender;

@end
