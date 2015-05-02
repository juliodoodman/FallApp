//
//  ViewController.h
//  FallApp
//
//  Created by Julio Morera on 4/20/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE_Framework/BLE.h"
#import "AppDelegate.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AVFoundation/AVFoundation.h>
#import "Fall.h"

@interface DashboardViewController : UIViewController <BLEDelegate, AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) BLE *ble;
@property (weak, nonatomic) IBOutlet UIButton *btConnectionButton;
- (IBAction)connectToBluetooth:(UIButton *)sender;


- (IBAction)fallDetection:(UISwitch *)sender;
- (IBAction)alarmSwitch:(UISwitch *)sender;

- (IBAction)testEmail:(UIButton *)sender;

-(void) showEmail;
-(void) playAudio;
@end

