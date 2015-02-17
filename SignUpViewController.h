//
//  SignUpViewController.h
//  ParseTestLogin
//
//  Created by Clark Feusier on 12/13/13.
//  Copyright (c) 2013 Clark Feusier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpViewController : UIViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
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
}
@property (weak, nonatomic) IBOutlet UITextField *display_name;
@property (weak, nonatomic) IBOutlet UITextField *level_text;

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

@property (weak, nonatomic) IBOutlet UIPickerView *level_picker;

@end
