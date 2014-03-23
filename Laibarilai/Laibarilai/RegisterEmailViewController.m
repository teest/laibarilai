//
//  RegisterEmailViewController.m
//  Laibarilai
//
//  Created by Suresh on 26/01/2014.
//  Copyright (c) 2014 SantaGurung. All rights reserved.
//

#import "RegisterEmailViewController.h"

@interface RegisterEmailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation RegisterEmailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerWithEmail:(id)sender
{
    if(self.emailTextField.text.length == 0 || self.passwordTextField.text.length == 0 || self.confirmPasswordTextField.text.length == 0){
        
        // Empty fields
        [self showAlertMessageWithTitle:@"Missing Information" andMessage:@"Make sure you fill out all of the information!"];
    }else {
        
        if([self validateEmail:self.emailTextField.text]){
            // Check if user first loggedin with facebook
            if(![self checkIfEmailAlreadyTaken:self.emailTextField.text]){
                // Create a new user
                [self createUserAccountWithUserName:self.emailTextField.text andPassword:self.passwordTextField.text];
            }else{
                [self showAlertMessageWithTitle:@"Email already exists." andMessage:@"Please register with new email."];
            }
            
        } else {
            // Invalid email address
            [self showAlertMessageWithTitle:@"Invalid email address" andMessage:@"Please enter the correct email address!"];
        }
        
    }
}

// Validate email address
- (BOOL)validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; //  return 0;
    return [emailTest evaluateWithObject:candidate];
}

-(BOOL)checkIfEmailAlreadyTaken:(NSString *)email
{
    __block BOOL exist;
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:email];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if(number > 0){
            // User first signed up with Facebook
            exist = true;
        } else {
            exist = false;
        }
    }];
    return exist;
}

-(void)createUserAccountWithUserName:(NSString *)email andPassword:(NSString *)password
{
    PFUser *user = [PFUser user];
    user.username = email;
    user.password = password;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // User creation success
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"UserLoggedIn"];
            [self.view.window setRootViewController:vc];
        } else {
            
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            [self showAlertMessageWithTitle:@"Error sign in" andMessage:errorString];
            
        }
    }];
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
