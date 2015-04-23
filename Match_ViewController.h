//
//  TattooMaster_ViewController.h
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 28/7/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MatchCell.h"
#import "ImageCell.h"
#import <Parse/Parse.h>
#import "CustomIOSAlertView.h"
@interface Match_ViewController : PFQueryTableViewController<CustomIOSAlertViewDelegate>
{
    NSArray * object_array;
    PFObject *object_link;
    NSString*LINK;
    NSArray *bannerarray;
    NSArray *imageFilesArray;
    NSMutableArray *imagesArray;
    PFObject *selectobject;
    PFObject *searchedobject;
    NSArray * count;
    PFFile * clubfile;
    PFObject * object_id;
    PFImageView *heart_statues;
    PFImageView *sex_statues;
    NSIndexPath *indexPath;
    NSArray*imageFilesArray_image;
    PFQuery * searchquery;
    PFObject *installid;
     PFQuery * boxersquery;
         NSArray * boxer_array;
    UIButton *gallary_button;
    PFImageView *gallary_image;
    UIView *demoView;
    NSString * RANDOM;
    int r;

    PFObject * banobject;
 

    PFObject *bannerobject;


  
    
}

- (IBAction)ADDAD:(id)sender;
- (IBAction)gobannersite:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedcontroller;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
- (IBAction)showsearch:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSearch;

@property (nonatomic, assign) BOOL islink;
- (IBAction)gogallery:(id)sender;

@property (nonatomic, assign) BOOL isFav;



@property (strong,nonatomic) NSMutableArray *filteredCandyArray;

@property (strong, nonatomic) IBOutlet UITableView *table_view;

@end
