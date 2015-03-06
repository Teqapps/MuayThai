//
//  NewRecipeViewController.h
//  RecipeBook
//
//  Created by Simon on 10/8/13.
//
//
#import "TattooMasterCell.h"
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import  <ParseFacebookUtils/PFFacebookUtils.h>

@interface NewRecipeViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate , FBLoginViewDelegate>
{
    NSString *name;
    UIImageView *PROFILE;
    UIImage *imageToShare;
}
@property (weak, nonatomic) IBOutlet UITextView *comment_content;
@property (nonatomic, strong) TattooMasterCell *tattoomasterCell;
@end
