//
//  AppDelegate.h
//  FallApp
//
//  Created by Julio Morera on 4/20/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *itemFetchedResultsController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)makeNewUserWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName andEmail:(NSString *)email inContext:(NSManagedObjectContext*)context;

- (void)makeNewUserWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName inContext:(NSManagedObjectContext *)context;
- (void)makeNewFallWithXAccel:(NSNumber *)xAccel andYAccel:(NSNumber *)yAccel andZAccel:(NSNumber *)zAccel andTime:(NSDate *)time andNotes:(NSString *)notes inContext:(NSManagedObjectContext *) context;

@end

