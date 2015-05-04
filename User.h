//
//  User.h
//  FallApp
//
//  Created by Julio Morera on 5/4/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class EmergencyContact, Fall;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSSet *emergencyContacts;
@property (nonatomic, retain) NSSet *falls;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addEmergencyContactsObject:(EmergencyContact *)value;
- (void)removeEmergencyContactsObject:(EmergencyContact *)value;
- (void)addEmergencyContacts:(NSSet *)values;
- (void)removeEmergencyContacts:(NSSet *)values;

- (void)addFallsObject:(Fall *)value;
- (void)removeFallsObject:(Fall *)value;
- (void)addFalls:(NSSet *)values;
- (void)removeFalls:(NSSet *)values;

@end
