//
//  HomeViewController.m
//  ParseTestLogin
//
//  Created by Clark Feusier on 12/13/13.
//  Copyright (c) 2013 Clark Feusier. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        // do stuff with the user
        [self performSegueWithIdentifier:@"loggedInSegue" sender:self];
    } else {
        // show the signup or login screen
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _loginUsernameEntry.returnKeyType = UIReturnKeyDone;
    [_loginUsernameEntry setDelegate:self];
    _loginPasswordEntry.returnKeyType = UIReturnKeyDone;
    [_loginPasswordEntry setDelegate:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    
    [PFUser logInWithUsernameInBackground:_loginUsernameEntry.text password:_loginPasswordEntry.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"Success");
                                            [self performSegueWithIdentifier:@"loggedInSegue" sender:self];
                                        } else {
                                            // The login failed. Check error to see why.
                                             NSLog(@"Failure");
                                            UIAlertView *alertViewLoginFailure = [[UIAlertView alloc] initWithTitle:@"Your login credentials were invalid" message:@"Please try entering your information again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                            
                                            [alertViewLoginFailure show];
                                        }
                                    }];
}

- (IBAction)forgotPassword:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email Address" message:@"Enter the email for your account:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){

            UITextField *emailAddress = [alertView textFieldAtIndex:0];
        
        [PFUser requestPasswordResetForEmailInBackground: emailAddress.text];
        
        UIAlertView *alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Success! A reset email was sent to you" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertViewSuccess show];
    }
}

// Keyboard Responder Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_loginUsernameEntry resignFirstResponder];
    [_loginPasswordEntry resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_loginUsernameEntry resignFirstResponder];
    [_loginPasswordEntry resignFirstResponder];
    
    [PFUser logInWithUsernameInBackground:_loginUsernameEntry.text password:_loginPasswordEntry.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"Success");
                                            [self performSegueWithIdentifier:@"loggedInSegue" sender:self];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"Failure");
                                            UIAlertView *alertViewLoginFailure = [[UIAlertView alloc] initWithTitle:@"Your login credentials were invalid" message:@"Please try entering your information again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                            
                                            [alertViewLoginFailure show];
                                        }
                                    }];
    
    return YES;
}

- (IBAction)unwindSegueToLogin: (UIStoryboardSegue *)segue {
    
    
}

@end
