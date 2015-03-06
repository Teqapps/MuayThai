//
//  detail_news_ViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 5/11/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "Gallery.h"
#import "GalleryCell.h"
#import "detail_news_ViewController.h"
#import "SWRevealViewController.h"
@interface detail_news_ViewController ()
{
         UIImageView *fullImageView;
}
@end

@implementation detail_news_ViewController

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
    [self queryParseMethod_2];
    
    NSDictionary *dimensions = @{ @"name":self.tattoomasterCell.name};
    [PFAnalytics trackEvent:@"show_detai_news" dimensions:dimensions];
    self.title =@"詳細";

    
    self.news_detail.text=self.tattoomasterCell.news;
    self.news_detail.layer.cornerRadius=8.0f;
    self.news_detail.layer.borderWidth=0.0;
    self.news_detail.layer.borderColor =[[UIColor grayColor] CGColor];
    CGRect frame =  self.news_detail.frame;
    frame.size.height =  self.news_detail.contentSize.height;
    self.news_detail.frame = frame;
    [ self.news_detail sizeToFit];
    [self.news_detail setScrollEnabled:NO];
    self.news_detail.dataDetectorTypes = UIDataDetectorTypeLink;

    
    if (self.tattoomasterCell.news_view ==nil) {
        self.view_count.text = @"1";
    }
    else{
        self.view_count.text =[NSString stringWithFormat:@"%lu",(unsigned long)self.tattoomasterCell.news_view.count];
    }
    self.name.text =self.tattoomasterCell.name;
    _news_detail.text=self.tattoomasterCell.news;
    self.profile_image.file=self.tattoomasterCell.imageFile;
    self.profile_image.layer.cornerRadius =self.profile_image.frame.size.width / 2;
    self.profile_image.layer.masksToBounds = YES;
    self.profile_image.layer.borderWidth = 0.0f;
    self.profile_image.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.profile_image.clipsToBounds = YES;
    
}
- (void)viewWillAppear:(BOOL)animated {
    // self.screenName = @"Main";
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    // self.page.numberOfPages = [imageFilesArray count];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)queryParseMethod_2 {
    NSLog(@"start query");
    
    PFQuery *query = [PFQuery queryWithClassName:@"muay_member"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query whereKey:@"muay_id" equalTo:self.tattoomasterCell.muay_id];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            
        }
        if (!error) {
            NSArray * array;
            array = [[NSArray alloc] initWithArray:objects];
             imageFilesArray = [[NSArray alloc] initWithArray:objects];
            for (PFObject *object in objects) {
                
                _profile_image.file =[object objectForKey:@"image"];
                [_profile_image.file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    // self.profileimage.file=self.tattoomasterCell.imageFile;
                    
                    _profile_image.image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    _profile_image.image = [UIImage imageWithData:data];
                }];
            }
            [_tableview    reloadData];
}
    }];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
    
}

- (void) noimage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"對不起" message:@"沒有照片" delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
    [alert show];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"parallaxCell";
    GalleryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    PFObject *imageObject = [imageFilesArray objectAtIndex:indexPath.row];
    
    imageFile = [imageObject objectForKey:@"news_image"];
   
    cell.loadingSpinner.hidden = NO;
    [cell.loadingSpinner startAnimating];
    cell.news_image.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //cell.image.layer.borderWidth=1.0;
    cell.news_image.layer.masksToBounds = YES;
    // cell.image.layer.borderColor=[[UIColor colorWithRed:176.0/255.0
    //                 green:147.0/255.0 blue:78/255.0 alpha:1.0]CGColor];
    cell.news_image.layer.borderColor=[[UIColor grayColor]CGColor];
    cell.news_image.file = imageFile;
    
    [ cell.news_image loadInBackground];
    
    [cell.loadingSpinner stopAnimating];
    cell.loadingSpinner.hidden = YES;
    
    cell.news_image.tag=9999;
    cell.news_image.userInteractionEnabled=YES;
    if ( imageFile==nil) {
        _tableview.allowsSelection = NO;
           }
    else {
        [ cell.news_image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bigButtonTapped:)]];

    }
        cell.contentView.backgroundColor =[UIColor clearColor];
    return cell;
}
- (void)bigButtonTapped:(id)sender {
    CGPoint location = [sender locationInView:self.tableview];
    NSIndexPath *indexPath  = [self.tableview indexPathForRowAtPoint:location];
    
    UITableViewCell *cell = (UITableViewCell *)[self.tableview  cellForRowAtIndexPath:indexPath];
    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:9999];
    // Create image info
    fullImageView.image=imageView.image;
    
    
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = imageView.image;
    //  imageInfo.image =[UIImage imageNamed:@"login.png"];
    imageInfo.referenceRect = imageView.frame;
    imageInfo.referenceView = imageView.superview;
    imageInfo.referenceContentMode = imageView.contentMode;
    imageInfo.referenceCornerRadius = imageView.layer.cornerRadius;
    
    
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
