//
//  User.h
//  FallApp
//
//  Created by Julio Morera on 5/2/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Fall, NSManagedObject;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *emergencyContacts;
@property (nonatomic, retain) NSSet *falls;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addEmergencyContactsObject:(NSManagedObject *)value;
- (void)removeEmergencyContactsObject:(NSManagedObject *)value;
- (void)addEmergencyContacts:(NSSet *)values;
- (void)removeEmergencyContacts:(NSSet *)values;

- (void)addFallsObject:(Fall *)value;
- (void)removeFallsObject:(Fall *)value;
- (void)addFalls:(NSSet *)values;
- (void)removeFalls:(NSSet *)values;

@end
