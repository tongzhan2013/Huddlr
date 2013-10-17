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

//Make sure you have these frameworks linked
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@class MapViewController;

@interface MasterViewController ()

@end

@implementation MasterViewController{
    
    /* This instance variable keeps track of the indexes of search results in _dataController.friendList */
    
    NSIndexSet *searchResultIndexes;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _dataController=[[FriendsDataController alloc]init];
    [self.serviceSwitch addTarget:self action:@selector(switchOff:) forControlEvents:UIControlEventValueChanged];
    [self.navigationController.toolbar setBarTintColor:[UIColor lightGrayColor]];
    
    // Additional setup
    
    _friendNames=_dataController.friendNames;
    _friendsWithinFiveHundredFeet=[[NSMutableArray alloc]init];
    _friendsWithinHalfAMile=[[NSMutableArray alloc]init];
    _friendsFarAway=[[NSMutableArray alloc]init];
    
    // Calculate distance using longitude and latitude info and sort friends into sections
    
    for (Friend *friend in _dataController.friendList){
        double distance=acos(cos(RADIANS*(90-myLatitude))*cos(RADIANS*(90-friend.latitude)) +sin(RADIANS*(90-myLatitude)) *sin(RADIANS*(90-friend.latitude)) *cos(RADIANS*(myLongitude-friend.longitude))) *4300;
        
        friend.distance=distance;
        if (distance < 0.1){[_friendsWithinFiveHundredFeet addObject:friend];}
        else if (distance <0.5){[_friendsWithinHalfAMile addObject:friend];}
        else {[_friendsFarAway addObject:friend];}
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];

    /* This part on reverse geocoding is optional. But if it's run correctly, you should be able to see the address of TD College in the output box in Xcode */
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    CLLocation *location=[[CLLocation alloc]initWithLatitude:myLatitude  longitude:myLongitude];
    
    // This block code is borrowed from Apple reference docs
    
    [geocoder reverseGeocodeLocation: location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         NSLog(@"Placemark array: %@",placemark.addressDictionary );
         NSString *locatedaddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         NSLog(@"Currently address is: %@",locatedaddress);
         
     }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /* Need to distinguish between the tableview and the searchResultsTableView. By default they use the same data source, so this method is called by both */
    
    if (tableView==self.searchDisplayController.searchResultsTableView){return 1;}
    else {return 3;}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.searchDisplayController.searchResultsTableView){return [searchResultIndexes count];}
    
    // Here the row numbers depend on distances calculated before
    
    else if (section==0) {return [_friendsWithinFiveHundredFeet count];}
    else if (section==1) {return [_friendsWithinHalfAMile count];}
    else if (section==2) {return [_friendsFarAway count];}
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell"];
    
    // In case there is no reusable cell, create one and give it a reuse identifier
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendCell"];
    }
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    
    
    NSInteger row=indexPath.row;
    NSInteger section=indexPath.section;
    
    // Depending on which tableview calls the method, find the friend to display
    
    Friend* friend;
    if (tableView==self.tableView){
        if (section==0) {friend=[_friendsWithinFiveHundredFeet objectAtIndex:row];}
        else if (section==1) {friend=[_friendsWithinHalfAMile objectAtIndex:row];}
        else if (section==2) {friend=[_friendsFarAway objectAtIndex:row];}
    }
    else {
        // "index" is the one at position "row" in the NSIndexSet
        NSUInteger index = [searchResultIndexes firstIndex];
        for (NSUInteger i = 0; i < row; i++) {
            index = [searchResultIndexes indexGreaterThanIndex:index];
        }
        friend=[_dataController friendAtIndex:index];
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This sets the height of each cell in the table
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // We do not want any cell to be editted
    return NO;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // As before, we need to first check which tableview calls this method
    
    if (tableView==self.tableView){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
        // Create custom view in section header
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, tableView.frame.size.width, 20)];
        [label setFont:[UIFont boldSystemFontOfSize:10]];
        NSString *string;
        if (section==0) {string=@"Within 500 Feet";}
        else if (section==1) {string=@"Within 1/2 Mile";}
        else if (section==2) {string=@"Far Away";}
        [label setText:string];
        [label setTextColor:[UIColor grayColor]];
        [view addSubview:label];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        return view;
    }
    else return nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==self.tableView){
        return 22;
    }
    
    // Without this method the searchDisplayTableView would have a blank header
    else return 0;
}


#pragma mark-configure actions

-(void)switchOff:(id)sender{
    if (![sender isOn]){
        NSString *alertString=[NSString stringWithFormat:@"Your location service is switched off: Turn it on to enable real-time location monitoring"];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message: alertString
                                                    delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        //////////// We need to actually turn the location on and off with this button
        [alert show];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    
    // Again we need to first find the "right" friend that the user selects
    
    Friend *friend;
    if (tableView==self.tableView){
        if (section==0){friend=[_friendsWithinFiveHundredFeet objectAtIndex:row];}
        else if (section==1){friend=[_friendsWithinHalfAMile objectAtIndex:row];}
        else if (section==2){friend=[_friendsFarAway objectAtIndex:row];}
    }
    else {
        NSUInteger index = [searchResultIndexes firstIndex];
        for (NSUInteger i = 0; i < row; i++) {
            index = [searchResultIndexes indexGreaterThanIndex:index];
        }
        friend=[_dataController friendAtIndex:index];
    }
    
    
    if (cell.accessoryType==UITableViewCellAccessoryNone){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        friend.selected=YES;
    }
    else if (cell.accessoryType==UITableViewCellAccessoryCheckmark){
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        friend.selected=NO;
    }
    
    /* Without this, when the user exits the searchDisplayTableView, he won't see the same friend selected on the original tableview. However, this leads to a small lag */
    if (tableView!=self.tableView){
        [self.tableView reloadData];
    }

}


// This is the action from the huddle button
- (IBAction)huddle:(id)sender {
    NSMutableString *names=[[NSMutableString alloc]init];
    NSMutableArray *huddleList=[[NSMutableArray alloc]init];
    [names appendString:@"Would you like to huddle with \n"];
    int count = 0;
    for (int i = 0; i < [_dataController countOfFriends]; i++){
        Friend *friend=[self.dataController friendAtIndex:i];
        if (friend.selected==YES){
            if (count>0){
                [names appendString:@", "];
            }
            count=count+1;
            [names appendString:friend.name];
            [huddleList addObject:friend];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        NSLog(@"Launching the mapView");
        //replace appname with any specific name you want
        [self.tabBarController setSelectedIndex:1];
        //[self performSegueWithIdentifier:@"segue.modal.alert" sender:self];
    }
}

- (IBAction)refresh:(id)sender {
    
    for (int i=0; i<[_dataController countOfFriends]; i++){
        Friend *friend=[_dataController friendAtIndex:i];
        friend.selected=NO;
    }
    
    // The question is: how to scroll to the top of the search bar?
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.tableView reloadData];
}



#pragma mark-configure the search function

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    /* This is a block code that returns the indexes of friend names that contain the search text */
    searchResultIndexes = [_friendNames indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
        NSString *s = (NSString*)obj;
        NSRange range = [s rangeOfString: searchText options:NSCaseInsensitiveSearch];
        return range.location != NSNotFound;
    }];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                               objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    /* Immediately after this method returns YES, cellForRowAtIndexPath is called to display the filtered search results every time the user inputs */
    return YES;
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
