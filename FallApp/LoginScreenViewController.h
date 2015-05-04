//
//  LoginScreenViewController.h
//  FallApp
//
//  Created by Julio Morera on 4/22/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface LoginScreenViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSString *currentUserFirstName;
@property (strong, nonatomic) NSString *currentUserLastName;
@property (strong, nonatomic) NSString *currentUserPassword;

@property (strong, nonatomic) NSMutableArray *firstNameArray;
@property (strong, nonatomic) NSMutableArray *lastNameArray;
@property (strong, nonatomic) NSMutableArray *passwordArray;

@property (weak, nonatomic) IBOutlet UIButton *logInButton;

- (IBAction)logInButtonPressed:(UIButton *)sender;

@end
