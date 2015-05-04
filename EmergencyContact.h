//
//  EmergencyContact.h
//  FallApp
//
//  Created by Julio Morera on 5/4/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface EmergencyContact : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * userFirstName;
@property (nonatomic, retain) NSString * userLastName;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) User *user;

@end
