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
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
