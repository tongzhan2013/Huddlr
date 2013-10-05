//
//  FriendsDataController.m
//  Demo
//
//  Created by Xiaosheng Mu on 9/24/13.
//  Copyright (c) 2013 Xiaosheng Mu. All rights reserved.
//

#import "FriendsDataController.h"
#import "Friend.h"



@implementation FriendsDataController
- (void)setFriendList:(NSMutableArray *) newList {
    if (_friendList != newList) {
        _friendList = [newList mutableCopy];
    }
}

-(void) initializeDefaultList {
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    self.friendList=newArray;
    
    
 
    NSString *fileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: @"staticfrienddata" ofType: @"txt"] encoding:NSUTF8StringEncoding error:NULL];
   
    NSArray *lines = [fileContents componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    for(NSString *line in lines){
        NSArray *values = [[NSArray alloc] init];
        values = [line componentsSeparatedByString:@","];
            Friend *myFriend = [[Friend alloc] initWithName:[values objectAtIndex:0] location: [values objectAtIndex:1] picture: [values objectAtIndex:2] selected: NO];
        NSLog(@"%@",myFriend.picture);
            [self addFriend:myFriend];
        
    }
    
    
    

    
    
    /*
    Friend *friend1=[[Friend alloc]initWithName:@"Xiao Wu" location:@"TD College" picture:@"Xiao.png" selected:NO];
    Friend *friend2=[[Friend alloc]initWithName:@"Ivan Fan" location:@"Morse College" picture:@"Ivan.png" selected:NO];
    Friend *friend3=[[Friend alloc]initWithName:@"Tong Zhan" location:@"Morse College" picture:@"Tong.png" selected:NO];
    Friend *friend4=[[Friend alloc]initWithName:@"Will Zhao" location:@"Morse College" picture:@"Will.png" selected:NO];
    Friend *friend5=[[Friend alloc]initWithName:@"Jie Min" location:@"Yale Law School" picture:@"Jie.png" selected:NO];
    Friend *friend6=[[Friend alloc]initWithName:@"Diana Saverin" location:@"484 College Street" picture:@"Diana.png" selected:NO];
    Friend *friend7=[[Friend alloc]initWithName:@"Henry Gottfried" location:@"484 College Street" picture:@"Henry.png" selected:NO];
    Friend *friend8=[[Friend alloc]initWithName:@"Jessica Oddie" location:@"Yale Music School" picture:@"Jessica.png" selected:NO];
    
    
    Friend *friend9=[[Friend alloc]initWithName:@"Sinye Tang" location:@"New York" picture:@"Sinye.png" selected:NO];
    Friend *friend10=[[Friend alloc]initWithName:@"Nicolas Medina Mora" location:@"New York" picture:@"Nicolas.JPG" selected:NO];
    Friend *friend11=[[Friend alloc]initWithName:@"Willa Fitzgerald" location:@"New York" picture:@"Willa.png" selected:NO];
    Friend *friend12=[[Friend alloc]initWithName:@"Orlando Hernandez" location:@"New York" picture:@"Orlando.png" selected:NO];
    Friend *friend13=[[Friend alloc]initWithName:@"Cassius Clay" location:@"New York" picture:@"Cassius.png" selected:NO];
    Friend *friend14=[[Friend alloc]initWithName:@"Natalia Emanuel" location:@"NBER" picture:@"Natalia.JPG" selected:NO];
    Friend *friend15=[[Friend alloc]initWithName:@"Aaron" location:@"Boston" picture:@"Aaron.png" selected:NO];
    
    
    Friend *friend16=[[Friend alloc]initWithName:@"Ben Elder" location:@"Philadelphia" picture:@"Ben.png" selected:NO];
    Friend *friend17=[[Friend alloc]initWithName:@"Josh Penny" location:@"Atlanta" picture:@"Josh.png" selected:NO];
    Friend *friend18=[[Friend alloc]initWithName:@"Christy Nelson" location:@"Stanford University" picture:@"Christy.png" selected:NO];
    Friend *friend19=[[Friend alloc]initWithName:@"Danqing Liu" location:@"San Francisco" picture:@"Danqing.png" selected:NO];
    Friend *friend20=[[Friend alloc]initWithName:@"David Carel" location:@"England" picture:@"David.png" selected:NO];
    Friend *friend21=[[Friend alloc]initWithName:@"Adele Jackson Gibson" location:@"Japan" picture:@"Adele.png" selected:NO];
    Friend *friend22=[[Friend alloc]initWithName:@"Wen Hu" location:@"China" picture:@"Wen.png" selected:NO];
    
    [self addFriend:friend1];
    [self addFriend:friend2];
    [self addFriend:friend3];
    [self addFriend:friend4];
    [self addFriend:friend5];
    [self addFriend:friend6];
    [self addFriend:friend7];
    [self addFriend:friend8];
    [self addFriend:friend9];
    [self addFriend:friend10];
    [self addFriend:friend11];
    [self addFriend:friend12];
    [self addFriend:friend13];
    [self addFriend:friend14];
    [self addFriend:friend15];
    [self addFriend:friend16];
    [self addFriend:friend17];
    [self addFriend:friend18];
    [self addFriend:friend19];
    [self addFriend:friend20];
    [self addFriend:friend21];
    [self addFriend:friend22];

    */
    
    ///////////////// initialize static dataController here
    
    
    
}

-(id) init{
    if (self = [super init]){
        [self initializeDefaultList];
        return self;
    }
    return nil;
}

-(NSUInteger) countOfFriends{
    return [self.friendList count];
}

-(Friend *) friendAtIndex:(NSUInteger)index{
    return [self.friendList objectAtIndex:index];
}

-(void) addFriend:(Friend *)newFriend{
    [self.friendList addObject: newFriend];
}

-(void) removeFriendAtIndex:(NSUInteger)index{
    [self.friendList removeObjectAtIndex:index];
}


@end
