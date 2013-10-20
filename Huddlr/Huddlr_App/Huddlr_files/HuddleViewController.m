//
//  HuddleViewController.m
//  Huddlr
//
//  Created by Xiaosheng Mu on 10/20/13.
//  Copyright (c) 2013 William Zhao. All rights reserved.
//

#import "HuddleViewController.h"


@interface HuddleViewController () {
    NSMutableArray *huddleHistory;
}

@end

@implementation HuddleViewController

- (void)awakeFromNib{
    [super awakeFromNib];
}


- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    huddleHistory=[[prefs arrayForKey:@"huddleHistory"] mutableCopy];
    [self.tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [huddleHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"HuddleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSString *huddle=[huddleHistory objectAtIndex:indexPath.row];
    NSArray *components = [huddle componentsSeparatedByString: @";"];
    NSString *participants= [components objectAtIndex:0];
    NSString *dateTime= [components objectAtIndex:1];
    
    [cell.textLabel setText:participants];
    [cell.detailTextLabel setText:dateTime];
    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
