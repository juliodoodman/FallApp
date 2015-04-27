//
//  ViewController.h
//  FallApp
//
//  Created by Julio Morera on 4/20/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE_Framework/BLE.h"

@interface DashboardViewController : UIViewController <BLEDelegate>

@property (strong, nonatomic) BLE *ble;
@property (weak, nonatomic) IBOutlet UISwitch *connectionSwitch;


@end

