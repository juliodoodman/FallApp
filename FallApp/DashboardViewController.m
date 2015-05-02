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
- (void)viewDidLoad
{
    [super viewDidLoad];
    ble = [[BLE alloc] init];
    [ble controlSetup:(0)];
    ble.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
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
    
    
    // parse data, all commands are in 3-byte
    for (int i = 0; i < length; i+=3)
    {
        if (data[i] == 0x0A) //X-pin
        {
            NSLog(@"X-pin value");
            NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
        }
        else if (data[i] == 0x0B) //Y-pin
        {
            NSLog(@"Y-pin value");
            NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
        }
        else if (data[i] == 0x0C) //Z-pin
        {
            NSLog(@"Z-pin value");
            NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
        }
        else if (data[i] == 0x0D) //O-pin (orientation)?
        {
            NSLog(@"O-pin value");
            NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
        }
    }
}

@end
