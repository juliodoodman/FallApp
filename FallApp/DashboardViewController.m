//
//  DashboardViewController.m
//  FallApp
//
//  Created by Julio Morera on 4/20/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController
@synthesize ble;
CLLocationManager *manager;
CLGeocoder *geocoder;
CLPlacemark *placemark;

- (void)viewDidLoad
{
    [super viewDidLoad];
    ble = [[BLE alloc] init];
    [ble controlSetup:(0)];
    ble.delegate = self;
    
    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark BLE Delegate

- (void)bleDidDisconnect
{
    NSLog(@"->Disconnected");
    
}

- (void) bleDidUpdateRSSI:(NSNumber *) rssi
{
    //NSLog(@"%@", rssi.stringValue);
}

- (void) bleDidConnect
{
    NSLog(@"->Connected");
    
    UInt8 buf[3] = {0xA0, 0x01, 0x00};
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [ble write:data];
}

-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSLog(@"Length: %d", length);
    UInt16 x = 0;
    UInt16 y = 0;
    UInt16 z = 0;
    UInt16 o = 0;
    
    // parse data, all commands are in 3-byte
    for (int i = 0; i < length; i+=3)
    {
        if (data[i] == 0x0A) //X-pin
        {
            NSLog(@"X-pin value");
            //NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
            x = data[i+2];
            NSLog(@"%d", x);
        }
        else if (data[i] == 0x0B) //Y-pin
        {
            NSLog(@"Y-pin value");
            //NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
            y = data[i+2];
            NSLog(@"%d", y);
        }
        else if (data[i] == 0x0C) //Z-pin
        {
            NSLog(@"Z-pin value");
            //NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
            z = data[i+2];
            NSLog(@"%d", z);
        }
        else if (data[i] == 0x0D) //O-pin (orientation)?
        {
            NSLog(@"O-pin value");
            //NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
            o = data[i+2];
            NSLog(@"%d", o);
        }

        if (x^2+y^2+z^2 > 100)
        {
            NSLog(@"Fall detected!");
        }
            
    }
}

- (IBAction)connectToBluetooth:(UIButton *)sender
{
    if (ble.activePeripheral)
        if (ble.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
            [_btConnectionButton setTitle:@"Connect" forState:UIControlStateNormal];
            return;
        }
    
    if (ble.peripherals)
        ble.peripherals = nil;
    
    [_btConnectionButton setEnabled:false];
    [_btConnectionButton setTitle:@"Connecting..." forState:UIControlStateDisabled];
    [ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    //[_connectionActivityIndicator startAnimating];
}
- (void) connectionTimer:(NSTimer *)timer
{
    [_btConnectionButton setEnabled:true];
    [_btConnectionButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    if (ble.peripherals.count > 0)
    {
        [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
    }
    else
    {
        [_btConnectionButton setTitle:@"Connect" forState:UIControlStateNormal];
        //[_connectionActivityIndicator stopAnimating];
    }
}

- (IBAction)fallDetection:(UISwitch *)sender
{
}

- (IBAction)alarmSwitch:(UISwitch *)sender
{
}
//Test Method
- (IBAction)testEmail:(UIButton *)sender
{
    [self showEmail];
}

- (void) playAudio
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"alarm" ofType:@"mp3"];
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    AVAudioPlayer *theAudio;
    //theAudio  = [[[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    [theAudio play];
    
}

#pragma mark Email
-(void)showEmail

{
    //String for Email Subject Line
    
    
    //String for Email Subject Body
    
    
    //Array for Email Recipients
    
    
    
    //Set Email Variables
    NSString *emailTitle = @"Julio, Does this work?";
    NSString *messageBody = @"Hey, check this out!";
    NSArray *toRecipents = [NSArray arrayWithObject:@"support@appcoda.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    
    // Present mail view controller on screen
    
    [self presentViewController:mc animated:YES completion:NULL];    
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error

{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
            
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
            
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark Location
-(void) updateLocation
{
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [manager startUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location! :(");
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"Location: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        _latitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        _longitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        
    }
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if (error == nil && [placemarks count] > 0) {
            
            placemark = [placemarks lastObject];
            
            _address = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
            
        } else {
            
            NSLog(@"%@", error.debugDescription);
            
        }
        
    } ];
    
}


@end
