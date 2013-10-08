//
//  MasterViewController.m
//  Demo
//
//  Created by Xiaosheng Mu on 9/24/13.
//  Copyright (c) 2013 Xiaosheng Mu. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "FriendsDataController.h"
#import "Friend.h"
#import <QuartzCore/QuartzCore.h>

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    _dataController=[[FriendsDataController alloc]init];
    [self.serviceSwitch addTarget:self action:@selector(switchOff:) forControlEvents:UIControlEventValueChanged];
    [self.navigationController.toolbar setBarTintColor:[UIColor lightGrayColor]];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {return 8;}
    else if (section==1) {return 7;}
    else if (section==2) {return 7;}
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    NSInteger row=indexPath.row;
    NSInteger section=indexPath.section;
    if (section==1) {row=row+8;}
    else if (section==2) {row=row+15;}
    Friend *friend=[self.dataController friendAtIndex: row];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init]; // or your custom initialization
    }
    
    
    // This step means that when you are reusing the cell, you update the checkmark situation according to this new friend that you're looking at.
    
    if (friend.selected==YES){cell.accessoryType=UITableViewCellAccessoryCheckmark;}
    else {cell.accessoryType=UITableViewCellAccessoryNone;}
    
    
    UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(16, 8, 44, 44)];
    imgView.backgroundColor=[UIColor clearColor];
    [imgView setImage:[UIImage imageNamed: friend.picture]];
    
    imgView.layer.shadowColor = [[UIColor blackColor] CGColor];
    imgView.layer.shadowOpacity = 0.5;
    imgView.layer.shadowRadius = 2.0;
    imgView.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
    [cell.contentView addSubview:imgView];
    

    UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(80,10,180,20)];
    nameLabel.text=friend.name;
    [cell.contentView addSubview:nameLabel];
    
    
    UILabel *locationLabel=[[UILabel alloc] initWithFrame:CGRectMake(80,30,180,20)];
    locationLabel.text=friend.location;
    locationLabel.textColor=[UIColor lightGrayColor];
    locationLabel.font=[UIFont fontWithName:nil size:12];
    [cell.contentView addSubview:locationLabel];
   
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section<3) {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:10]];
    NSString *string;
    if (section==0) {string=@"Within 500 Feet";}
    else if (section==1) {string=@"Far Away";}
    else if (section==2) {string=@"Offline";}
    [label setText:string];
    [label setTextColor:[UIColor grayColor]];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:0.7]]; //your background color...
    return view;
    }
    return nil;
}



-(void)switchOff:(id)sender{
    if (![sender isOn]){
        NSString *alertString=[NSString stringWithFormat:@"Your location service is switched off: Turn it on to enable real-time location monitoring"];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message: alertString
                                                    delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}


/////////configure the huddle feature


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    if (section==1){row=row+8;}
    else if (section==2){row=row+15;}
    
    if (cell.accessoryType==UITableViewCellAccessoryNone){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        Friend *friend=[self.dataController friendAtIndex:row];
        friend.selected=YES;
    }
    else if (cell.accessoryType==UITableViewCellAccessoryCheckmark){
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        Friend *friend=[self.dataController friendAtIndex:row];
        friend.selected=NO;
    }

}


- (IBAction)huddle:(id)sender {
    NSMutableString *names=[[NSMutableString alloc]init];
    [names appendString:@"Would you like to huddle with \n"];
    int count=0;
    for (int i=0; i<22;i++){
        Friend *friend=[self.dataController friendAtIndex:i];
        if (friend.selected==YES){
            if (count>0){
                [names appendString:@", "];
            }
            count=count+1;
            [names appendString:friend.name];
        
        }
    }
    [names appendString:@"? "];
    
    if (count>0){
      UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message: names
                                                delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"YES", nil];
      [alert show];
    }
    else {
      UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Tip" message: @"Before tapping this button to initiate a huddle, please first select at least one friend"
                                                    delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
      [alert show];
    }
}

- (IBAction)refresh:(id)sender {
    _dataController=[[FriendsDataController alloc]init];
    for (int i=0; i<22; i++){
        Friend *friend=[self.dataController friendAtIndex:i];
        friend.selected=NO;
    }
    for (int j=0; j<8; j++){
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:j inSection:0];
        [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    for (int j=0; j<7; j++){
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:j inSection:1];
        [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    for (int j=0; j<7; j++){
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:j inSection:2];
        [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}


/*
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 if ([[segue identifier] isEqualToString:@"showDetail"]) {
 NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
 NSDate *object = _objects[indexPath.row];
 [[segue destinationViewController] setDetailItem:object];
 }
 }
 
 */
@end
