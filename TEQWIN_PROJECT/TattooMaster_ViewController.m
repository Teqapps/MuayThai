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
    // set the frame to zero
    area = [[NSArray alloc] initWithObjects:@"全選",@"香港島",@"九龍",@"新界", nil];
     region_hk = [[NSArray alloc] initWithObjects:@"全選",@"上環",@"中環",@"灣仔",@"銅鑼灣",@"跑馬地",@"黃竹坑",@"鴨脷洲",@"北角",@"鰂魚涌",@"西灣河",@"柴灣",@"天后",@"炮台山",@"西營盤",@"筲箕灣",@"金鐘",@"太古",@"香港仔", nil];
region_kl = [[NSArray alloc] initWithObjects:@"全選",@"尖沙咀",@"佐敦",@"油麻地",@"旺角",@"太子",@"深水埗",@"長沙灣",@"新蒲崗",@"觀塘",@"鑽石山",@"大角咀",@"牛頭角",@"何文田",@"土瓜灣",@"九龍城",@"荔枝角",@"油塘",@"紅磡",@"九龍塘", nil];
    region_nt = [[NSArray alloc] initWithObjects:@"全選",@"葵涌",@"荃灣",@"火炭",@"元朗",@"上水",@"沙田",@"屯門",@"葵芳",@"大埔",@"粉嶺",@"", nil];
    self.pickerViewTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.pickerViewTextField];
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    // set change the inputView (default is keyboard) to UIPickerView
    self.pickerViewTextField.inputView = pickerView;
    
    // add a toolbar with Cancel & Done button
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    self.pickerViewTextField.inputAccessoryView = toolBar;

    
    searchquery = [PFQuery queryWithClassName:@"muay_member"];
    //[query whereKey:@"Name" containsString:searchTerm];
    
    searchquery.cachePolicy=kPFCachePolicyNetworkElseCache;
    
    
    
    [self stylePFLoadingViewTheHardWay];
    UIImage *image = [UIImage imageNamed:@"background_news.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    // Add image view on top of table view
    [self.table_view addSubview:imageView];
    
    // Set the background view of the table view
    self.table_view.backgroundView = imageView;
    /*
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    CGRect newBounds = self.tableView.bounds;
    if (self.tableView.bounds.origin.y < 44) {
        newBounds.origin.y = newBounds.origin.y + self.searchbar.bounds.size.height;
        self.tableView.bounds = newBounds;
    }*/
    
    self.title =@"找拳館";
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    self.view.backgroundColor = [UIColor blackColor];
    /*
    searchbar.hidden = !searchbar.hidden;*/
    // self.navigationController.navigationBar.translucent=NO;
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
- (void)stylePFLoadingViewTheHardWay
{
    UIColor *labelTextColor = [UIColor whiteColor];
    UIColor *labelShadowColor = [UIColor darkGrayColor];
    UIActivityIndicatorViewStyle activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    
    // go through all of the subviews until you find a PFLoadingView subclass
    for (UIView *subview in self.view.subviews)
    {
        if ([subview class] == NSClassFromString(@"PFLoadingView"))
        {
            // find the loading label and loading activity indicator inside the PFLoadingView subviews
            for (UIView *loadingViewSubview in subview.subviews) {
                if ([loadingViewSubview isKindOfClass:[UILabel class]])
                {
                    UILabel *label = (UILabel *)loadingViewSubview;
                    {
                        label.textColor = labelTextColor;
                        label.shadowColor = labelShadowColor;
                    }
                }
                
                if ([loadingViewSubview isKindOfClass:[UIActivityIndicatorView class]])
                {
                    UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView *)loadingViewSubview;
                    activityIndicatorView.activityIndicatorViewStyle = activityIndicatorViewStyle;
                }
            }
        }
    }
}
- (void)viewWillAppear:(BOOL)animated {
    //[self refreshTable:nil];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // scroll search bar out of sight
 
    //  self.screenName = @"Main";
    searchquery = [PFQuery queryWithClassName:@"muay_member"];
    //[query whereKey:@"Name" containsString:searchTerm];
    searchquery.cachePolicy=kPFCachePolicyNetworkElseCache;
    
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
    searchquery.cachePolicy=kPFCachePolicyCacheElseNetwork;
    [self.searchResults addObjectsFromArray:results];
    
    NSPredicate *searchPredicate =
    [NSPredicate predicateWithFormat:@"name CONTAINS[cd]%@ OR person_incharge CONTAINS[cd]%@", searchTerm,searchTerm];
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
    
    [query whereKey:@"allow_display" equalTo:[NSNumber numberWithBool:YES]];
     [query whereKey:@"area" containsString:club];
    [query whereKey:@"region" containsString:region];
       [query orderByAscending:@"muays_id"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    
    

    
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
        tattoomasterCell.promotion_image=[selectobject objectForKey:@"promotion_image"];
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
        thumbnailImageView.layer.cornerRadius= thumbnailImageView.frame.size.width / 2;
        thumbnailImageView.layer.borderWidth=0.0;
        thumbnailImageView.layer.masksToBounds = YES;
        thumbnailImageView.layer.borderColor=[UIColor colorWithRed:45.0f/255.0f green:0.0f/255.0f blue:10.0f/255.0f alpha:1].CGColor;
        
        
        thumbnailImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        //
        // thumbnailImageView.image = [UIImage imageNamed:@"image_icon.png"];
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
        count_like.text = [NSString stringWithFormat:@"%lu",(unsigned long)count.count];
        
        viewcount=[object objectForKey:@"view"];
        UILabel *count_view = (UILabel*) [cell viewWithTag:134];
        count_view.text = [NSString stringWithFormat:@"%lu",(unsigned long)viewcount.count];
        
        
        UILabel *master_desc = (UILabel*) [cell viewWithTag:187];
        if ([[object objectForKey:@"desc"] isEqual:@""] || [object objectForKey:@"desc"]==nil ) {
            master_desc.text= @"沒有簡介";
        }
        
        else{
            master_desc.text = [object objectForKey:@"desc"];
        }
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
            
            heart_statues.image = [UIImage imageNamed:@"new_liked.png"];
        }
        else
        {
            
            heart_statues.image = [UIImage imageNamed:@"new_like.png"];
        }
        // UICollectionView *cellImageCollection=(UICollectionView *)[cell viewWithTag:9];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        PFObject* object = self.searchResults[indexPath.row];
        
        
        
        cell.textLabel.text = [object objectForKey:@"name"];
        cell.detailTextLabel.text =[object objectForKey:@"gender"];
        
    }
    gallary_image = (PFImageView*)[cell viewWithTag:161];
    gallary_button = (UIButton*)[cell viewWithTag:162];
    if ([[object objectForKey:@"gallary_displayallow"]isEqualToValue:[NSNumber numberWithBool:YES]]) {
        //   NSLog(@"%@",self.tattoomasterCell.master_id);
        gallary_image.image=[UIImage imageNamed:@"photo_on.png.png"];
        
    }
    else
    {
        gallary_image.image = [UIImage imageNamed:@"photo.png"];
        ;
        gallary_button.enabled=NO;
        //   NSLog(@"%@",self.tattoomasterCell.master_id);
        
    }
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor =  [[UIColor colorWithRed:85.0/256.0 green:85.0/256.0 blue:85.0/256.0 alpha:1 ]colorWithAlphaComponent:0.5f];
    [cell setSelectedBackgroundView:bgColorView];
    
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
        tattoomasterCell.promotion_image=[object objectForKey:@"promotion_image"];
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
        tattoomasterCell.promotion_image=[object objectForKey:@"promotion_image"];
        
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

- (IBAction)address_search:(id)sender {
     [self.pickerViewTextField becomeFirstResponder];
   
}
- (void)cancelTouched:(UIBarButtonItem *)sender
{
    // hide the picker view
    [self.pickerViewTextField resignFirstResponder];
}

- (void)doneTouched:(UIBarButtonItem *)sender
{
    // hide the picker view
    [self.pickerViewTextField resignFirstResponder];
     NSLog(@"ON999%@",region);
      if ([club isEqualToString:@"全選"]) {
          club=@"";
           region=@"";
      }
    if ([club isEqualToString:@"香港島"] && [region isEqualToString:@"全選"]) {
        club=@"香港島";
        region=@"";
        
    }
       if ([club isEqualToString:@"九龍"] && [region isEqualToString:@"全選"]) {
        club=@"九龍";
        region=@"";
        
    }

    if ([club isEqualToString:@"新界"] && [region isEqualToString:@"全選"]) {
        club=@"新界";
        NSLog(@"CLUB%@",club);
        region=@"";
        
    }
    
    [self refreshTable:nil];
    // perform some action
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component ==0)
    {
        return [area count];
    }
    else {
        if ([club isEqualToString:@"香港島"]) {
            return [region_hk count];
        }
        if ([club isEqualToString:@"九龍"]) {
            return [region_kl count];
        }
        if ([club isEqualToString:@"新界"]) {
            return [region_nt count];
        }
        // if...
       
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  
    if(component ==0)
    {
        return [area objectAtIndex:row];
    }
    else {
        if ([club isEqualToString:@"香港島"]) {
            return  [region_hk objectAtIndex:row];
        }
        if ([club isEqualToString:@"九龍"]) {
            return [region_kl objectAtIndex:row];
        }
        if ([club isEqualToString:@"新界"]) {
            return [region_nt objectAtIndex:row];
        }

      

           }
    
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        club=[[NSString alloc] initWithFormat:@"%@" , [area objectAtIndex:row]];
        NSLog(@"%@",club);
        [pickerView reloadComponent:1];
    }
    if ([club isEqualToString:@"香港島"]) {
        region =[region_hk objectAtIndex:row];
     
        NSLog(@"%@",[region_hk objectAtIndex:row]);
       

    }
    if ([club isEqualToString:@"九龍"]) {
        region =[region_kl objectAtIndex:row];
       
        NSLog(@"%@",[region_hk objectAtIndex:row]);
       
        
    }
    if ([club isEqualToString:@"新界"]) {
        region =[region_nt objectAtIndex:row];
       
        NSLog(@"%@",[region_hk objectAtIndex:row]);
       
    }}
@end
