//
//  MainViewController.m
//  Laibarilai
//
//  Created by Suresh on 19/01/2014.
//  Copyright (c) 2014 SantaGurung. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)registerWithFacebook:(id)sender {
    NSArray *permissions = @[@"email"];
    
    [PFFacebookUtils logInWithPermissions:permissions block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            // Create Facebook Request for user's details
            [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *fbUser, NSError *error) {
                // This is an asynchronous method. When Facebook responds, if there are no errors, we'll update the Welcome label.
                if (!error) {
                    
                    PFQuery *query = [PFUser query];
                    [query includeKey:@"objectId"];
                    [query whereKey:@"username" equalTo:fbUser[@"email"]];
                    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                        if(number > 0){
                            // delete the user that was created as part of Parse's Facebook login
                            [user deleteInBackground];
                            [[FBSession activeSession] closeAndClearTokenInformation];
                            [[[UIAlertView alloc] initWithTitle:@"Email already exists."
                                                        message:@"Please login with email to link with Facebook"
                                                       delegate:nil
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil] show];
                            [self performSegueWithIdentifier:@"loginSegue" sender:self];
                        } else {
                            // First save the email of the FBUser in Parse
                            user.email = fbUser[@"email"];
                            [user saveInBackground];
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UserLoggedIn"];
                            [self.view.window setRootViewController:vc];
                            
                        }
                    }];
                    
                }
            }];
        } else {
            NSLog(@"User logged in through Facebook!");
            // Do stuff after successful login.
            // User creation success
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UserLoggedIn"];
            [self.view.window setRootViewController:vc];
        }
    }];
}

- (IBAction)skipLoginProcess:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UserLoggedIn"];
    [self.view.window setRootViewController:vc];
}

@end
