//
//  AppDelegate.m
//  FallApp
//
//  Created by Julio Morera on 4/20/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import "AppDelegate.h"
#import "User.h"
#import "EmergencyContact.h"
#import "Fall.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Fill the Managed Object Context with Objects
    [self.managedObjectContext executeFetchRequest:self.fetchedResultsController.fetchRequest error:nil];
    
    [self.managedObjectContext executeFetchRequest:self.fallFetchedResultsController.fetchRequest error:nil];
    
    if ([self.fetchedResultsController.fetchedObjects count] == 0)
    {
        [self makeNewUserWithFirstName:@"Colin" andLastName:@"Barry" andEmail:@"cpbarry@asu.edu" andPassword:@"password" inContext:self.managedObjectContext];
        [self makeNewUserWithFirstName:@"Julio" andLastName:@"Morera" andEmail:@"jmorera@asu.edu" andPassword:@"password" inContext:self.managedObjectContext];
        [self makeNewUserWithFirstName:@"John" andLastName:@"Doe" andEmail:@"jdoe1@asu.edu" andPassword:@"password" inContext:self.managedObjectContext];
        [self makeNewUserWithFirstName:@"Jane" andLastName:@"Doe" andEmail:@"jdoe2@asu.edu" andPassword:@"password" inContext:self.managedObjectContext];
    }
    
    if ([self.fallFetchedResultsController.fetchedObjects count] == 0)
    {
        [self makeNewFallWithXAccel:0 andYAccel:0 andZAccel:0 andTime:[NSDate date] andNotes:@"Fall" andLocation:@"Here" inContext:self.managedObjectContext];
        [self saveContext];
    }

    // Override point for customization after application launch.
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)makeNewUserWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)email andPassword:(NSString *)password inContext:(NSManagedObjectContext*)context
{
    User *thisUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    [thisUser setFirstName:firstName];
    [thisUser setLastName:lastName];
    [thisUser setEmail:email];
    [thisUser setPassword:password];
    
}
- (void)makeNewEmergencyContactWithtName:(NSString *)name andEmail:(NSString *)email inContext:(NSManagedObjectContext*)context
{
    EmergencyContact *thisEC = [NSEntityDescription insertNewObjectForEntityForName:@"EmergencyContact" inManagedObjectContext:context];
    [thisEC setName:name];
    [thisEC setEmail:email];
    
}

- (void)makeNewFallWithXAccel:(NSNumber *)xAccel andYAccel:(NSNumber *)yAccel andZAccel:(NSNumber *)zAccel andTime:(NSDate *)time andNotes:(NSString *)notes andLocation:(NSString *)location inContext:(NSManagedObjectContext *) context
{
    Fall *thisFall = [NSEntityDescription insertNewObjectForEntityForName:@"Fall" inManagedObjectContext:context];
    [thisFall setXAccel:xAccel];
    [thisFall setYAccel:yAccel];
    [thisFall setZAccel:zAccel];
    [thisFall setTime:time];
    [thisFall setNotes:notes];
    [thisFall setLocation:location];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file. This code uses a directory named "edu.asu.FallApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FallApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FallApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator)
    {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil)
    {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"AppDelegateCache"];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fetchedResultsController;
}

- (NSFetchedResultsController *)fallFetchedResultsController
{
    if (_fallFetchedResultsController != nil)
    {
        return _fallFetchedResultsController;
    }
    
    NSFetchRequest *fallFetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *fallEntity = [NSEntityDescription entityForName:@"Fall" inManagedObjectContext:self.managedObjectContext];
    
    [fallFetchRequest setEntity:fallEntity];
    
    // Set the batch size to a suitable number.
    [fallFetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *fallSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"time" ascending:NO];
    NSArray *fallSortDescriptors = @[fallSortDescriptor];
    
    [fallFetchRequest setSortDescriptors:fallSortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFallFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fallFetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"AppDelegateCache"];
    
    aFallFetchedResultsController.delegate = self;
    
    self.fallFetchedResultsController = aFallFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fallFetchedResultsController performFetch:&error])
    {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _fallFetchedResultsController;
}

#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
