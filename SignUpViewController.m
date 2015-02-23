//
//  SignUpViewController.m
//  ParseTestLogin
//
//  Created by Clark Feusier on 12/13/13.
//  Copyright (c) 2013 Clark Feusier. All rights reserved.
//

#import "SignUpViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
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
   
  
         [self.scrollview setContentSize:CGSizeMake(320,  1500)];
	// Do any additional setup after loading the view.
    blood_array = [[NSArray alloc] initWithObjects:@"O-",@"O+",@"A-",@"A+",@"B-",@"B+",@"AB-",@"AB+",nil];
       level_array = [[NSArray alloc] initWithObjects:@"Beginner(0-1year)",@"Intermediate(1-3year)",@"Advanced(3year+)", nil];
    studio_array = [[NSArray alloc] initWithObjects:@"耀龍拳館",@"拳館",@"拳館888", nil];
    
   instructor_array = [[NSArray alloc] initWithObjects:@"梁偉耀-A00106",@"李耀東-A00206",@"葉文龍-A00306", nil];
   glove_array = [[NSArray alloc] initWithObjects:@"8oz",@"10oz",@"12oz",@"14oz",@"16oz",@"18oz", nil];
   professional_array = [[NSArray alloc] initWithObjects:@"Studio Master",@"Class 1 Instructor",@"Class 2 Instructor", @"Class 3 Instructor",@"Star Fighter", @"Referee",@"Judge",nil];
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
    [user setObject:[NSString stringWithFormat:@"%@",picker1_string] forKey:@"level"];
  [user setObject:[NSString stringWithFormat:@"%@",picker2_string] forKey:@"current_studio"];
      [user setObject:[NSString stringWithFormat:@"%@",picker3_string] forKey:@"current_instructor"];
      [user setObject:[NSString stringWithFormat:@"%@",picker4_string] forKey:@"glove_size"];
      [user setObject:[NSString stringWithFormat:@"%@",picker5_string] forKey:@"professional_status"];
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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView==_picker1) {
        _picker1_lbl.text=[level_array objectAtIndex:row];
        picker1_string=[level_array objectAtIndex:row];
    }
    if (pickerView==_picker2) {
       _picker2_lbl.text=[studio_array objectAtIndex:row];
           picker2_string=[studio_array objectAtIndex:row];
    }
    if (pickerView==_picker3) {
        _picker3_lbl.text=[instructor_array objectAtIndex:row];
           picker3_string=[instructor_array objectAtIndex:row];
    }
    if (pickerView==_picker4) {
        _picker4_lbl.text=[glove_array objectAtIndex:row];
           picker4_string=[glove_array objectAtIndex:row];
    }
    else {
        _picker5_lbl.text=[professional_array objectAtIndex:row];
           picker5_string=[professional_array objectAtIndex:row];
    }
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1; // It's for second pickerview
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView==_picker1) {
        return [level_array objectAtIndex:row];
    }
    if (pickerView==_picker2) {
        return [studio_array objectAtIndex:row];
    }
    if (pickerView==_picker3) {
        return [instructor_array objectAtIndex:row];
    }

    if (pickerView==_picker4) {
        return [glove_array objectAtIndex:row];
    }

    else{
        return [professional_array objectAtIndex:row];
    }

    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView==_picker1) {
        return[level_array count]; //It's for first PickerView
        
    }
     if (pickerView==_picker2) {
        return [level_array count];
    }
    if (pickerView==_picker3) {
        return [instructor_array count];
    }
    if (pickerView==_picker4) {
        return [glove_array count];
    }
    else{
        return [professional_array count];
    }
}

#pragma mark - TextField delegate

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
- (void)showPhotoLibary
{
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)) {
        return;
    }
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Displays saved pictures from the Camera Roll album.
    mediaUI.mediaTypes = @[(NSString*)kUTTypeImage];
    
    // Hides the controls for moving & scaling pictures
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = self;
    
    [self.navigationController presentModalViewController: mediaUI animated: YES];
}

- (IBAction)change_icon:(id)sender {
    {
        [self showPhotoLibary];
        NSLog(@"...");
    
    }

}
- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {
    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _profile.image = originalImage;
    
}
@end
