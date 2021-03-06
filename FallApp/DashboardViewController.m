//
//  DashboardViewController.m
//  FallApp
//
//  Created by Julio Morera on 4/20/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import "DashboardViewController.h"
#import "AppDelegate.h"
#import "User.h"
#import "Fall.h"
#import "EmergencyContact.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController
AVAudioPlayer *theAudio;

@synthesize ble;
CLLocationManager *manager;
CLGeocoder *geocoder;
CLPlacemark *placemark;

BOOL fallDetected = FALSE;

- (void)viewDidLoad
{

    [super viewDidLoad];
    ble = [[BLE alloc] init];
    [ble controlSetup:(0)];
    ble.delegate = self;
    
    
    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    [self updateLocation];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentUserFirstName = [defaults valueForKey:@"currentUserFirstName"];
    NSString *currentUserLastName = [defaults valueForKey:@"currentUserLastName"];
    
    NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"%K == %@ AND %K == %@",
                                @"firstName", currentUserFirstName, @"lastName", currentUserLastName];
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    [fetchRequest setPredicate:predicate];
    //[fetchRequest mutableArrayValueForKey:@"emergencyContacts"];
    //self.toRecipients = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];

    self.userArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    self.currentUser = self.userArray[0];
    _toRecipients = [self.currentUser mutableArrayValueForKeyPath:@"emergencyContacts.user"];
    NSLog(@"bloo");
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

#pragma mark BLE Delegate

- (void)bleDidDisconnect
{
    [[self bluetoothStrengthImage] setImage:[UIImage imageNamed:@"0bar.png"]];
    NSLog(@"->Disconnected");
    
}

- (void) bleDidUpdateRSSI:(NSNumber *) rssi
{
    if ([rssi intValue]<-50)
    {
        [[self bluetoothStrengthImage] setImage:[UIImage imageNamed:@"4bar.png"]];

    }
    else if ([rssi intValue]<-80)
    {
        [[self bluetoothStrengthImage] setImage:[UIImage imageNamed:@"3bar.png"]];

    }
    else if ([rssi intValue]<-110)
    {
        [[self bluetoothStrengthImage] setImage:[UIImage imageNamed:@"2bar.png"]];

    }
    else
    {
        [[self bluetoothStrengthImage] setImage:[UIImage imageNamed:@"1bar.png"]];

    }
    //NSLog(@"%@", rssi.stringValue);
    [_connectionActivityIndicator stopAnimating];
    [_connectionActivityIndicator setHidden:true];

}

- (void) bleDidConnect
{
    NSLog(@"->Connected");
    
    UInt8 buf[3] = {0xA0, 0x01, 0x00};
    
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [ble write:data];
    [_connectionActivityIndicator stopAnimating];
    [_connectionActivityIndicator setHidden:true];

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
           // NSLog(@"O-pin value");
            //NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
            o = data[i+2];
           // NSLog(@"%d", o);
        }
        int magnitude =sqrt(x*x+y*y+z*z);
        NSLog(@"Magnitude");
        NSLog(@"%d", magnitude);
        int threshold = 215;
        if (magnitude > threshold && fallDetected == FALSE)
        {
            NSLog(@"Fall detected!");
            fallDetected = TRUE;
            Timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(TimerCount) userInfo:nil repeats:NO];
            UIApplication *myApp = [UIApplication sharedApplication];
            AppDelegate *myAppDelegate  = [myApp delegate];
            
            [myAppDelegate makeNewFallWithXAccel:[NSNumber numberWithInt:x] andYAccel:[NSNumber numberWithInt:y] andZAccel:[NSNumber numberWithInt:z] andTime:[NSDate date] andNotes:@"Notes" andLocation:@"location" inContext:myAppDelegate.managedObjectContext];
            
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"We have Detected a Fall!"
                                                                           message:@"An Alarm will go off in 30 seconds."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action)
            {
                [theAudio stop];
                [Timer invalidate];
                fallDetected = FALSE;
                [self showEmail];
                                                                  }];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            if (!fallDetected)
            {
            [Timer invalidate];
            [theAudio stop];
            }
            
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
    
    [_connectionActivityIndicator setHidden:false];
    [_connectionActivityIndicator startAnimating];
}
- (void) connectionTimer:(NSTimer *)timer
{
    [_btConnectionButton setEnabled:true];
    [_btConnectionButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    [_connectionActivityIndicator stopAnimating];
    [_connectionActivityIndicator setHidden:true];
    
    if (ble.peripherals.count > 0)
    {
        [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
    }
    else
    {
        [_btConnectionButton setTitle:@"Connect" forState:UIControlStateNormal];
        

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
{;
    [self showEmail];
}

- (IBAction)testSound:(UIButton *)sender
{
    [self playAudio];
}

- (void) playAudio
{
       
    NSString *path = [[NSBundle mainBundle] pathForResource:@"alarm" ofType:@"mp3"];
    NSURL *soundURL = [NSURL fileURLWithPath:path];
    NSError *error;
    theAudio  = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    theAudio.volume=1.0;
    theAudio.numberOfLoops=-1;          //this sets the alarm to be an infinite loop
    [theAudio play];
    
    //[theAudio pause]; //this command would pause the audio
    //[theAudio stop];  //this command would stop the audio
    
}

#pragma mark Email
-(void)showEmail

{
    //Email Contacts
    NSManagedObjectContext *moc2 = [self managedObjectContext];
    NSEntityDescription *entityDescription2 = [NSEntityDescription
                                              entityForName:@"EmergencyContact" inManagedObjectContext:moc2];
    NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
    [request2 setEntity:entityDescription2];
    
    
    NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc]
                                         initWithKey:@"name" ascending:YES];
    [request2 setSortDescriptors:@[sortDescriptor2]];
    
    NSError *error;
    NSArray *array2 = [moc2 executeFetchRequest:request2 error:&error];
    NSMutableArray *emailArray = [[NSMutableArray alloc] initWithCapacity:[array2 count]];
    for( int i=0; i< [array2 count]; i++)
    {
        EmergencyContact *tempContact = array2[i];
        [emailArray insertObject:tempContact.email atIndex:i];
      
    }
    
    
    //Fall Data
    NSManagedObjectContext *moc1 = [self managedObjectContext];
    NSEntityDescription *entityDescription1 = [NSEntityDescription
                                              entityForName:@"Fall" inManagedObjectContext:moc1];
    NSFetchRequest *request1 = [[NSFetchRequest alloc] init];
    [request1 setEntity:entityDescription1];
    
    
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc]
                                        initWithKey:@"time" ascending:YES];
    [request1 setSortDescriptors:@[sortDescriptor1]];
    
    NSArray *arryay1 = [moc1 executeFetchRequest:request1 error:&error];
    Fall *currentFall= arryay1[([arryay1 count]-1)];
    
    NSDate *fallDate = currentFall.time;
    //String for Email Subject Body

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateStyle:NSDateFormatterNoStyle];
    [timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:fallDate];
    NSString *formattedTimeString = [timeFormatter stringFromDate:fallDate];
    NSString *notes = currentFall.notes;
    
    NSString *introString = @"Hello All, \n\n";
    
    
    NSString *messageBody = [NSString stringWithFormat:@"%@ User %@ %@ experienced a fall today %@ at %@. \n\n-Courtesy of FallApp", introString, self.currentUser.firstName, self.currentUser.lastName, formattedDateString, formattedTimeString];
    
    //Set Email Variables
    NSString *emailTitle = [NSString stringWithFormat:@"Fall detected for %@ %@.", self.currentUser.firstName, self.currentUser.lastName];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:emailArray];
    [mc setCcRecipients:[NSArray arrayWithObject:self.currentUser.email]];
    
    
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
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    manager.distanceFilter = 10;
    
    [manager startUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location! :(");
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    NSLog(@"Location: blah");
    CLLocation *currentLocation = [locations lastObject];
    NSDate *eventDate = currentLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (fabs(howRecent) < 15.0)
    {
        
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
-(void)TimerCount
{
    [self playAudio];
}


@end
