//
//  LoginScreenViewController.m
//  FallApp
//
//  Created by Julio Morera on 4/22/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import "LoginScreenViewController.h"

@interface LoginScreenViewController ()

@end

@implementation LoginScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"Colin" forKey:@"currentUserFirstName"];
    [defaults setValue:@"Barry" forKey:@"currentUserLastName"];
    [defaults synchronize];
}

- (void)didReceiveMemoryWarning {
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

@end
