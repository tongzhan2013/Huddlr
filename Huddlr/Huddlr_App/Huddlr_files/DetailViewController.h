//
//  DetailViewController.h
//  Demo
//
//  Created by Xiaosheng Mu on 9/24/13.
//  Copyright (c) 2013 Xiaosheng Mu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
