//
//  FallViewController.m
//  FallApp
//
//  Created by Julio Morera on 5/3/15.
//  Copyright (c) 2015 Julio Morera. All rights reserved.
//

#import "FallViewController.h"

@interface FallViewController ()

@end

@implementation FallViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    if (self.detailItem)
    {
        self.dateLabel.hidden=NO;
        self.timeLabel.hidden=NO;
        self.locationLabel.hidden=NO;
        self.notesLabel.hidden=NO;
           
        
        
        NSDate *fallDate = [_detailItem valueForKey:@"time"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
        NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setDateStyle:NSDateFormatterNoStyle];
        [timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
        
        NSString *formattedDateString = [dateFormatter stringFromDate:fallDate];
        NSString *formattedTimeString = [timeFormatter stringFromDate:fallDate];
        
        
        [self.dateLabel setText:formattedDateString];
        [self.timeLabel setText:formattedTimeString];
        self.locationLabel.text = [[self.detailItem valueForKey:@"location"] description];
        self.notesLabel.text = [[self.detailItem valueForKey:@"notes"] description];

    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)homeButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)hideLabels:(UIButton *)sender
{
    self.dateLabel.hidden=YES;
    self.timeLabel.hidden=YES;
    self.locationLabel.hidden=YES;
    self.notesLabel.hidden=YES;
}

@end
