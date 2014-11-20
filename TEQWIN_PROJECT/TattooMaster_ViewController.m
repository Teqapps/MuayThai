//  TattooMaster_ViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 28/7/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//
#import "LoginUIViewController.h"
#import "ImageExampleCell.h"


#import "TattooMaster_ViewController.h"
#import "Master_Map_ViewController.h"
#import "Tattoo_Detail_ViewController.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "Gallery.h"
#import <Parse/Parse.h>

@interface TattooMaster_ViewController ()<UISearchDisplayDelegate, UISearchBarDelegate>
{
    int lastClickedRow;
}

@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;


@end

@implementation TattooMaster_ViewController
@synthesize searchbar;
#define TABLE_HEIGHT 80
- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"muay_member";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
        //self.objectsPerPage = 10;
    }
    return self;
}
- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    CGRect newBounds = self.tableView.bounds;
    if (self.tableView.bounds.origin.y < 44) {
        newBounds.origin.y = newBounds.origin.y + self.searchbar.bounds.size.height;
        self.tableView.bounds = newBounds;
    }
    
    self.title =@"找拳館";
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.view.backgroundColor = [UIColor blackColor];

    searchbar.hidden = !searchbar.hidden;
    self.navigationController.navigationBar.translucent=NO;
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"refreshTable"
                                               object:nil];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self refreshTable:nil];
    NSLog(@"%@",[PFInstallation currentInstallation].objectId);
    // scroll search bar out of sight
    CGRect newBounds = self.tableView.bounds;
    if (self.tableView.bounds.origin.y < 44) {
        newBounds.origin.y = newBounds.origin.y;
        self.tableView.bounds = newBounds;
    }
    searchquery = [PFQuery queryWithClassName:@"muay_member"];
    //[query whereKey:@"Name" containsString:searchTerm];
    
    searchquery.cachePolicy=kPFCachePolicyNetworkElseCache;
    //
    installquery = [PFQuery queryWithClassName:@"Installation"];
    
    installquery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [installquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            installarray = [[NSArray alloc] initWithArray:objects];
            
        }
    }];

    
    NSLog(@"ssssss%d",installarray.count);
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    CGRect newBounds = self.tableView.bounds;
    if (self.tableView.bounds.origin.y < 44) {
        newBounds.origin.y = newBounds.origin.y + self.searchbar.bounds.size.height;
        self.tableView.bounds = newBounds;
    }
    
    
}

- (IBAction)showsearch:(id)sender {
    [searchbar becomeFirstResponder];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        
        return self.objects.count;
        
    } else {
        //NSLog(@"how many in search results");
        //NSLog(@"%@", self.searchResults.count);
        return self.searchResults.count;
        
    }
}

-(void)filterResults:(NSString *)searchTerm scope:(NSString*)scope
{
    [self.searchResults removeAllObjects];
    
    
    
    NSArray *results  = [searchquery findObjects];
    NSLog(@"%d",results.count);
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
//當scope 更新時，tableview 就會更新 （但要有search text)
//- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
//{
// Tells the table data source to reload when scope bar selection changes
//    [self filterResults :[self.searchDisplayController.searchBar text] scope:
//    [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];

// Return YES to cause the search result table view to be reloaded.
//   return YES;
//}

- (void)refreshTable:(NSNotification *) notification
{
    // Reload the recipes
    [self loadObjects];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}






- (PFQuery *)queryForTable{
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query whereKey:@"allow_display" equalTo:[NSNumber numberWithBool:YES]];
    
    
    
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    /*    if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     }*/
    
    [query orderByAscending:@"createdAt"];
    
    return query;
   

}






- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        
        selectobject = [self.objects  objectAtIndex:indexPath.row];
          NSLog(@"%@",[selectobject objectForKey:@"muay_id"]);
    } else {
        //NSLog(@"how many in search results");
        //NSLog(@"%@", self.searchResults.count);
        
        selectobject = [_searchResults  objectAtIndex:indexPath.row];
        NSLog(@"%@",[selectobject objectForKey:@"muay_id"]);
        Tattoo_Detail_ViewController * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Tattoo_Detail_ViewController"];
        [self.navigationController pushViewController:mapVC animated:YES];
        TattooMasterCell * tattoomasterCell = [[TattooMasterCell alloc] init];
        tattoomasterCell.object_id = [selectobject objectForKey:@"object"];
        tattoomasterCell.muay_id = [selectobject objectForKey:@"muay_id"];
        tattoomasterCell.name = [selectobject objectForKey:@"name"];
        tattoomasterCell.person_incharge=[selectobject objectForKey:@"person_incharge"];
        tattoomasterCell.gender=[selectobject objectForKey:@"gender"];
        tattoomasterCell.imageFile =[selectobject objectForKey:@"image"];
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
       // NSLog(@"%@",tattoomasterCell.master_id);
    }
    
    
}

// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    // Configure the cell
    // Configure the cell
    
    if (tableView == self.tableView) {
      
        UIActivityIndicatorView *loadingSpinner = (UIActivityIndicatorView*) [cell viewWithTag:110];
        loadingSpinner.hidden= NO;
        [loadingSpinner startAnimating];
        
        PFFile *thumbnail = [object objectForKey:@"image"];
        PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
        
        
        //thumbnailImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
       // thumbnailImageView.layer.cornerRadius= thumbnailImageView.frame.size.width / 2;
        //thumbnailImageView.layer.borderWidth=0.0;
       // thumbnailImageView.layer.masksToBounds = YES;
        //thumbnailImageView.layer.borderColor=[[UIColor whiteColor] CGColor];
        
        thumbnailImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //
        thumbnailImageView.image = [UIImage imageNamed:@"ICON.PNG"];
        thumbnailImageView.file = thumbnail;
        [thumbnailImageView loadInBackground];
        [loadingSpinner stopAnimating];
        loadingSpinner.hidden = YES;
        
        UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
        nameLabel.text = [object objectForKey:@"name"];
        
      //  UILabel *prepTimeLabel = (UILabel*) [cell viewWithTag:102];
      //  prepTimeLabel.text = [object objectForKey:@"address"];
        
        count=[object objectForKey:@"favorites"];
        UILabel *count_like = (UILabel*) [cell viewWithTag:105];
        count_like.text = [NSString stringWithFormat:@"%d",count.count];
        
        UILabel *master_desc = (UILabel*) [cell viewWithTag:187];
        master_desc.text = [object objectForKey:@"desc"];
        
     //   sex_statues = (PFImageView*)[cell viewWithTag:177];
      //  if ([[object objectForKey:@"gender"]isEqualToString:@"男"]) {

            
      //      sex_statues.image = [UIImage imageNamed:@"icon-sex-m.png"];
     //   }
     //   else
     //   if ([[object objectForKey:@"gender"]isEqualToString:@"女"]) {
            
      //      sex_statues.image = [UIImage imageNamed:@"icon-sex-f.png"];
      //  }
 
        heart_statues = (PFImageView*)[cell viewWithTag:107];
        if ([[object objectForKey:@"favorites"]containsObject:[PFUser currentUser].objectId]) {
            
            heart_statues.image = [UIImage imageNamed:@"icon-liked.png"];
        }
        else
        {
            
            heart_statues.image = [UIImage imageNamed:@"icon-like.png"];
        }
        // UICollectionView *cellImageCollection=(UICollectionView *)[cell viewWithTag:9];
        
    }
    cell.backgroundColor = [UIColor clearColor];
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
        cell.detailTextLabel.text =[object objectForKey:@"gender"];
        
    }
    gallary_image = (PFImageView*)[cell viewWithTag:161];
    gallary_button = (UIButton*)[cell viewWithTag:162];
    if ([[object objectForKey:@"gallary_displayallow"]isEqualToValue:[NSNumber numberWithBool:YES]]) {
        //   NSLog(@"%@",self.tattoomasterCell.master_id);
        gallary_image.image=[UIImage imageNamed:@"icon-gallery.png"];
        
    }
    else
    {
        gallary_image.image = [UIImage imageNamed:@"icon-gallery_nophoto.png"];
        ;
        gallary_button.enabled=NO;
        //   NSLog(@"%@",self.tattoomasterCell.master_id);
        
    }

    return cell;
    
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
// Remove the row from data model
//    PFObject *object = [self.objects objectAtIndex:indexPath.row];
//   [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//       [self refreshTable:nil];
//   }];
//}



- (IBAction)Fav:(id)sender {
    if ([PFUser currentUser]) {
        UIButton *button = sender;
        CGPoint correctedPoint =
        [button convertPoint:button.bounds.origin toView:self.tableView];
        indexPath =  [self.tableView indexPathForRowAtPoint:correctedPoint];
        lastClickedRow = indexPath.row;
        selectobject = [self.objects objectAtIndex:indexPath.row];
        
        
        if ([[selectobject objectForKey:@"favorites"]containsObject:[PFUser currentUser].objectId]) {
            
            [self dislike];
            
            NSLog(@"disliked");
            
        }
        
        else{
            
            
            [self likeImage];
            
            NSLog(@"liked");
            
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
        
        NSLog(@"請登入");

        ; }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([button isEqualToString:@"確定"])
    { LoginUIViewController * loginvc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginUIViewController"];
        [self.navigationController pushViewController:loginvc animated:YES];
        
        
    }
}
- (void) likeImage {
    [selectobject addUniqueObject:[PFUser currentUser].objectId forKey:@"favorites"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];
    [selectobject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            
            if ([[selectobject objectForKey:@"favorites"]containsObject:[PFUser currentUser].objectId]) {
                
            }
            [self refreshTable:nil];
            [hud hide:YES];
        }
        else {
            [self likedFail];
        }
    }];
}
- (void) dislike {
    [selectobject removeObject:[PFUser currentUser].objectId forKey:@"favorites"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];
    [selectobject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            
            if ([[selectobject objectForKey:@"favorites"]containsObject:[PFUser currentUser].objectId]) {
                
            }
            else
            {
                
            }
            [self refreshTable:nil];
            [hud hide:YES];
        }
        else {
            [self dislikedFail];
        }
    }];
}

- (void) likedSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功!" message:@"你已經加入了我的最愛" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}

- (void) likedFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失敗!" message:@"There was an error when liking the image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
- (void) dislikedSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功!" message:@"你已經取消了我的最愛" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    
}

- (void) dislikedFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"失敗!" message:@"There was an error when liking the image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.table_view indexPathForSelectedRow];
        Tattoo_Detail_ViewController *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        TattooMasterCell *tattoomasterCell = [[TattooMasterCell alloc] init];
        
        tattoomasterCell.object_id = [object objectForKey:@"object"];
        tattoomasterCell.muay_id = [object objectForKey:@"muay_id"];
        tattoomasterCell.name = [object objectForKey:@"name"];
        tattoomasterCell.person_incharge=[object objectForKey:@"person_incharge"];
        tattoomasterCell.gender=[object objectForKey:@"gender"];
        tattoomasterCell.imageFile =[object objectForKey:@"image"];
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
      //  NSInteger myInteger = [tattoomasterCell.view integerValue];
      //  object[@"view"] =[NSNumber numberWithFloat:(myInteger+ 1)];
      //  [object saveInBackground];
      //  NSLog(@"%@",object[@"view"]);
        
        
        [object addUniqueObject:[PFInstallation currentInstallation].objectId forKey:@"view"];
        [object saveInBackground];
    }
    if ([segue.identifier isEqualToString:@"GOGALLERY_button"]) {
        UIButton *button = sender;
        CGPoint correctedPoint =
        [button convertPoint:button.bounds.origin toView:self.tableView];
        NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:correctedPoint];
        Gallery *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        TattooMasterCell *tattoomasterCell = [[TattooMasterCell alloc] init];
        //tattoomasterCell.clickindexpath =[self.tableView indexPathForRowAtPoint:correctedPoint];
        tattoomasterCell.clickindexpath =nil;
        
        tattoomasterCell.object_id = [object objectForKey:@"object"];
        tattoomasterCell.muay_id = [object objectForKey:@"muay_id"];
        tattoomasterCell.name = [object objectForKey:@"name"];
        tattoomasterCell.person_incharge=[object objectForKey:@"person_incharge"];
        tattoomasterCell.gender=[object objectForKey:@"gender"];
        tattoomasterCell.imageFile =[object objectForKey:@"image"];
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
        
        
      //  NSLog(@"%D",tattoomasterCell.clickindexpath.row);
        
    }


}


- (IBAction)gogallery:(id)sender {
  }
@end
