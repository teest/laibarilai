//
//  ProfileViewController.m
//  Laibarilai
//
//  Created by Suresh on 09/02/2014.
//  Copyright (c) 2014 SantaGurung. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *username;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Only if user logs in,
    if([PFUser currentUser]){
        self.username.text = [[PFUser currentUser] objectForKey:@"fbUsername"];
    }
}

@end
