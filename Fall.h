//
//  Fall.h
//  FallApp
//
//  Created by Julio Morera on 5/2/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Fall : NSManagedObject

@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * xAccel;
@property (nonatomic, retain) NSNumber * yAccel;
@property (nonatomic, retain) NSNumber * zAccel;
@property (nonatomic, retain) User *user;

@end
