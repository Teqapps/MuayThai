//
//  MyLogInViewController.m
//  LogInAndSignUpDemo
//
//  Created by Mattieu Gamache-Asselin on 6/15/12.
//  Copyright (c) 2013 Parse. All rights reserved.
//

#import "MyLogInViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MyLogInViewController ()
@property (nonatomic, strong) UIImageView *fieldsBackground;
@end

@implementation MyLogInViewController

@synthesize fieldsBackground;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.logInView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_background.png"]]];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]]];
    
    // Set buttons appearance
    //[self.logInView.dismissButton setImage:[UIImage imageNamed:@"Exit.png"] forState:UIControlStateNormal];
    //[self.logInView.dismissButton setImage:[UIImage imageNamed:@"ExitDown.png"] forState:UIControlStateHighlighted];
    // Set buttons appearance
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"loading_icon_cancel.png"] forState:UIControlStateNormal];
    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"loading_icon_cancel_off.png"] forState:UIControlStateHighlighted];

    [self.logInView.facebookButton setImage:[UIImage imageNamed:nil] forState:UIControlStateNormal];
    [self.logInView.facebookButton setImage:[UIImage imageNamed:nil] forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"loading_signup_backgroud_offf.png"] forState:UIControlStateHighlighted];
    [self.logInView.facebookButton setTitle:nil forState:UIControlStateNormal];
    [self.logInView.facebookButton setTitle:nil forState:UIControlStateHighlighted];
    
    
    [self.logInView.passwordForgottenButton setImage:[UIImage imageNamed:@"loading_forget.png"] forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setImage:[UIImage imageNamed:@"loading_forget_off.png"] forState:UIControlStateHighlighted];
    [self.logInView.passwordForgottenButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.logInView.passwordForgottenButton setTitle:@"" forState:UIControlStateNormal];
    [self.logInView.passwordForgottenButton setTitle:@"" forState:UIControlStateHighlighted];

    
    //[self.logInView.twitterButton setImage:nil forState:UIControlStateNormal];
    //[self.logInView.twitterButton setImage:nil forState:UIControlStateHighlighted];
    //[self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"Twitter.png"] forState:UIControlStateNormal];
    //[self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"TwitterDown.png"] forState:UIControlStateHighlighted];
    //[self.logInView.twitterButton setTitle:@"" forState:UIControlStateNormal];
    //[self.logInView.twitterButton setTitle:@"" forState:UIControlStateHighlighted];
    
    

    
    [self.logInView.logInButton setImage:[UIImage imageNamed:@"loginbtn.png"] forState:UIControlStateNormal];
    [self.logInView.logInButton setImage:[UIImage imageNamed:@"loginbtn_off.png"] forState:UIControlStateHighlighted];

    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.logInView.logInButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.logInView.logInButton setTitle:nil forState:UIControlStateNormal];
    [self.logInView.logInButton setTitle:nil forState:UIControlStateHighlighted];
    

    // Set field text color
  
    [self.logInView.usernameField setPlaceholder:@"Enter Username"];
    [self.logInView.passwordField setPlaceholder:@"Enter Password"];
    
  
    
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    
    
    [self.logInView.usernameField setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    [self.logInView.passwordField setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    [self.logInView.passwordField setValue:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [self.logInView.usernameField setValue:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0]];

}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    // [self.logInView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 600.0f)];
   [self.logInView.passwordForgottenButton setFrame:CGRectMake(290.0f, 224.0f, 20.0f, 20.0f)];
    [self.logInView.dismissButton setFrame:CGRectMake(280.0f, 50.0f, 30.0f, 30.0f)];
    [self.logInView.logo setFrame:CGRectMake(75.0f, 70.0f,178.0f, 41.5f)];
    [self.logInView.facebookButton setFrame:CGRectMake(0.0f, 340.0f, 320.0f, 40.0f)];    [self.logInView.twitterButton setFrame:CGRectMake(35.0f+150.0f, 310.0f, 120.0f, 40.0f)];
    [self.logInView.logInButton setFrame:CGRectMake(10.0f, 290.0f, 145.0f, 40.0f)];
    [self.logInView.signUpButton setFrame:CGRectMake(165.0f, 290.0f, 145.0f, 40.0f)];
    [self.logInView.usernameField setFrame:CGRectMake(0.0f, 160.0f, 320.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(0.0f, 210.0f, 320.0f, 50.0f)];
    [self.fieldsBackground setFrame:CGRectMake(35.0f, 160.0f, 320.0f, 100.0f)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
