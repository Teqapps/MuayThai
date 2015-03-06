//
//  HomeViewController.h
//  ParseTestLogin
//
//  Created by Clark Feusier on 12/13/13.
//  Copyright (c) 2013 Clark Feusier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HomeViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginUsernameEntry;
@property (weak, nonatomic) IBOutlet UITextField *loginPasswordEntry;
- (IBAction)login:(id)sender;
- (IBAction)forgotPassword:(id)sender;

@end
