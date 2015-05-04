//
//  SettingsViewController.m
//  FallApp
//
//  Created by Julio Morera on 4/22/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize contactdb;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.contactdb)
    {
        [self.nameTF setText:[self.contactdb valueForKey:@"name"]];
        [self.emailTF setText:[self.contactdb valueForKey:@"email"]];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentUserFirstName = [defaults valueForKey:@"currentUserFirstName"];
    NSString *currentUserLastName = [defaults valueForKey:@"currentUserLastName"];
    
    NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@",
                                @"firstName", currentUserFirstName, @"lastName", currentUserLastName];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    [fetchRequest setPredicate:predicate];
    
    self.userArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self.currentUser = self.userArray[0];
    NSLog([NSString stringWithFormat:@"Welcome, %@ %@!", self.currentUser.firstName, self.currentUser.lastName]);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the contacts from persistent data store
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentUserFirstName = [defaults valueForKey:@"currentUserFirstName"];
    NSString *currentUserLastName = [defaults valueForKey:@"currentUserLastName"];
    
    NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@",
                                @"userFirstName", currentUserFirstName, @"userLastName", currentUserLastName];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"EmergencyContact"];
    [fetchRequest setPredicate:predicate];
    
    self.contactArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)])
    {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveData:(id)sender
{
    NSManagedObjectContext *context = [self managedObjectContext];
    if (self.contactdb)
    {
        // Update existing contact
        [self.contactdb setValue:self.nameTF.text forKey:@"name"];
        [self.contactdb setValue:self.emailTF.text forKey:@"email"];
    }
    else
    {
        // Create a new contact
        NSManagedObject *newContact = [NSEntityDescription
                                      insertNewObjectForEntityForName:@"EmergencyContact" inManagedObjectContext:context];
        [newContact setValue:self.nameTF.text forKey:@"name"];
        [newContact setValue:self.emailTF.text forKey:@"email"];
        [newContact setValue:self.currentUser.firstName forKey:@"userFirstName"];
        [newContact setValue:self.currentUser.lastName forKey:@"userLastName"];
        
    }
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error])
    {
    NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@",
                                @"userFirstName", self.currentUser.firstName, @"userLastName", self.currentUser.lastName];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"EmergencyContact"];
    [fetchRequest setPredicate:predicate];
    
    self.contactArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
//[self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)btnCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.contactArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.nameTF.text = [[self.contactArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    self.emailTF.text = [[self.contactArray objectAtIndex:indexPath.row] valueForKey:@"email"];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // What goes in each cell.
    NSManagedObject *contact = [self.contactArray objectAtIndex:indexPath.row];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ %@", [contact valueForKey:@"name"], [contact valueForKey:@"email"]]];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [contact valueForKey:@"name"]]];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete object from database
        [context deleteObject:[self.contactArray objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        // Remove device from table view
        [self.contactArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
