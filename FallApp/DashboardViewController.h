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
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import "Fall.h"
#import "User.h"

@interface DashboardViewController : UIViewController <BLEDelegate, AVAudioPlayerDelegate, MFMailComposeViewControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) BLE *ble;

@property (weak, nonatomic) NSString *latitude;
@property (weak, nonatomic) NSString *longitude;
@property (weak, nonatomic) NSString *address;

@property (strong) NSMutableArray *userArray;
@property (strong) User *currentUser;
@property (strong) NSArray *toRecipients;


@property (weak, nonatomic) IBOutlet UIImageView *bluetoothStrengthImage;
@property (weak, nonatomic) IBOutlet UIButton *btConnectionButton;
- (IBAction)connectToBluetooth:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *connectionActivityIndicator;


- (IBAction)fallDetection:(UISwitch *)sender;
- (IBAction)alarmSwitch:(UISwitch *)sender;

- (IBAction)testEmail:(UIButton *)sender;
- (IBAction)testSound:(UIButton *)sender;

-(void) showEmail;
-(void) playAudio;
@end

