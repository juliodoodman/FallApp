//
//  MasterViewController.h
//  FallApp
//
//  Created by Julio Morera on 5/3/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class FallViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) FallViewController *fallViewController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *fallFetchedResultsController;

- (void)makeNewFallWithXAccel:(NSNumber *)xAccel andYAccel:(NSNumber *)yAccel andZAccel:(NSNumber *)zAccel andTime:(NSDate *)time andNotes:(NSString *)notes andLocation:(NSString *)location inContext:(NSManagedObjectContext *) context;

@end
