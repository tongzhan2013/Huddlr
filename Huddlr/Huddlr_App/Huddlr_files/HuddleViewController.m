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


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate=self;
    CGRect frame = CGRectMake(0, 0, 320, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:24.0];
    label.textColor = [UIColor blackColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.text = @"Huddles";
    self.navigationItem.titleView = label;
}


- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *prefs=[NSUserDefaults standardUserDefaults];
    huddleHistory=[[prefs arrayForKey:@"huddleHistory"] mutableCopy];
    [self.tableView reloadData];
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
    
    NSString *dateTime= [components objectAtIndex:1];
    [cell.detailTextLabel setText:dateTime];
    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
    
    NSString *namesString= [components objectAtIndex:0];
    NSArray *participants=[namesString componentsSeparatedByString:@","];
    NSMutableString *displayText;
    displayText=[[participants objectAtIndex:0] mutableCopy];
    if ([participants count]>1){
        displayText=[[participants objectAtIndex:0] mutableCopy];
        NSString *str=[NSString stringWithFormat:@" and %d other",[participants count]-1];
        [displayText appendString:str];
        if ([participants count]>2) {[displayText appendString:@"s"];}
    }
    
    [cell.textLabel setText:displayText];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
}
*/


@end
