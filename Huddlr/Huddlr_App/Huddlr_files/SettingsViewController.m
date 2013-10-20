//
//  SettingsViewController.m
//  Huddlr
//
//  Created by Xiaosheng Mu on 10/19/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import "SettingsViewController.h"

#import "UserDataController.h"

#import "EmailViewController.h"

#import "MobileViewController.h"

#import "PasswordViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)awakeFromNib{
    [super awakeFromNib];
    _dataController=[[UserDataController alloc]init];
}

- (void)viewWillAppear:(BOOL)animated{
    [_username setText:_dataController.username];
    [_email setText:_dataController.email];
    [_mobile setText:_dataController.mobile];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 2, tableView.frame.size.width,26)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    NSString *string;
    if (section==0) {string=@"My Account";}
    else if (section==1) {string=@"Location Service";}
    else if (section==2) {string=@"More Information";}
    [label setText:string];
    [label setTextColor:[UIColor whiteColor]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    return view;
}

- (IBAction)doneEditingEmail:(UIStoryboardSegue *)segue{
    EmailViewController *controller=[segue sourceViewController];
    if ([controller.emailInput.text length]>0){
        self.dataController.email = controller.emailInput.text;
        [self.tableView reloadData];
    }
}

- (IBAction)doneEditingMobile:(UIStoryboardSegue *)segue{
    MobileViewController *controller=[segue sourceViewController];
    if ([controller.mobileInput.text length]>0){
        self.dataController.mobile = controller.mobileInput.text;
        [self.tableView reloadData];
    }
    
}

- (IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString: @"passwordSegue"]){
        PasswordViewController *controller=[segue destinationViewController];
        controller.passwordCheck=self.dataController.password;
    }
}



- (IBAction)switchOff:(id)sender {
    if (![sender isOn]) {
        NSString *alertString=[NSString stringWithFormat:@"Your location service is switched off. Turn it on to enable real-time location monitoring."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        //need to actually turn the location on and off with this button
        [alert show];
    }
}
@end
