//
//  NewRecipeViewController.m
//  RecipeBook
//
//  Created by Simon on 10/8/13.
//
//

#import "NewRecipeViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import <ParseUI/ParseUI.h>
#import <FacebookSDK/FacebookSDK.h>
@interface NewRecipeViewController ()
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *prepTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *ingredientsTextField;
@property (weak, nonatomic) IBOutlet UITextField *comment;

@end

@implementation NewRecipeViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
    UIImage *image = [UIImage imageNamed:@"background_news.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.tableView.backgroundColor = [UIColor clearColor];
    // Add image view on top of table view
    [self.tableView addSubview:imageView];
    
    // Set the background view of the table view
    self.tableView.backgroundView = imageView;
    _comment_content.layer.borderWidth = 1.0f;
    
    _comment_content.layer.borderColor = [[UIColor grayColor] CGColor];
    NSLog(@"XXSXX%@",self.tattoomasterCell.muay_id);
    PFQuery *pfuser = [PFUser query];

     pfuser.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    // bookmarkquery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [pfuser findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
           
        }
        if (!error) {
                      
        }
    }];

    PFObject *email = [PFObject objectWithClassName:@"User"];
    if ([PFUser currentUser][@"profile"][@"name"]==nil) {
        name = [PFUser currentUser].username;
        NSLog(@"namme%@",name);
    }
    else if ([PFUser currentUser][@"profile"][@"name"] !=nil) {
        
        name = [PFUser currentUser][@"profile"][@"name"];
        NSLog(@"namme%@",name);
    }
    
    NSLog(@"%@kiki",[PFUser currentUser][@"profile"][@"pictureURL"]);
    
     self.title=@"留言";
    _nameTextField.delegate = self;
    _prepTimeTextField.delegate = self;
    _ingredientsTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self showPhotoLibary];
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


- (IBAction)save:(id)sender {


    // Create PFObject with recipe information
    PFObject *recipe = [PFObject objectWithClassName:@"Comment"];
     [recipe setObject:name forKeyedSubscript:@"username"];
 [recipe setObject:self.tattoomasterCell.muay_id forKey:@"muay_id"];
    [recipe setObject:_comment_content.text forKey:@"content"];
      [recipe setObject:[PFUser currentUser].objectId forKey:@"userid"];
    

      if ([PFUser currentUser][@"imageFile"]!=nil) {
      
         PFFile *pffile = [PFUser currentUser][@"imageFile"];
            NSLog(@"on9jai%@",pffile.url);
      
            [pffile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
              imageToShare = [UIImage imageWithData:data];
                NSData * imageData1 =UIImageJPEGRepresentation(imageToShare, 0.3);
                NSString *filename1 = [NSString stringWithFormat:@"%@.png", @"image"];
                PFFile *imageFile1 = [PFFile fileWithName:filename1 data:imageData1];
            
                [recipe setObject:imageFile1 forKey:@"profile_image"];
                // Recipe image
                               // Show progress
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.labelText = @"Uploading";
                [hud show:YES];

                [recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [hud hide:YES];
                    
                    if (!error) {
                        // Show success message
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"完成" message:@"成功留言" delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil, nil];
                        [alert show];
                        
                        // Notify table view to reload the recipes from Parse cloud
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                        
                        // Dismiss the controller
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    } else {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"留言失敗" message:[error localizedDescription] delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil, nil];
                        [alert show];
                        
                    }
                    
                }];

            }];
          
          
          
          
      
      }
    
   else if ([PFUser currentUser][@"imageFile"]==nil) {
        
      
            UIImage * ICONIMAGE;
            ICONIMAGE=[UIImage imageNamed:@"ICON.png"];
            NSData * imageData1 =UIImageJPEGRepresentation(ICONIMAGE, 0.3);

            NSString *filename1 = [NSString stringWithFormat:@"%@.png", @"image"];
            PFFile *imageFile1 = [PFFile fileWithName:filename1 data:imageData1];
            
            [recipe setObject:imageFile1 forKey:@"profile_image"];
           
            // Show progress
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"Uploading";
            [hud show:YES];
            
            [recipe saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [hud hide:YES];
                
                if (!error) {
                    // Show success message
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"完成" message:@"成功留言" delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    // Notify table view to reload the recipes from Parse cloud
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
                    
                    // Dismiss the controller
                       [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"留言失敗" message:[error localizedDescription] delegate:self cancelButtonTitle:@"確認" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
                
            }];
            


   }
  
      }

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)viewDidUnload {
    [self setRecipeImageView:nil];
    [self setNameTextField:nil];
    [self setPrepTimeTextField:nil];
    [self setIngredientsTextField:nil];
    [super viewDidUnload];
}


- (void) imagePickerController: (UIImagePickerController *) picker didFinishPickingMediaWithInfo: (NSDictionary *) info {

    UIImage *originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    self.recipeImageView.image = originalImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
