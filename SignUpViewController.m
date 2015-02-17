//
//  SignUpViewController.m
//  ParseTestLogin
//
//  Created by Clark Feusier on 12/13/13.
//  Copyright (c) 2013 Clark Feusier. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addPickerView];

         [self.scrollview setContentSize:CGSizeMake(320,  900)];
	// Do any additional setup after loading the view.
    blood_array = [[NSArray alloc] initWithObjects:@"O-",@"O+",@"A-",@"A+",@"B-",@"B+",@"AB-",@"AB+",nil];
   
    _emailEntry.returnKeyType = UIReturnKeyDone;
    [_emailEntry setDelegate:self];
    _usernameEntry.returnKeyType = UIReturnKeyDone;
    [_usernameEntry setDelegate:self];
    _passwordEntry.returnKeyType = UIReturnKeyDone;
    [_passwordEntry setDelegate:self];
    _weight.returnKeyType = UIReturnKeyDone;
    [_weight setDelegate:self];
    _height.returnKeyType = UIReturnKeyDone;
    [_height setDelegate:self];

}

   
    -(void)addPickerView{
        pickerArray = [[NSArray alloc]initWithObjects:@"Beginner (0 - 1year)",
                       @"Intermdiate (1 - 3year)",@"Advanced (3year+)", nil];
        myTextField = [[UITextField alloc]initWithFrame:
                       CGRectMake(10, 100, 300, 30)];
        myTextField.borderStyle = UITextBorderStyleRoundedRect;
        myTextField.textAlignment = UITextAlignmentCenter;
        myTextField.delegate = self;
        [self.view addSubview:myTextField];
        [myTextField setPlaceholder:@""];
        myPickerView = [[UIPickerView alloc]init];
        myPickerView.dataSource = self;
        myPickerView.delegate = self;
        myPickerView.showsSelectionIndicator = YES;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                       target:self action:@selector(done:)];
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:
                              CGRectMake(0, self.view.frame.size.height-
                                         myPickerView.frame.size.height-50, 320, 50)];
        [toolBar setBarStyle:UIBarStyleBlackOpaque];
        NSArray *toolbarItems = [NSArray arrayWithObjects: 
                                 doneButton, nil];
        [toolBar setItems:toolbarItems];
        myTextField.inputView = myPickerView;
        myTextField.inputAccessoryView = toolBar;
        
    }
- (void)done:(id)sender {
     [myPickerView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createUser:(id)sender {
     NSLog(@"%@",[format stringFromDate:_date.date]);
    PFUser *user = [PFUser user];
    user.username = _usernameEntry.text;
    NSString *displayname = [_display_name text];
    [user setObject:displayname forKey:@"display_name"];
    NSString *phone = [_phone_number text];
    [user setObject:phone forKey:@"phone_number"];
    user.password = _passwordEntry.text;
    user.email = _emailEntry.text;

    NSString *weight = [_weight text];
    int int_weight = [weight intValue];
    NSString *height = [_height text];
    int int_height = [height intValue];
    NSLog(@"xxsxxsxx%d",int_height);
     if (_sex_segmented.selectedSegmentIndex == 0) {
         [user setObject:@"男" forKey:@"sex"];
         NSLog(@"male");
     }
     else {
           [user setObject:@"女" forKey:@"sex"];
         NSLog(@"female");
     }
    
    [user setObject:[NSString stringWithFormat:@"%d",int_weight] forKey:@"weight"];
    [user setObject:[NSString stringWithFormat:@"%d",int_height] forKey:@"height"];
    [user setObject:[format stringFromDate:_date.date] forKey:@"dob"];
    
    switch (_blood_type.selectedSegmentIndex) {
        case 0:
            bloodtype=@"O-";
             [user setObject:bloodtype forKey:@"blood_type"];
            break;
        case 1:
            bloodtype=@"O+";
            [user setObject:bloodtype forKey:@"blood_type"];
            break;
        case 2:
            bloodtype=@"A-";
            [user setObject:bloodtype forKey:@"blood_type"];
            break;
        case 3:
            bloodtype=@"A+";
            [user setObject:bloodtype forKey:@"blood_type"];
            break;
            
        case 4:
            bloodtype=@"B-";
            [user setObject:bloodtype forKey:@"blood_type"];
            break;
        case 5:
            bloodtype=@"B+";
            [user setObject:bloodtype forKey:@"blood_type"];
            break;
            
        case 6:
            bloodtype=@"AB-";
            [user setObject:bloodtype forKey:@"blood_type"];
            break;
        case 7:
            bloodtype=@"AB+";
            [user setObject:bloodtype forKey:@"blood_type"];
            break;
            
        default:
            break;
    }

    
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            UIAlertView *alertViewSignupSuccess = [[UIAlertView alloc] initWithTitle:@"Success! Thanks for signing up!" message:@"Press OK to get started"
                delegate:self
                cancelButtonTitle:@"Ok"
                otherButtonTitles:nil];
            
            [alertViewSignupSuccess show];
        } else {
            // Show the errorString somewhere and let the user try again.
            UIAlertView *alertViewLoginFailure = [[UIAlertView alloc] initWithTitle:@"Your signup information was invalid" message:@"Please try entering your information again"
                delegate:self
                cancelButtonTitle:@"Ok"
                otherButtonTitles:nil];
            
            [alertViewLoginFailure show];
        }
    }];
}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
#pragma mark - TextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:myTextField]) {
       [self addPickerView];
        return YES;

    } else {
        return YES;

    }
    return NO;
}

#pragma mark- Picker View Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    [myTextField setText:[pickerArray objectAtIndex:row]];
  



}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {


    [_emailEntry resignFirstResponder];
    [_usernameEntry resignFirstResponder];
    [_passwordEntry resignFirstResponder];
    [_display_name resignFirstResponder];
    [_phone_number resignFirstResponder];
    [_weight resignFirstResponder];
    [_height resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_display_name resignFirstResponder];
    [_phone_number resignFirstResponder];
    [_emailEntry resignFirstResponder];
    [_usernameEntry resignFirstResponder];
    [_passwordEntry resignFirstResponder];
    [_weight resignFirstResponder];
    [_height resignFirstResponder];
    [_phone_number resignFirstResponder];

    PFUser *user = [PFUser user];
    user.email = _emailEntry.text;
    user.username = _usernameEntry.text;
    user.password = _passwordEntry.text;

    
    NSString *displayname = [_display_name text];
    [user setObject:displayname forKey:@"display_name"];
    NSString *phone = [_phone_number text];
    [user setObject:phone forKey:@"phone_number"];
    NSString *weight = [_weight text];
    int int_weight = [weight intValue];
    NSString *height = [_height text];
    int int_height = [height intValue];
    [user setObject:[NSString stringWithFormat:@"%d",int_weight] forKey:@"weight"];
    [user setObject:[NSString stringWithFormat:@"%d",int_height] forKey:@"height"];
    if (_sex_segmented.selectedSegmentIndex == 0) {
        [user setObject:@"男" forKey:@"sex"];
        NSLog(@"male");
    }
    else {
        [user setObject:@"女" forKey:@"sex"];
        NSLog(@"female");
    }
 

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            
            UIAlertView *alertViewSignupSuccess = [[UIAlertView alloc] initWithTitle:@"Success! Thanks for signing up!" message:@"Press OK to get started" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alertViewSignupSuccess show];

        } else {
            // Show the errorString somewhere and let the user try again.
            UIAlertView *alertViewLoginFailure = [[UIAlertView alloc] initWithTitle:@"Your signup information was invalid" message:@"Please try entering your information again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alertViewLoginFailure show];
        }
    }];
    
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        PFUser *currentUser = [PFUser currentUser];
        if (currentUser) {
            
            [self performSegueWithIdentifier:@"signedUpSegue" sender:self];
            
        }
        else {
            NSLog(@"failure");
        }
    }
}


- (IBAction)weight_slider:(UISlider *)sender {

}
- (IBAction)sex_segmented:(id)sender {
    switch (_sex_segmented.selectedSegmentIndex) {
        case 0:
           sex=@"男";
            break;
        case 1:
           sex=@"女";
            
        default:
            break;
    }
}

- (IBAction)date:(UIDatePicker *)sender {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:0];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-100];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [_date setMaximumDate:maxDate];
    [_date setMinimumDate:minDate];

  format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy/M/d"];
   
    NSLog(@"%@",[format stringFromDate:_date.date]);
}
- (IBAction)blood_type:(UISegmentedControl *)sender {
    switch (_blood_type.selectedSegmentIndex) {
        case 0:
            bloodtype=@"O-";
            break;
        case 1:
            bloodtype=@"O+";
            break;
        case 2:
            bloodtype=@"A-";
            break;
        case 3:
            bloodtype=@"A+";
            break;

        case 4:
            bloodtype=@"B-";
            break;
        case 5:
            bloodtype=@"B+";
            break;

        case 6:
            bloodtype=@"AB-";
            break;
        case 7:
            bloodtype=@"AB+";
            break;
     
        default:
            break;
    }

}
@end
