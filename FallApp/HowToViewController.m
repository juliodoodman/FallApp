//
//  HowToViewController.m
//  FallApp
//
//  Created by Julio Morera on 4/22/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import "HowToViewController.h"

@interface HowToViewController ()

@end

@implementation HowToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(771, 1986)];
    // Do any additional setup after loading the view.
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
