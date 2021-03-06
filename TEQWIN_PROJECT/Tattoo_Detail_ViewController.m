//
//  Tattoo_Detail_ViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 29/7/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//=
#import "GalleryCell.h"
#import "Gallery.h"
#import "ImageExampleCell.h"
#import "Tattoo_Detail_ViewController.h"
#import "SWRevealViewController.h"
#import "TattooMaster_ViewController.h"
#import "Master_Map_ViewController.h"
#import "Comment.h"
#import "Map_ViewController.h"
#import "LoginUIViewController.h"
@import CoreData;
@interface Tattoo_Detail_ViewController ()

{
    int lastClickedRow;
    CGRect frame_first;
    UIImageView *fullImageView;
    
}
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;
@end

@implementation Tattoo_Detail_ViewController



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
    
    NSLog(@"%@",self.tattoomasterCell.promotion_image);
    NSLog(@"%@",self.tattoomasterCell.imageFile);
    //These two steps are important
    //   self.promot_image.frame=CGRectMake(0, 0, 320, 198   );
    self.profileimage.file=self.tattoomasterCell.imageFile;
    //320 is width
    //1000 is height. Same as the height of the View
    if ([self.tattoomasterCell.desc isEqual:@""]||self.tattoomasterCell.desc ==nil) {
        self.tattoomasterCell.desc =@"沒有簡介";
    }
 //   self.automaticallyAdjustsScrollViewInsets = NO;
    // self.desc.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    
    UIFont *font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    self.desc.font=font;
    NSString *lorum =self.tattoomasterCell.desc;
    //  self.desc.layer.cornerRadius=8.0f;
    //  self.desc.layer.borderWidth=0.0;
    self.desc.layer.borderColor =[[UIColor grayColor] CGColor];
    //for use labrect with UITextView you set the font of UITextView:
    //label.font = [UIFont systemFontOfSize:17];
    
    CGSize maxSize = CGSizeMake(320, 410);
    CGRect labrect = [lorum boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_desc.font} context:Nil];
    if ([UIScreen mainScreen].bounds.size.height ==480) {
        [self.scrollView setContentSize:CGSizeMake(320, 580+labrect.size.height+250)];
    }
    else
    {
        [self.scrollView setContentSize:CGSizeMake(320, [UIScreen mainScreen].bounds.size.height+labrect.size.height+150)];
        
    }
    NSLog(@"1%f",[UIScreen mainScreen].bounds.size.height);
    NSLog(@"2%f",labrect.size.height);
    _desc.text = lorum;
    //for use UITextView you should comment the line under
    //_desc.numberOfLines = 0;
    _desc.frame = CGRectMake(23, 355, 280, labrect.size.height+24);
    
    
    
    _profileimage.layer.cornerRadius =_profileimage.frame.size.width / 2;
    _profileimage.layer.borderWidth = 0.0f;
    _profileimage.layer.borderColor = [UIColor colorWithRed:45.0f/255.0f green:0.0f/255.0f blue:7.0f/255.0f alpha:1].CGColor;
    //_profileimage.layer.borderColor = [UIColor brownColor].CGColor;
    _profileimage.clipsToBounds = YES;
    _lblincharge.text =[NSString stringWithFormat:@"負責人：%@",self.tattoomasterCell.person_incharge];
    _lbltel.text =[NSString stringWithFormat:@"電話：%@",self.tattoomasterCell.tel];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTapped:)];
    [_lbltel addGestureRecognizer:gestureRecognizer];
    if ([self.tattoomasterCell.tel isEqual:@""]) {
        
    }
    else
    {
        _lbltel.textColor =[UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1 ];
    }
    _lblfax.text=[NSString stringWithFormat:@"FAX：%@",self.tattoomasterCell.fax];
    _lbladdress.text=[NSString stringWithFormat:@"地址：%@",self.tattoomasterCell.address];
    UITapGestureRecognizer *add_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(address_tap:)];
    [_lbladdress addGestureRecognizer:add_tap];
    if ([self.tattoomasterCell.address isEqual:@""]) {
        
    }
    else
    {
        _lbladdress.textColor =[UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1 ];
    }
    
    _lblemail.text=[NSString stringWithFormat:@"電郵：%@",self.tattoomasterCell.email];
    UITapGestureRecognizer *email_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(email_tap:)];
    [_lblemail addGestureRecognizer:email_tap];

    if ([self.tattoomasterCell.email  isEqual:@""]) {
        
    }
    else
    {
        _lblemail.textColor =[UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1 ];
    }
    _lblweb.text=[NSString stringWithFormat:@"網址：%@",self.tattoomasterCell.website];
    UITapGestureRecognizer *web_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(web_tap:)];
    [_lblweb addGestureRecognizer:web_tap];
    if ([self.tattoomasterCell.website isEqual:@""]) {
        
    }
    else
    {
        _lblweb.textColor =[UIColor colorWithRed:256.0/256.0 green:256.0/256.0 blue:256.0/256.0 alpha:1 ];
    }
    // Create ParallaxHeaderView with specified size, and set it as uitableView Header, that's it
    self.view.backgroundColor =[UIColor blackColor];
    
    
    //  self.profileimage.image=[UIImage imageNamed:@"main_background.png"];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    NSDictionary *dimensions = @{ @"name":self.tattoomasterCell.name};
    [PFAnalytics trackEvent:@"showmaster" dimensions:dimensions];
    
    self.detail_name.numberOfLines = 3;
    self.detail_name.font = [UIFont fontWithName:@"Helvetica-bold" size:17.0];
    self.detail_name.textColor =[UIColor whiteColor];
    self.detail_name.text=self.tattoomasterCell.name;
    self.tableView.bounces=NO;
    if (self.tattoomasterCell.view ==nil) {
        self.view_count.text = @"1";
    }
    else{
        self.view_count.text =[NSString stringWithFormat:@"%lu",(unsigned long)self.tattoomasterCell.view.count];
    }
    //self.view_count.text =[NSString stringWithFormat:@"%d",self.tattoomasterCell.view.count    ]   ;
    //  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.view.backgroundColor =[UIColor blackColor];
    //  self.description_textview.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    
    self.view.backgroundColor =[UIColor blackColor];
    [self queryParseMethod];
    [self queryParseMethod_image];
    [self queryParseMethod_comment];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.imagesCollection setCollectionViewLayout:flowLayout];
    flowLayout.itemSize = CGSizeMake(320  , 220);
    [flowLayout setMinimumLineSpacing:0.0f];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    /*
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [UIFont fontWithName:@"ArialMT" size:9.0], NSFontAttributeName,nil]];*/
        self.title =self.tattoomasterCell.name;
    self.count_like.text =[NSString stringWithFormat:@"%lu",(unsigned long)self.tattoomasterCell.favorites.count    ]   ;
    
    if ([self.tattoomasterCell.gender isEqualToString:@"男"]) {
        
        
        _sexy_image.image = [UIImage imageNamed:@"icon-sex-m.png"];
    }
    else
        if ([self.tattoomasterCell.gender isEqualToString:@"女"]) {
            
            _sexy_image.image = [UIImage imageNamed:@"icon-sex-f.png"];
        }
    
    //set segmented control
    if ([self.tattoomasterCell.bookmark containsObject:[PFUser currentUser].objectId]) {
        self.bookmark_image.image =[UIImage imageNamed:@"new_bookmarked.png"];
    }
    else {
        self.bookmark_image.image =[UIImage imageNamed:@"new_bookmark.png"];
    }
    
    if ([self.tattoomasterCell.favorites containsObject:[PFUser currentUser].objectId]) {
        self.fav_image.image =[UIImage imageNamed:@"new_liked.png"];
    }
    else {
        self.fav_image.image =[UIImage imageNamed:@"new_like.png"];
    }
    self.master_name.text=self.tattoomasterCell.name;
    
    
    
    
    // [ self.profileimage setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    //  [ self.profileimage setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    _tableView.bounces=NO;
    
    //self.test_images.image=self.tattoomasterCell.img;
    //
    // note: the following can be done in Interface Builder, but we show this in code for clarity
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    list =[[NSMutableArray alloc]init];
    
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.person_incharge]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.tel]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.fax]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.address]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.email]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.website]];
    
    
    
    // [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.description]];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"產品參數";
    
    
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"產品簡介";
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 32.0f;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 32)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, tableView.bounds.size.width - 10, 18)];
    label.text = @"產品參數";
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0]];
    label.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    [headerView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.17]];
    
    return headerView;
}
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 32)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, tableView.bounds.size.width - 10, 18)];
    label.text = @"產品簡介";
    [label setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15.0]];
    label.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    [headerView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.17]];
    
    return headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        
        return [list count];
        
    } else {
        
        return self.searchResults.count;
        
    }
    
}
-(void)filterResults:(NSString *)searchTerm scope:(NSString*)scope
{
    
    [self.searchResults removeAllObjects];
    
    PFQuery *query = [PFQuery queryWithClassName:@"muay_member"];
    //[query whereKey:@"Name" containsString:searchTerm];
    query.cachePolicy=kPFCachePolicyCacheElseNetwork;
    NSArray *results  = [query findObjects];
    
    
    [self.searchResults addObjectsFromArray:results];
    
    NSPredicate *searchPredicate =
    [NSPredicate predicateWithFormat:@"name CONTAINS[cd]%@", searchTerm];
    _searchResults = [NSMutableArray arrayWithArray:[results filteredArrayUsingPredicate:searchPredicate]];
    
    // if(![scope isEqualToString:@"全部"]) {
    // Further filter the array with the scope
    //   NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"Gender contains[cd] %@", scope];
    
    //  _searchResults = [NSMutableArray arrayWithArray:[_searchResults filteredArrayUsingPredicate:resultPredicate]];
}//}
//當search 更新時， tableview 就會更新，無論scope select 咩
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchTerm
{
    [self filterResults :searchTerm
                   scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                          objectAtIndex:[self.searchDisplayController.searchBar
                                         selectedScopeButtonIndex]]];
    
    return YES;
}
- (void)queryParseMethod_comment {
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query whereKey:@"muay_id" equalTo:self.tattoomasterCell.muay_id];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            
        }
        if (!error) {
            comment_count = [[NSArray alloc] initWithArray:objects];
            

            self.comment_count.text =[NSString stringWithFormat:@"%lu",(unsigned long)[comment_count count]];
        }
    }];
}
- (void)queryParseMethod {
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"muay_member"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query whereKey:@"muay_id" equalTo:self.tattoomasterCell.muay_id];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            
        }
        if (!error) {
            imageFilesArray = [[NSArray alloc] initWithArray:objects];
            for (PFObject *object in imageFilesArray) {
                PFFile *imageFile = [object objectForKey:@"promotion_image"];
                if (imageFile==nil) {
                    self.promot_image.image=[UIImage imageNamed:@"muay_banner6.png" ];
                }
                else{
                    self.promot_image.image = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext() ;
                    
                    // cell.parseImage.image = [UIImage imageNamed:@"background.jpg"];
                    
                    self.promot_image.file = imageFile;
                    
                    // UIGraphicsEndImageContext();
                    [self.promot_image loadInBackground];
                }
            }}
        
    }];
    
    
}

- (void)queryParseMethod_image{
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"photo"];
    [query whereKey:@"muay_id" equalTo:self.tattoomasterCell.muay_id];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count ==0) {
                
                self.noimageview.image=[UIImage imageNamed:@"main_background.png"];
                
                
            }
            else{
                imageFilesArray_image = [[NSArray alloc] initWithArray:objects];
                
                
                self.noimage.text=@"";
                
                self.noimageview.image=[UIImage imageNamed:@""];
                
                [_imagesCollection reloadData];
            }}
    }];
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imageFilesArray_image count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    static NSString *cellIdentifier = @"imageCell";
    ImageExampleCell *cell = (ImageExampleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    // cell.detailimage.image =[UIImage imageNamed:@"image_icon.png"];
    imageObject = [imageFilesArray_image objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"image"];
    cell.loading.hidden = NO;
    [cell.loading startAnimating];
    
    
    
    cell.detailimage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext() ;

    
    cell.detailimage.file = imageFile;
    
    [   cell.detailimage loadInBackground];
    
    
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
//按圖第一下放大至fullscreen
////按圖第二下縮回原型



- (CGFloat) tableView: (UITableView*) tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath
{ NSString *cellText = [list objectAtIndex:indexPath.row];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:cellText
     attributes:@
     {
     NSFontAttributeName: cellFont
     }];
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(tableView.bounds.size.width, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    return rect.size.height + 30;
    
    
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width,999);//(phoneCellHeight*phoneList.count)
    
    
    static NSString *identifier =@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    }
    if (tableView == self.tableView) {
        
        switch (indexPath.row) {
                
                
                
            case 0:
                
            {
                cell.detailTextLabel.textColor =[UIColor whiteColor];
                [cell.detailTextLabel setNumberOfLines:5];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                [cell.textLabel setNumberOfLines:2];
                cell.textLabel.text = @"負責人：";
            }
                
                break;
            case 1:
                
            {
                
                [cell.detailTextLabel setNumberOfLines:5];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
                cell.detailTextLabel.textColor=[UIColor whiteColor];
                cell.textLabel.text = @"電話：";
                //cell.accessoryType=UITableViewCellAccessoryDetailButton;
            }
                
                break;
                
            case 2:
                
            {
                
                cell.detailTextLabel.textColor =[UIColor whiteColor];
                [cell.detailTextLabel setNumberOfLines:6];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                [cell.textLabel setNumberOfLines:30];
                cell.textLabel.text = @"Fax：";
                
            }
                break;
                
            case 3:
                
            {
                [cell.detailTextLabel setNumberOfLines:7];
                [cell.detailTextLabel setNumberOfLines:20];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15 ];
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
                cell.detailTextLabel.textColor=[UIColor whiteColor];
                cell.textLabel.text = @"地址：";
                //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                // cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
            }
                
                break;
            case 4:
                
            {
                [cell.detailTextLabel setNumberOfLines:5];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
                cell.detailTextLabel.textColor=[UIColor whiteColor];
                cell.textLabel.text = @"電郵：";
                //cell.accessoryType=UITableViewCellAccessoryDetailButton;
            }
                
                break;
            case 5:
                
            {
                
                [cell.detailTextLabel setNumberOfLines:5];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:14];
                cell.detailTextLabel.textColor=[UIColor whiteColor];
                cell.textLabel.text = @"網址：";
                //cell.accessoryType=UITableViewCellAccessoryDetailButton;
            }
                
                break;
                
                
                
                //  }
                
                //     break;
                //  case 7:
                
                //  {
                //      cell.detailTextLabel.textColor =[UIColor whiteColor];
                //    [cell.detailTextLabel setNumberOfLines:5];
                //     cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                //     cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                //      cell.textLabel.text = @"Description：";
                
                
                // }
        }
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.detailTextLabel.text =[list objectAtIndex:indexPath.row];
        
        cell.contentView.backgroundColor = [UIColor blackColor];
        
        
        
    }
    
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copy:));
    
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:))
        [UIPasteboard generalPasteboard].string = [list objectAtIndex:indexPath.row];
}



- (void) likeImage {
    
    [object addUniqueObject:[PFUser currentUser].objectId forKey:@"favorites"];
    
    [object saveInBackground];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            //[self likedSuccess];
            self.isFav = YES;
        }
        else {
            [self likedFail];
        }
    }];
}
- (void) dislike {
    [object removeObject:[PFUser currentUser].objectId forKey:@"favorites"];
    [object saveInBackground];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // [self dislikedSuccess];
            self.isFav = NO;
            
        }
        else {
            [self dislikedFail];
        }
    }];
}
- (void) dislikedSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"已經取消我的最愛" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) dislikedFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:@"失敗" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) likedSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"You have succesfully liked the image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) likedFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:@"There was an error when liking the image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView) {
        
        switch (indexPath.row) {
            case 1:
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"撥號"
                                                                message:@"確定要撥號嗎？"
                                                               delegate:self
                                                      cancelButtonTitle:@"否"
                                                      otherButtonTitles:@"是",nil];
                //然后这里设定关联，此处把indexPath关联到alert上
                
                [alert show];
                
                
                
            }
                break;
                
                
            case 3:{
                Map_ViewController * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Map_ViewController"];
                [self.navigationController pushViewController:mapVC animated:YES];
                mapVC.tattoomasterCell=_tattoomasterCell;
                
            }
                break;
            case 5:{
                
                
                NSURL *url = [NSURL URLWithString:self.tattoomasterCell.website ];
                [[UIApplication sharedApplication] openURL:url];
                
            }
                break;
            case 4:
                //Create the MailComposeViewController
                
            {
                MFMailComposeViewController *Composer = [[MFMailComposeViewController alloc]init];
                
                Composer.mailComposeDelegate = self;
                // email Subject
                [Composer setSubject:self.tattoomasterCell.name];
                //email body
                // [Composer setMessageBody:self.selectedTattoo_Master.name isHTML:NO];
                //recipient
                [Composer setToRecipients:[NSArray arrayWithObjects:self.tattoomasterCell.email, nil]];            //get the filePath resource
                
                // NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ive" ofType:@"png"];
                
                //Read the file using NSData
                
                //   NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                
                // NSString *mimeType = @"image/png";
                
                //Add attachement
                
                //  [Composer addAttachmentData:fileData mimeType:mimeType fileName:filePath];
                
                //Present it on the screen
                
                [self presentViewController:Composer animated:YES completion:nil];
            }
                break;
                
                //make alert box and phonecall function
        }}
    else {
        
        PFObject* selectobject = [_searchResults  objectAtIndex:indexPath.row];
        Tattoo_Detail_ViewController * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Tattoo_Detail_ViewController"];
        [self.navigationController pushViewController:mapVC animated:YES];
        TattooMasterCell * tattoomasterCell = [[TattooMasterCell alloc] init];
        tattoomasterCell.object_id = [selectobject objectForKey:@"object"];
        tattoomasterCell.muay_id = [selectobject objectForKey:@"muay_id"];
        tattoomasterCell.name = [selectobject objectForKey:@"name"];
        tattoomasterCell.person_incharge=[selectobject objectForKey:@"person_incharge"];
        tattoomasterCell.gender=[selectobject objectForKey:@"gender"];
        tattoomasterCell.imageFile=[selectobject objectForKey:@"image"];
        tattoomasterCell.tel = [selectobject objectForKey:@"tel"];
        tattoomasterCell.fax = [selectobject objectForKey:@"fax"];
        tattoomasterCell.address = [selectobject objectForKey:@"address"];
        tattoomasterCell.latitude = [selectobject objectForKey:@"latitude"];
        tattoomasterCell.longitude = [selectobject objectForKey:@"longitude"];
        tattoomasterCell.email = [selectobject objectForKey:@"email"];
        tattoomasterCell.website = [selectobject objectForKey:@"website"];
        tattoomasterCell.desc = [selectobject objectForKey:@"desc"];
        tattoomasterCell.imageFile = [selectobject objectForKey:@"image"];
        tattoomasterCell.promotion_image=[object objectForKey:@"promotion_image"];
        tattoomasterCell.favorites = [selectobject objectForKey:@"favorites"];
        tattoomasterCell.bookmark =[selectobject objectForKey:@"bookmark"];
        tattoomasterCell.view = [selectobject objectForKey:@"view"];
        tattoomasterCell.object_id = selectobject.objectId;
        
        mapVC.tattoomasterCell = tattoomasterCell;
    }
    
}
//- (IBAction)getDirectionButtonPressed:(id)sender {
// UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Get Direction"
//                                                     message:@"Go to Maps?"
//                                                  delegate:self
//                                         cancelButtonTitle:@"取消"
//                                         otherButtonTitles:@"確定", nil];
// alertView.delegate = self;
//[alertView show];
//}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error

{
    switch (result) {
        case MFMailComposeResultCancelled:
            
            break;
            
        case MFMailComposeResultSaved:
            
            
            break;
            
        case MFMailComposeResultSent:
            break;
            
        case MFMailComposeResultFailed:
            
            
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
    if([button isEqualToString:@"是"])
    {
        NSString *phNo =self.tattoomasterCell.tel;
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",phNo]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else
        {
            UIAlertView*  calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [calert show];
        }
        
        
    }
    if([button isEqualToString:@"確定"])
    { LoginUIViewController * loginvc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginUIViewController"];
        [self.navigationController pushViewController:loginvc animated:YES];
        
        
    }
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"GOGALLERY"]) {
        
        
        if ([segue.destinationViewController isKindOfClass:[Gallery class]]){
            NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
            Gallery *receiver = (Gallery*)segue.destinationViewController;
            receiver.tattoomasterCell=_tattoomasterCell;
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    if ([segue.identifier isEqualToString:@"GOGALLERY_collection"]) {
        
        
        if ([segue.destinationViewController isKindOfClass:[Gallery class]]){
            self.tattoomasterCell.clickindexpath = [self.imagesCollection indexPathForCell:sender];
            Gallery *receiver = (Gallery*)segue.destinationViewController;
            receiver.tattoomasterCell=_tattoomasterCell;
            
            [self.tableView deselectRowAtIndexPath:self.tattoomasterCell.clickindexpath animated:NO];
        }
    }
    if ([segue.identifier isEqualToString:@"showcomment"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Comment *destViewController = segue.destinationViewController;
        
        PFObject *object_comment = [imageFilesArray objectAtIndex:indexPath.row];
        TattooMasterCell *tattoomasterCell = [[TattooMasterCell alloc] init];
        
        tattoomasterCell.object_id = [object_comment objectForKey:@"object"];
        tattoomasterCell.muay_id = [object_comment objectForKey:@"muay_id"];
        tattoomasterCell.name = [object_comment objectForKey:@"name"];
        tattoomasterCell.person_incharge=[object_comment objectForKey:@"person_incharge"];
        tattoomasterCell.gender=[object_comment objectForKey:@"gender"];
        tattoomasterCell.imageFile =[object_comment objectForKey:@"image"];
        tattoomasterCell.tel = [object_comment objectForKey:@"tel"];
        tattoomasterCell.fax = [object_comment objectForKey:@"fax"];
        tattoomasterCell.address = [object_comment objectForKey:@"address"];
        tattoomasterCell.latitude = [object_comment objectForKey:@"latitude"];
        tattoomasterCell.longitude = [object_comment objectForKey:@"longitude"];
        tattoomasterCell.email = [object_comment objectForKey:@"email"];
        tattoomasterCell.website = [object_comment objectForKey:@"website"];
        tattoomasterCell.desc = [object_comment objectForKey:@"desc"];
        tattoomasterCell.imageFile = [object_comment objectForKey:@"image"];
        tattoomasterCell.promotion_image=[object_comment objectForKey:@"promotion_image"];
        tattoomasterCell.favorites = [object_comment objectForKey:@"favorites"];
        tattoomasterCell.bookmark =[object_comment objectForKey:@"bookmark"];
        tattoomasterCell.view = [object_comment objectForKey:@"view"];
        tattoomasterCell.object_id = object_comment.objectId;
        destViewController.tattoomasterCell = tattoomasterCell;
        //  NSInteger myInteger = [tattoomasterCell.view integerValue];
        //  object[@"view"] =[NSNumber numberWithFloat:(myInteger+ 1)];
        //  [object saveInBackground];
        NSLog(@"vvv%@",[object_comment objectForKey:@"muay_id"]);
        
        
        [object addUniqueObject:[PFInstallation currentInstallation].objectId forKey:@"view"];
        [object saveInBackground];
    }
    

}


- (IBAction)favButton:(id)sender {
    if ([PFUser currentUser]) {
        
        UIButton* button = sender;
        CGPoint correctedPoint =
        [button convertPoint:button.bounds.origin toView:self.tableView];
        NSIndexPath* indexPath =  [self.tableView indexPathForRowAtPoint:correctedPoint];
        object = [imageFilesArray objectAtIndex:indexPath.row];
        imageObject = [imageFilesArray objectAtIndex:indexPath.row];
        lastClickedRow = indexPath.row;
        object = [imageFilesArray objectAtIndex:indexPath.row];
        
        
        if ([[object objectForKey:@"favorites"]containsObject:[PFUser currentUser].objectId]) {
            
            [self dislike];
            
            self.fav_image.image =[UIImage imageNamed:@"new_like.png"];
            
        }
        
        else{
            
            
            [self likeImage];
            
            self.fav_image.image =[UIImage imageNamed:@"new_liked.png"];
            
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"尚未登入"
                                                        message:@"需要進入登入頁嗎？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"確定",nil];
        //然后这里设定关联，此处把indexPath关联到alert上
        
        [alert show];
        ; }
    [self.tableView reloadData];
}


- (IBAction)bookmarkbtn:(id)sender {
    if ([PFUser currentUser]) {
        
        UIButton* button = sender;
        CGPoint correctedPoint =
        [button convertPoint:button.bounds.origin toView:self.tableView];
        NSIndexPath* indexPath =  [self.tableView indexPathForRowAtPoint:correctedPoint];
        object = [imageFilesArray objectAtIndex:indexPath.row];
        imageObject = [imageFilesArray objectAtIndex:indexPath.row];
        lastClickedRow = indexPath.row;
        object = [imageFilesArray objectAtIndex:indexPath.row];
        
        
        
        if ([[object objectForKey:@"bookmark"]containsObject:[PFUser currentUser].objectId]) {
            
            [self nobookmark];
            
            self.bookmark_image.image =[UIImage imageNamed:@"new_bookmark.png"];
            
        }
        
        else{
            
            
            [self bookmark];
            
            
            self.bookmark_image.image =[UIImage imageNamed:@"new_bookmarked.png"];
            
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"尚未登入"
                                                        message:@"需要進入登入頁嗎？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"確定",nil];
        //然后这里设定关联，此处把indexPath关联到alert上
        
        [alert show];
        
        
        ; }
    [self.tableView reloadData];
}
- (void) bookmark {
    
    [object addUniqueObject:[PFUser currentUser].objectId forKey:@"bookmark"];
    
    [object saveInBackground];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            //[self likedSuccess];
            self.isbookmark = YES;
        }
        else {
            [self bookmarkFail];
        }
    }];
}
- (void) nobookmark {
    [object removeObject:[PFUser currentUser].objectId forKey:@"bookmark"];
    [object saveInBackground];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // [self dislikedSuccess];
            self.isbookmark = NO;
            
        }
        else {
            [self nobookmarkFail];
        }
    }];
}
- (void) nobookmarkSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"已經取消我的最愛" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) nobookmarkFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:@"失敗" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) bookmarkSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"已經成功加入我的最愛" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) bookmarkFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:@"失敗" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


- (IBAction)showsearch:(id)sender {
    [_detailsearchbar becomeFirstResponder];}
-(void)textViewTapped:(UITapGestureRecognizer *)sender{
    if ([self.tattoomasterCell.tel  isEqual:@""]) {
        [sender setEnabled:NO];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"撥號"
                                                        message:@"確定要撥號嗎？"
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是",nil];
        //然后这里设定关联，此处把indexPath关联到alert上
        
        [alert show];
    }

    
    
}
- (IBAction)btn_tel:(id)sender {
    if ([self.tattoomasterCell.tel  isEqual:@""]) {
        [sender setEnabled:NO];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"撥號"
                                                        message:@"確定要撥號嗎？"
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是",nil];
        //然后这里设定关联，此处把indexPath关联到alert上
        
        [alert show];
    }
}
-(void)address_tap:(UITapGestureRecognizer *)sender{
    if ([self.tattoomasterCell.address  isEqual:@""]) {
        [sender setEnabled:NO];
        
    }
    else{
        Map_ViewController * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Map_ViewController"];
        [self.navigationController pushViewController:mapVC animated:YES];
        mapVC.tattoomasterCell=_tattoomasterCell;
    }

    
}
-(void)web_tap:(UITapGestureRecognizer *)sender{
    if ([self.tattoomasterCell.website  isEqual:@""]) {
        [sender setEnabled:NO];
        
    }
    else{
        //   NSURL *url = [NSURL URLWithString:self.tattoomasterCell.website ];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.tattoomasterCell.website ]];
        
    }
}


- (IBAction)btn_address:(id)sender {
    
  }
-(void)email_tap:(UITapGestureRecognizer *)sender{
    //Create the MailComposeViewController
    if ([self.tattoomasterCell.email   isEqual:@""]) {
        [sender setEnabled:NO];
        
    }
    else{
        {
            MFMailComposeViewController *Composer = [[MFMailComposeViewController alloc]init];
            
            Composer.mailComposeDelegate = self;
            // email Subject
            [Composer setSubject:self.tattoomasterCell.name];
            //email body
            // [Composer setMessageBody:self.selectedTattoo_Master.name isHTML:NO];
            //recipient
            [Composer setToRecipients:[NSArray arrayWithObjects:self.tattoomasterCell.email, nil]];            //get the filePath resource
            
            // NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ive" ofType:@"png"];
            
            //Read the file using NSData
            
            //   NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            
            // NSString *mimeType = @"image/png";
            
            //Add attachement
            
            //  [Composer addAttachmentData:fileData mimeType:mimeType fileName:filePath];
            
            //Present it on the screen
            
            [self presentViewController:Composer animated:YES completion:nil];
        }
    }
}
- (IBAction)btn_email:(id)sender {
    }

- (IBAction)btn_web:(id)sender {
   }
@end
