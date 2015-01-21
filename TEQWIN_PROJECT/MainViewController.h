//
//  ViewController.h
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "TattooMasterCell.h"
//#import "GAITrackedViewController.h"
@protocol passNames <NSObject>


@end
@interface MainViewController : UIViewController 
{
     PFObject *selectobject;
    NSArray *news_array;
    NSArray *imageFilesArray;
    NSMutableArray *imagesArray;
      PFQuery * searchquery;
 
}

- (IBAction)fblike:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIPageControl *page;

@property (nonatomic, strong) TattooMasterCell *tattoomasterCell;
@property (weak, nonatomic) IBOutlet PFImageView *main_image;
@property (weak, nonatomic) IBOutlet UICollectionView *image_collection;
@property (weak, nonatomic) IBOutlet UITableView *main_tableview;
@property (weak, nonatomic) IBOutlet UIButton *home_news;
@property (weak, nonatomic) IBOutlet UIButton *home_branchs;
@property (weak, nonatomic) IBOutlet UIButton *home_profile;
@property (weak, nonatomic) IBOutlet UIButton *home_history;
@property (weak, nonatomic) IBOutlet UIButton *home_notice;
@property (weak, nonatomic) IBOutlet UIButton *home_contact;

@property (weak, nonatomic) IBOutlet UINavigationItem *navigationbar;

@end
