//
//  SignUpViewController.h
//  ParseTestLogin
//
//  Created by Clark Feusier on 12/13/13.
//  Copyright (c) 2013 Clark Feusier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate>
{
    NSString * picker1_string;
      NSString * picker2_string;
      NSString * picker3_string;
      NSString * picker4_string;
      NSString * picker5_string;
    
    UILabel * test;
    UITextField *myTextField;
    UIPickerView *myPickerView;
    NSArray *pickerArray;
    float number;
    int value;
    NSString * sex;
    NSString * bloodtype;
    NSString *localDateString ;
    NSDateFormatter * format;
     NSArray *blood_array;
    NSArray *level_array;
      NSArray *studio_array;
    NSArray *instructor_array;
    NSArray *glove_array;
    NSArray *professional_array;
    
}
@property (weak, nonatomic) IBOutlet UITextField *display_name;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextField *usernameEntry;
@property (weak, nonatomic) IBOutlet UITextField *passwordEntry;
@property (weak, nonatomic) IBOutlet UITextField *emailEntry;
@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (weak, nonatomic) IBOutlet UITextField *height;
@property (weak, nonatomic) IBOutlet UITextField *phone_number;
- (IBAction)createUser:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *height_lbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sex_segmented;
- (IBAction)sex_segmented:(id)sender;
- (IBAction)date:(UIDatePicker *)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;

@property (weak, nonatomic) IBOutlet UISegmentedControl *blood_type;
- (IBAction)blood_type:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UIPickerView *picker1;
@property (weak, nonatomic) IBOutlet UILabel *picker1_lbl;
@property (weak, nonatomic) IBOutlet UIPickerView *picker2;
@property (weak, nonatomic) IBOutlet UILabel *picker2_lbl;
@property (weak, nonatomic) IBOutlet UIPickerView *picker3;
@property (weak, nonatomic) IBOutlet UILabel *picker3_lbl;
@property (weak, nonatomic) IBOutlet UIPickerView *picker4;
@property (weak, nonatomic) IBOutlet UILabel *picker4_lbl;
@property (weak, nonatomic) IBOutlet UIPickerView *picker5;
@property (weak, nonatomic) IBOutlet UILabel *picker5_lbl;


@property (weak, nonatomic) IBOutlet UIImageView *profile;
- (IBAction)change_icon:(id)sender;


@end
