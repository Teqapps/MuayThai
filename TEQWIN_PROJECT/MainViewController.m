//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//
#import "ImageExampleCell.h"
#import "LoginUIViewController.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "Tattoo_Detail_ViewController.h"
#import "TattooMasterCell.h"
#import "detail_news_ViewController.h"
//#import "news_detail_ViewController.h"
@interface MainViewController ()

{
     int lastClickedRow;

    NSArray *_feedItems;

   
}
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;


@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        //然后这里设定关联，此处把indexPath关联到alert上
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"需要登入嗎？"
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是",nil];
        
        [alert show];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else   {
        
        // app already launched
    }

      UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
     
    self.navigationItem.backBarButtonItem = backButton;
   
    // scroll search bar out of sight
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    [self.image_collection setCollectionViewLayout:flowLayout];
    
    flowLayout.itemSize = CGSizeMake(320, 163);
    
    [flowLayout setMinimumLineSpacing:0.0f];

   // [flowLayout setMinimumLineSpacing:0.0f];
  
   // int randomImgNumber = arc4random_uniform(5);

   // PFObject *object = [imageFilesArray objectAtIndex:randomImgNumber];

    
    self.title = @"主頁";
//self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.view.backgroundColor = [UIColor blackColor];
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    //  self.screenName = @"Main";
    searchquery = [PFQuery queryWithClassName:@"muay_member"];
    //[query whereKey:@"Name" containsString:searchTerm];
    searchquery.cachePolicy=kPFCachePolicyNetworkElseCache;
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
   }



- (void)viewWillAppear:(BOOL)animated {
    [self queryParseMethod];
   

  //  self.screenName = @"Main";
        searchquery = [PFQuery queryWithClassName:@"muay_member"];
    //[query whereKey:@"Name" containsString:searchTerm];
    searchquery.cachePolicy=kPFCachePolicyNetworkElseCache;
 [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}
-(void)itemsDownloaded:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    _feedItems = items;
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
    if([button isEqualToString:@"是"])
    {
        LoginUIViewController * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginUIViewController"];
        [self.navigationController pushViewController:mapVC animated:YES];
        
        
    }
}

- (void)queryParseMethod {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"muay_member"];
    
   // query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:@"promotion_approve" equalTo:[NSNumber numberWithBool:YES]];
    
     [query orderByAscending:@"muay_id"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        }
        if (!error) {
            
            imageFilesArray = [[NSArray alloc] initWithArray:objects];
             self.page.numberOfPages = imageFilesArray.count;
           [_image_collection reloadData];

            [hud hide:YES];

        }
   
    }];


}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
      // return @"最新消息";
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor grayColor];
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if (tableView == self.main_tableview) {
        
    return [news_array count];
        
    } else {

        return self.searchResults.count;
        
    }
}

-(void)filterResults:(NSString *)searchTerm scope:(NSString*)scope
{

    [self.searchResults removeAllObjects];
    
    
    
    NSArray *results  = [searchquery findObjects];
    searchquery.cachePolicy=kPFCachePolicyCacheElseNetwork;
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



 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    static NSString *simpleTableIdentifier = @"favcell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    if (tableView == self.main_tableview) {
    // Configure the cell
    // Configure the cell
    PFObject *imageObject = [news_array objectAtIndex:indexPath.row];
    PFFile *thumbnail = [imageObject objectForKey:@"image"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
 //  CGSize itemSize = CGSizeMake(70, 70);
   // UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
  //  CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
  //  thumbnailImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
  //  thumbnailImageView.layer.cornerRadius=thumbnailImageView.frame.size.width/2;
    thumbnailImageView.layer.borderWidth=2.0;
  //  thumbnailImageView.layer.masksToBounds = YES;
    thumbnailImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
 //   [thumbnailImageView.image drawInRect:imageRect];
    thumbnailImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    thumbnailImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    
    thumbnailImageView.file = thumbnail;


    [thumbnailImageView loadInBackground];
    
    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
    nameLabel.text = [imageObject objectForKey:@"name"];
    
    UILabel *news = (UILabel*) [cell viewWithTag:155];
      
    news.text = [imageObject objectForKey:@"news"];
        news.textColor =[UIColor colorWithRed:196/255.0
                                        green:160/255.0 blue:81/255.0 alpha:1.0];

       // news.textColor =[UIColor grayColor];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        PFObject* object = self.searchResults[indexPath.row];
        
        
        if ([[object objectForKey:@"favorites"]containsObject:[PFUser currentUser].objectId]) {
            cell.imageView.image = [UIImage imageNamed:@"icon-liked.png"];
            
        }
        else
        {
            
            cell.imageView.image = [UIImage imageNamed:@"icon-like.png"];
        }
       
        cell.textLabel.text = [object objectForKey:@"name"];
        cell.detailTextLabel.text =[object objectForKey:@"person_incharge"];
        
    }

      return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.image_collection.frame.size.width;
    self.page.currentPage = self.image_collection.contentOffset.x / pageWidth;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imageFilesArray count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellIdentifier = @"imageCell";
    ImageExampleCell *cell = (ImageExampleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.parseImage.image=[UIImage imageNamed:@"main_background.png"];
    cell.thumbnail.image=[UIImage imageNamed:@"image_icon.png"];
    PFObject *imageObject = [imageFilesArray objectAtIndex:indexPath.row];
      PFFile *avstar = [imageObject objectForKey:@"image"];
    
    UILabel *name = (UILabel*) [cell viewWithTag:166];
    name.text = [imageObject objectForKey:@"name"];
    
   
    PFFile *imageFile = [imageObject objectForKey:@"promotion_image"];
    cell.loadingSpinner.hidden = NO;
    [cell.loadingSpinner startAnimating];

    CGSize itemSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    /*
    cell.thumbnail.layer.backgroundColor=[[UIColor clearColor] CGColor];
    cell.thumbnail.layer.cornerRadius= cell.thumbnail.frame.size.width/2;
    cell.thumbnail.layer.borderWidth=0.0;
    cell.thumbnail.layer.masksToBounds = YES;
    cell.thumbnail.layer.borderColor=[[UIColor whiteColor] CGColor];
    */
    [ cell.thumbnail.image drawInRect:imageRect];
    cell.thumbnail.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext() ;
    
   // cell.thumbnail.image = [UIImage imageNamed:@"background.jpg"];
    
    cell.thumbnail.file = avstar;
 
   // UIGraphicsEndImageContext();
    [ cell.thumbnail loadInBackground];
  
  

    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.parseImage.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext() ;
      //      UIGraphicsEndImageContext();
            cell.parseImage.image = [UIImage imageWithData:data];
            [cell.loadingSpinner stopAnimating];
            cell.loadingSpinner.hidden = YES;
           
                  }
    }];
   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.main_tableview) {
        
        selectobject = [news_array  objectAtIndex:indexPath.row];
           } else {
 
        
        selectobject = [_searchResults  objectAtIndex:indexPath.row];
       
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
        tattoomasterCell.promotion=[selectobject objectForKey:@"promotion"];
        tattoomasterCell.favorites = [selectobject objectForKey:@"favorites"];
        tattoomasterCell.bookmark =[selectobject objectForKey:@"bookmark"];
        tattoomasterCell.view = [selectobject objectForKey:@"view"];
        tattoomasterCell.object_id = selectobject.objectId;
        
        mapVC.tattoomasterCell = tattoomasterCell;
    
    }
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"godetail"]) {
        NSIndexPath *indexPath = [self.image_collection indexPathForCell:sender];

        Tattoo_Detail_ViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [imageFilesArray objectAtIndex:indexPath.row];
        TattooMasterCell *tattoomasterCell = [[TattooMasterCell alloc] init];
   
        tattoomasterCell.object_id = [object objectForKey:@"object"];
        tattoomasterCell.muay_id = [object objectForKey:@"muay_id"];
        tattoomasterCell.name = [object objectForKey:@"name"];
        tattoomasterCell.person_incharge=[object objectForKey:@"person_incharge"];
        tattoomasterCell.gender=[object objectForKey:@"gender"];
        tattoomasterCell.imageFile=[object objectForKey:@"image"];
        tattoomasterCell.tel = [object objectForKey:@"tel"];
        tattoomasterCell.fax = [object objectForKey:@"fax"];
        tattoomasterCell.address = [object objectForKey:@"address"];
        tattoomasterCell.latitude = [object objectForKey:@"latitude"];
        tattoomasterCell.longitude = [object objectForKey:@"longitude"];
        tattoomasterCell.email = [object objectForKey:@"email"];
        tattoomasterCell.website = [object objectForKey:@"website"];
        tattoomasterCell.desc = [object objectForKey:@"desc"];
        tattoomasterCell.imageFile = [object objectForKey:@"image"];
        tattoomasterCell.promotion=[object objectForKey:@"promotion"];
        tattoomasterCell.favorites = [object objectForKey:@"favorites"];
        tattoomasterCell.bookmark =[object objectForKey:@"bookmark"];
        tattoomasterCell.view = [object objectForKey:@"view"];
        tattoomasterCell.object_id = object.objectId;
      
        
        destViewController.tattoomasterCell = tattoomasterCell;
             NSDictionary *dimensions = @{ @"name":[object objectForKey:@"name"]};
        [PFAnalytics trackEvent:@"showmaster" dimensions:dimensions];

        [object addUniqueObject:[PFInstallation currentInstallation].objectId forKey:@"view"];
        [object saveInBackground];

        }
    if ([segue.identifier isEqualToString:@"gonewdetail"]) {
        NSIndexPath *indexPath = [self.main_tableview indexPathForCell:sender];
        
        detail_news_ViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [news_array objectAtIndex:indexPath.row];
        TattooMasterCell *tattoomasterCell = [[TattooMasterCell alloc] init];
        
        tattoomasterCell.object_id = [object objectForKey:@"object"];
        tattoomasterCell.muay_id = [object objectForKey:@"muay_id"];
        tattoomasterCell.name = [object objectForKey:@"name"];
        tattoomasterCell.person_incharge=[object objectForKey:@"person_incharge"];
        tattoomasterCell.gender=[object objectForKey:@"gender"];
        tattoomasterCell.imageFile=[object objectForKey:@"image"];
        tattoomasterCell.tel = [object objectForKey:@"tel"];
        tattoomasterCell.fax = [object objectForKey:@"fax"];
        tattoomasterCell.address = [object objectForKey:@"address"];
        tattoomasterCell.latitude = [object objectForKey:@"latitude"];
        tattoomasterCell.longitude = [object objectForKey:@"longitude"];
        tattoomasterCell.email = [object objectForKey:@"email"];
        tattoomasterCell.website = [object objectForKey:@"website"];
        tattoomasterCell.desc = [object objectForKey:@"desc"];
        tattoomasterCell.imageFile = [object objectForKey:@"image"];
        tattoomasterCell.promotion=[object objectForKey:@"promotion"];
        tattoomasterCell.favorites = [object objectForKey:@"favorites"];
        tattoomasterCell.bookmark =[object objectForKey:@"bookmark"];
        tattoomasterCell.view = [object objectForKey:@"view"];
        tattoomasterCell.news = [object objectForKey:@"news"];
          tattoomasterCell.news_view = [object objectForKey:@"news_view"];
        tattoomasterCell.object_id = object.objectId;
        
        destViewController.tattoomasterCell = tattoomasterCell;
    
        [object addUniqueObject:[PFInstallation currentInstallation].objectId forKey:@"news_view"];
        [object saveInBackground];
        
    }

        }




@end
