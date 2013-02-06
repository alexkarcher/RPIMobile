//
//  RMAppDelegate.h
//  RPIMobile
//
//  Created by Stephen Silber on 7/24/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrettyNavigationController.h"

@class STDataManager;

@interface RMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) PrettyNavigationController *navigationController;

@property (strong, nonatomic) STDataManager *dataManager;
@property (strong, nonatomic) NSDateFormatter *timeDisplayFormatter;
@property (strong, nonatomic) NSTimer *dataUpdateTimer;

@end
