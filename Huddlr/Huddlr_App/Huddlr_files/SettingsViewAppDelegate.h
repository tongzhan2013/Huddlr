//
//  SettingsViewAppDelegate.h
//  SettingsView
//
//  Created by Tong Zhan on 10/5/13.
//  Copyright (c) 2013 Tong Zhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
