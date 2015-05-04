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
        [self.dateLabel setText:[[_detailItem valueForKey:@"time"] description]];
        self.locationLabel.text = [[self.detailItem valueForKey:@"location"] description];
        self.notesLabel.text = [[self.detailItem valueForKey:@"notes"] description];
//        self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", [[self.detailItem valueForKey:@"firstName"] description], [[self.detailItem valueForKey:@"lastName"] description]];
//        self.sexLabel.text = [[self.detailItem valueForKey:@"sex"] description];
//        self.raceLabel.text = [[self.detailItem valueForKey:@"race"] description];
//        self.alignmentLabel.text = [[self.detailItem valueForKey:@"alignment"] description];
//        self.classLabel.text = [[self.detailItem valueForKey:@"characterClass"] description];
//        self.levelLabel.text = [[self.detailItem valueForKey:@"level" ] description];
//        self.portrait.image = [self.detailItem valueForKey:@"picture"];
//        
//        // Abilities
//        NSMutableDictionary * abilitiesDictionary = [self.detailItem valueForKey:@"abilities"];
//        self.strengthLabel.text = [[abilitiesDictionary valueForKey:@"strength"] description];
//        self.dexterityLabel.text = [[abilitiesDictionary valueForKey:@"dexterity"] description];
//        self.constitutionLabel.text = [[abilitiesDictionary valueForKey:@"constitution"] description];
//        self.intelligenceLabel.text = [[abilitiesDictionary valueForKey:@"intelligence"] description];
//        self.wisdomLabel.text = [[abilitiesDictionary valueForKey:@"wisdom"] description];
//        self.charismaLabel.text = [[abilitiesDictionary valueForKey:@"charisma"] description];
//        
//        // Modifiers
//        NSMutableDictionary * modifiersDictionary = [NSMutableDictionary dictionaryWithDictionary:abilitiesDictionary];
//        int strength = [[abilitiesDictionary valueForKey:@"strength"] intValue];
//        int dexterity = [[abilitiesDictionary valueForKey:@"dexterity"] intValue];
//        int constitution = [[abilitiesDictionary valueForKey:@"constitution"] intValue];
//        int intelligence = [[abilitiesDictionary valueForKey:@"intelligence"] intValue];
//        int wisdom = [[abilitiesDictionary valueForKey:@"wisdom"] intValue];
//        int charisma = [[abilitiesDictionary valueForKey:@"charisma"] intValue];
//        [modifiersDictionary setValue:[NSNumber numberWithInt:strength/2 - 5] forKey:@"strength"];
//        [modifiersDictionary setValue:[NSNumber numberWithInt:dexterity/2 - 5] forKey:@"dexterity"];
//        [modifiersDictionary setValue:[NSNumber numberWithInt:constitution/2 - 5] forKey:@"constitution"];
//        [modifiersDictionary setValue:[NSNumber numberWithInt:intelligence/2 - 5] forKey:@"intelligence"];
//        [modifiersDictionary setValue:[NSNumber numberWithInt:wisdom/2 - 5] forKey:@"wisdom"];
//        [modifiersDictionary setValue:[NSNumber numberWithInt:charisma/2 - 5] forKey:@"charisma"];
//        
//        self.strengthModifierLabel.text = [[modifiersDictionary valueForKey:@"strength"] description];
//        self.dexterityModifierLabel.text = [[modifiersDictionary valueForKey:@"dexterity"] description];
//        self.constitutionModifierLabel.text = [[modifiersDictionary valueForKey:@"constitution"] description];
//        self.intelligenceModifierLabel.text = [[modifiersDictionary valueForKey:@"intelligence"] description];
//        self.wisdomModifierLabel.text = [[modifiersDictionary valueForKey:@"wisdom"] description];
//        self.charismaModifierLabel.text = [[modifiersDictionary valueForKey:@"charisma"] description];
//        
//        // Hitpoints
//        self.currentHitPointsLabel.text = [NSString stringWithFormat:@"%@", [self.detailItem valueForKey:@"currentHitPoints"]];
//        self.maximumHitPointsLabel.text = [NSString stringWithFormat:@"%@", [self.detailItem valueForKey:@"maxHitPoints"]];
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
