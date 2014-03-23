//
//  SettingsViewController.m
//  Laibarilai
//
//  Created by Suresh on 09/02/2014.
//  Copyright (c) 2014 SantaGurung. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *linkWithFacebookButton;
@property (weak, nonatomic) IBOutlet UIButton *loginLogoutButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if(![PFUser currentUser]){
        [self.linkWithFacebookButton setHidden:TRUE];
        [self.loginLogoutButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}

- (IBAction)loginLogout:(id)sender
{
    [PFUser logOut];

    if (![self.presentedViewController isBeingPresented] && ![self.presentedViewController isBeingDismissed]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.view.window setRootViewController:vc];
    }
}

- (IBAction)linkWithFacebook:(id)sender
{
    NSArray *permissions = @[@"email"];
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        
        [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *fbUser, NSError *error) {
            // This is an asynchronous method. When Facebook responds, if there are no errors, we'll update the Welcome label.
            if (!error) {
                
                if(![[[PFUser currentUser] objectForKey:@"fbUsername"] isEqualToString:fbUser[@"email"]]){
                    [PFFacebookUtils linkUser:[PFUser currentUser] permissions:permissions block:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"Woohoo, user logged in with Facebook!");
                        }
                    }];
                    
                }else{
                    [self showAlertMessageWithTitle:@"Cannot link different email accounts" andMessage:@"Check the Facebook account and try again."];
                }
            }
        }];
        
    }
}

// Handle error messages
- (void) showAlertMessageWithTitle:(NSString *)title andMessage:(NSString *)message
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
}


@end
