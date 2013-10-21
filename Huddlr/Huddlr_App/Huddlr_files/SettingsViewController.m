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
    self.tableView.delegate=self;
}

- (void)viewWillAppear:(BOOL)animated{
    _dataController=[[UserDataController alloc]init];
    [_usernameLabel setText:_dataController.username];
    [_emailLabel setText:_dataController.email];
    [_mobileLabel setText:_dataController.mobile];
    if ([_dataController.locationService isEqualToString: @"On"]){
        _serviceSwitch.on=YES;
    }
    else {_serviceSwitch.on=NO;}
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
    return 48;
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
    [view setBackgroundColor:[UIColor colorWithRed:159.0/255.0 green:127.0/255.0 blue:223.0/255.0 alpha:1]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (IBAction)doneEditingEmail:(UIStoryboardSegue *)segue{
    EmailViewController *controller=[segue sourceViewController];
    if ([controller.emailInput.text length]>0){
        NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
        [prefs setObject:controller.emailInput.text forKey:@"email"];
        self.dataController.email = controller.emailInput.text;
        [self.tableView reloadData];
    }
}

- (IBAction)doneEditingMobile:(UIStoryboardSegue *)segue{
    MobileViewController *controller=[segue sourceViewController];
    if ([controller.mobileInput.text length]>0){
        NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
        [prefs setObject:controller.mobileInput.text forKey:@"mobile"];
        self.dataController.mobile = controller.mobileInput.text;
        [self.tableView reloadData];
    }
    
}


- (IBAction)switchOff:(id)sender {
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    if (![sender isOn]) {
        NSString *alertString=[NSString stringWithFormat:@"Your location service is switched off. Turn it on to enable real-time location monitoring."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:alertString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [prefs setObject:@"Off" forKey:@"locationService"];
    }
    else {[prefs setObject:@"On" forKey:@"locationService"];}
        
         //need to actually turn the location on and off with this button
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
}


@end
