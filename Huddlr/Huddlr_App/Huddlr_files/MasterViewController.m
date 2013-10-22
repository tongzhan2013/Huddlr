//
//  MasterViewController.m
//  Demo
//
//  Created by Xiaosheng Mu on 9/24/13.
//  Copyright (c) 2013 Xiaosheng Mu. All rights reserved.
//

#import "MasterViewController.h"
#import "FriendsDataController.h"
#import "Friend.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "MapViewController.h"

const double RADIANS=0.0174532925;

@interface MasterViewController ()

@end

@implementation MasterViewController{
    /* This instance variable keeps track of the indexes of search results in _dataController.friendList */
    NSIndexSet *searchResultIndexes;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Get user location
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager startUpdatingLocation];
    _myLatitude=_locationManager.location.coordinate.latitude;
    _myLongitude=_locationManager.location.coordinate.longitude;
    
    // Update Parse Cloud of the user's latitude and longitude information
    
    PFUser *user=[PFUser currentUser];
    if (_myLatitude !=0 || _myLongitude!=0){
        user[@"latitude"]=@(_myLatitude);
        user[@"longitude"]=@(_myLongitude);
        [user saveInBackground];
    }
    else {
        _myLatitude=[[user objectForKey:@"latitude"]doubleValue];
        _myLongitude=[[user objectForKey:@"longitude"]doubleValue];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 0, 320, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:24.0];
    label.textColor = [UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.text = @"Huddlr";
    self.navigationItem.titleView = label;
    [self.navigationController.toolbar setBarTintColor:[UIColor lightGrayColor]];
    
    // Set UserDefault for first-time users
    
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    if ([prefs stringForKey:@"username"]==nil) {[prefs setObject:@"Xiaosheng Mu" forKey:@"username"];}
    if ([prefs stringForKey:@"password"]==nil) {[prefs setObject:@"yatou1729" forKey:@"password"];}
    if ([prefs stringForKey:@"email"]==nil) {[prefs setObject:@"indefatigablexs@gmail.com" forKey:@"email"];}
    if ([prefs stringForKey:@"mobile"]==nil) {[prefs setObject:@"203-909-2814" forKey:@"mobile"];}
    if ([prefs stringForKey:@"locationService"]==nil) {[prefs setObject:@"On" forKey:@"locationService"];}
    
    // Setup the model layer when the view loads for the first time
    
    _dataController=[[FriendsDataController alloc]init];
    _friendNames=_dataController.friendNames;
    _friendsWithinFiveHundredFeet=[[NSMutableArray alloc]init];
    _friendsWithinHalfAMile=[[NSMutableArray alloc]init];
    _friendsFarAway=[[NSMutableArray alloc]init];
    
    // Calculate distance using longitude and latitude info and sort friends into sections
    
    for (Friend *friend in _dataController.friendList){
        double distance=acos(cos(RADIANS*(90-_myLatitude))*cos(RADIANS*(90-friend.latitude)) +sin(RADIANS*(90-_myLatitude)) *sin(RADIANS*(90-friend.latitude)) *cos(RADIANS*(_myLongitude-friend.longitude))) *4500;
        
        friend.distance=distance;
        if (distance < 0.1){[_friendsWithinFiveHundredFeet addObject:friend];}
        else if (distance <0.5){[_friendsWithinHalfAMile addObject:friend];}
        else {[_friendsFarAway addObject:friend];}
    }
}


- (void)viewWillAppear:(BOOL)animated{
    
    /////// Reverse geocoding example
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    CLLocation *location=[[CLLocation alloc]initWithLatitude:_myLatitude  longitude:_myLongitude];
    
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
}




#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /* Need to distinguish between the tableview and the searchResultsTableView. By default they use the same data source, so this method is called by both */
    
    if (tableView==self.searchDisplayController.searchResultsTableView){return 1;}
    else return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.searchDisplayController.searchResultsTableView){return [searchResultIndexes count];}
    
    // Here the row numbers depend on distances calculated before
    else if (section==0) {if ([_friendsWithinFiveHundredFeet count]>0) return [_friendsWithinFiveHundredFeet count]; else return 1;}
    else if (section==1) {if ([_friendsWithinHalfAMile count]>0) return [_friendsWithinHalfAMile count]; else return 1;}
    else if (section==2) {if ([_friendsFarAway count]>0) return [_friendsFarAway count]; else return 1;}
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
        if (section==0) {if ([_friendsWithinFiveHundredFeet count]>0) friend=[_friendsWithinFiveHundredFeet objectAtIndex:row];}
        else if (section==1) {if ([_friendsWithinHalfAMile count]>0) friend=[_friendsWithinHalfAMile objectAtIndex:row];}
        else if (section==2) {if ([_friendsFarAway count]>0) friend=[_friendsFarAway objectAtIndex:row];}
    }
    else {
        // "Index" is the one at position "row" in the NSIndexSet
        NSUInteger index = [searchResultIndexes firstIndex];
        for (NSUInteger i = 0; i < row; i++) {
            index = [searchResultIndexes indexGreaterThanIndex:index];
        }
        friend=[_dataController friendAtIndex:index];
    }


    // This step means that when you are reusing the cell, you update the checkmark situation according to this new friend that you're looking at.
    if (friend){
       if (friend.selected==YES){cell.accessoryType=UITableViewCellAccessoryCheckmark;}
       else {cell.accessoryType=UITableViewCellAccessoryNone;}
       
       // Configure the appearance of the cell
       UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(16, 11, 44, 44)];
       imgView.backgroundColor=[UIColor clearColor];
       [imgView setImage:[UIImage imageNamed: friend.picture]];
    
       imgView.layer.shadowColor = [[UIColor blackColor] CGColor];
       imgView.layer.shadowOpacity = 0.5;
       imgView.layer.shadowRadius = 2.0;
       imgView.layer.shadowOffset = CGSizeMake(1.5f, 1.5f);
       [cell.contentView addSubview:imgView];
    
       UILabel *nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(80,14,180,20)];
       nameLabel.text=friend.name;
       [cell.contentView addSubview:nameLabel];
    
       UILabel *locationLabel=[[UILabel alloc] initWithFrame:CGRectMake(80,36,180,20)];
       locationLabel.text=friend.location;
       locationLabel.textColor=[UIColor lightGrayColor];
       locationLabel.font=[UIFont fontWithName:nil size:12];
       [cell.contentView addSubview:locationLabel];
    }
    else {
        UILabel *alertLabel=[[UILabel alloc] initWithFrame:CGRectMake(20,22,280,20)];
        alertLabel.text=@"None of your friends in this distance zone";
        alertLabel.textAlignment=NSTextAlignmentCenter;
        alertLabel.textColor=[UIColor lightGrayColor];
        alertLabel.font=[UIFont fontWithName:nil size:15];
        [cell.contentView addSubview:alertLabel];
    }
        
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This sets the height of each cell in the table
    return 66;
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.frame.size.width, 26)];
        [label setFont:[UIFont boldSystemFontOfSize:14]];
        NSString *string;
        if (section==0) {string=@"Within 500 Feet";}
        else if (section==1) {string=@"Within 1/2 Mile";}
        else if (section==2) {string=@"Far Away";}
        [label setText:string];
        [label setTextColor:[UIColor whiteColor]];
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithRed:60.0/255.0 green:179.0/255.0 blue:113.0/255.0 alpha:0.7]];
        return view;
    }
    else return nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==self.tableView){
        return 30;
    }
    
    // Without this method the searchDisplayTableView would have a blank header
    else return 0;
}




#pragma mark-configure actions

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    
    // Again we need to first find the "right" friend that the user selects
    
    Friend *friend;
    if (tableView==self.tableView){
        if (section==0){if ([_friendsWithinFiveHundredFeet count]>0) friend=[_friendsWithinFiveHundredFeet objectAtIndex:row];}
        else if (section==1){if ([_friendsWithinHalfAMile count]>0) friend=[_friendsWithinHalfAMile objectAtIndex:row];}
        else if (section==2){if ([_friendsFarAway count]>0) friend=[_friendsFarAway objectAtIndex:row];}
    }
    else {
        NSUInteger index = [searchResultIndexes firstIndex];
        for (NSUInteger i = 0; i < row; i++) {
            index = [searchResultIndexes indexGreaterThanIndex:index];
        }
        friend=[_dataController friendAtIndex:index];
    }
    
    if (friend){
      if (cell.accessoryType==UITableViewCellAccessoryNone){
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        friend.selected=YES;
      }
      else if (cell.accessoryType==UITableViewCellAccessoryCheckmark){
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        friend.selected=NO;
      }
    }
    /* Without this, when the user exits the searchDisplayTableView, he won't see the same friend selected on the original tableview. However, this leads to a small lag */
    if (tableView!=self.tableView){
        [self.tableView reloadData];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
}


// This is the action from the huddle button
- (IBAction)huddle:(id)sener {
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
        UINavigationController *navController=[self.tabBarController.viewControllers objectAtIndex:1];
        MapViewController *mapController=[navController.viewControllers objectAtIndex:0];
        mapController.huddleList=[[NSMutableArray alloc]init];
        NSMutableString *huddle=[[NSMutableString alloc]init];
        
        // Instantiate the huddleList in the MapViewController and save the huddle to NSUserDefaults
        
        for (int i=0; i<[_dataController countOfFriends]; i++){
            Friend *friend=[_dataController friendAtIndex:i];
            if (friend.selected==YES){
                [mapController.huddleList addObject:friend];
                [huddle appendString:[friend.name copy]];
                [huddle appendString:@", "];
            }
        }
        
        // Remove the last ","
        huddle = [[huddle substringToIndex:[huddle length]-2]mutableCopy];
        [huddle appendString:@";"];
        
        // Append date and time
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd 'at' HH:mm";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        NSMutableString *dateTime=[[dateFormatter stringFromDate:now] mutableCopy];
        [huddle appendString:dateTime];
        
        NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
        NSMutableArray *huddleHistory=[[prefs arrayForKey:@"huddleHistory"] mutableCopy];
        if (huddleHistory==nil) {huddleHistory=[[NSMutableArray alloc]init];}
        [huddleHistory insertObject:huddle atIndex:0];
        [prefs setObject:huddleHistory forKey:@"huddleHistory"];
        
        //// Lead the user to the map
        [self.tabBarController setSelectedIndex:1];

        
    }
}

- (IBAction)refresh:(id)sender {
    //// Update the model layer
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDelegate:self];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [_locationManager startUpdatingLocation];
    if (_locationManager.location.coordinate.latitude!=0 ||_locationManager.location.coordinate.longitude!=0){
        _myLatitude=_locationManager.location.coordinate.latitude;
        _myLongitude=_locationManager.location.coordinate.longitude;
    }
    
    _dataController=[[FriendsDataController alloc]init];
    _friendsWithinFiveHundredFeet=[[NSMutableArray alloc]init];
    _friendsWithinHalfAMile=[[NSMutableArray alloc]init];
    _friendsFarAway=[[NSMutableArray alloc]init];
    
    for (Friend *friend in _dataController.friendList){
        double distance=acos(cos(RADIANS*(90-_myLatitude))*cos(RADIANS*(90-friend.latitude)) +sin(RADIANS*(90-_myLatitude)) *sin(RADIANS*(90-friend.latitude)) *cos(RADIANS*(_myLongitude-friend.longitude))) *4500;
        
        friend.distance=distance;
        if (distance < 0.1){[_friendsWithinFiveHundredFeet addObject:friend];}
        else if (distance <0.5){[_friendsWithinHalfAMile addObject:friend];}
        else {[_friendsFarAway addObject:friend];}
    }
    
    [self.tableView reloadData];
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

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



@end
