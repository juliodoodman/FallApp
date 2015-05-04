//
//  SignUpViewController.m
//  FallApp
//
//  Created by Julio Morera on 4/22/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import "SignUpViewController.h"
#import "AppDelegate.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveNewUser:(UIButton *)sender
{
    UIApplication *myApp = [UIApplication sharedApplication];
    AppDelegate *myAppDelegate  = [myApp delegate];

    //Setting the object
    
    [myAppDelegate makeNewUserWithFirstName:_firstNameTF.text andLastName:_lastNameTF.text andEmail:_emailTF.text andPassword:@"password" inContext:myAppDelegate.managedObjectContext];
}
@end
