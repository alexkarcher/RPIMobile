//
//  RMAppDelegate.m
//  RPIMobile
//
//  Created by Stephen Silber on 7/24/12.
//  Copyright (c) 2012 Rensselaer Polytechnic Institute. All rights reserved.
//

#import "RMAppDelegate.h"
#import "TestFlight.h"
#import "STDataManager.h"
#import "SideMenuViewController.h"
#import "NewsViewController.h"
#import "MFSideMenu.h"
#import "SDURLCache.h"

#define kTeamToken @"4ed8735f811a3eb6879636f5e313772c_MTQzMTgyMjAxMi0xMC0xNCAyMjo0NToxMy4wNTg3MDE"



@implementation RMAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navigationController = _navigationController;

- (void)prepareCache {
    SDURLCache *cache = [[SDURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                      diskCapacity:20 * 1024 * 1024
                                                          diskPath:[SDURLCache defaultCachePath]];
    cache.minCacheInterval = 0;
    [NSURLCache setSharedURLCache:cache];
    NSLog(@"Cache is being logged to: %@", [SDURLCache defaultCachePath]);
}

- (void) setupShuttleTracker {
    // Override point for customization after application launch.
    STDataManager *dataManager = [[STDataManager alloc] init];
    self.dataManager = dataManager;
    [self.dataManager setParserManagedObjectContext:self.managedObjectContext];
    
    //  dataManager creates a timeDisplayFormatter in its init method, so get
    //  a reference to it.
    self.timeDisplayFormatter = self.dataManager.timeDisplayFormatter;
    
//    etasViewController.dataManager = self.dataManager;
//    etasViewController.managedObjectContext = self.managedObjectContext;
    
    //    UINavigationController *etasTableNavController = [[UINavigationController alloc]
    //                                                      initWithRootViewController:etasViewController];
    
    //  Note that this class (MainViewController) gets a reference to timeDisplayFormatter
    //  via the class creating it.
//    etasViewController.timeDisplayFormatter = self.timeDisplayFormatter;
    
    
    // Check if 12 or 24 hour mode
    BOOL use24Time = NO;
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSMutableArray *dateArray = [[NSMutableArray alloc] init];
    [dateArray setArray:[[timeFormatter stringFromDate:[NSDate date]] componentsSeparatedByString:@" "]];
    
    if ([dateArray count] == 1) // if no am/pm extension exists
        use24Time = YES;
    
    
    //  Create an empty array to use for the favorite ETAs
    NSMutableArray *favoriteEtasArray = [NSMutableArray array];
    
    // Set the application defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *appDefaults;
    appDefaults = @{
    @"use24Time" : @(use24Time),
    @"findClosestStop" : @(YES),
    @"dataUpdateInterval" : @5,
    @"useRelativeTimes" : @(NO),
    @"favoritesList" : [NSKeyedArchiver archivedDataWithRootObject:favoriteEtasArray]
    };
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeDataUpdateRate:)
                                                 name:@"dataUpdateInterval"
                                               object:nil];
    
    float updateInterval = [[defaults objectForKey:@"dataUpdateInterval"] floatValue];
    
    //  Schedule a timer to make the DataManager pull new data every 5 seconds
    self.dataUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:updateInterval
                                                            target:self.dataManager
                                                          selector:@selector(updateData)
                                                          userInfo:nil
                                                           repeats:YES];

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self prepareCache];
    
    //Beta Test Feedback and Information
//    [TestFlight takeOff:kTeamToken];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    NewsViewController *newsView = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
    self.navigationController = [[PrettyNavigationController alloc] initWithRootViewController:newsView];
    
    SideMenuViewController *sideView = [[SideMenuViewController alloc] init];

    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    [MFSideMenuManager configureWithNavigationController:self.navigationController sideMenuController:sideView];

    
    [self setupShuttleTracker];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RPIMobile" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RPIMobile.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
