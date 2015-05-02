//
//  EmergencyContact.h
//  FallApp
//
//  Created by Julio Morera on 5/2/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface EmergencyContact : NSManagedObject

@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) User *user;

@end
