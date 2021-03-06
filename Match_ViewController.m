//  TattooMaster_ViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 28/7/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

//#import "ImageExampleCell.h"

#import "PopupViewController.h"
#import "Match_ViewController.h"
#import "Master_Map_ViewController.h"
#import "SWRevealViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

#import <Parse/Parse.h>
#import "Boxers_Detail.h"
@interface Match_ViewController ()<UISearchDisplayDelegate, UISearchBarDelegate>
{
    int lastClickedRow;
       UIImageView *fullImageView;
}

@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;


@end

@implementation Match_ViewController
@synthesize searchbar;
#define TABLE_HEIGHT 80
- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Match";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
        
        // The number of objects to show per page
          self.objectsPerPage = 4;
    }
    return self;
}
- (void)viewDidLoad;
{
    [super viewDidLoad];
    //THE ALERT VIEW
    demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    
    PFImageView *imageView1 = [[PFImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
    ;
    PFQuery *query = [PFQuery queryWithClassName:@"Full_ad"];
    [query getObjectInBackgroundWithId:@"H4zEeqNzW5" block:^(PFObject *gameScore, NSError *error) {
        object_array =[query findObjects];
        
        for (PFObject *object in object_array) {
            
            if (object[@"ad_link"]==nil||[object[@"ad_link"]isEqualToString:@""]) {
                _islink=NO;
         
                
            }
            else{
                _islink=YES;
            }
            
        }
        // Do something with the returned PFObject in the gameScore variable.
        
        
        
        clubfile = [gameScore objectForKey:@"ad_image"];
        
        imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //_club_image.image = [UIImage imageNamed:@"muay_banner6.png"];
        imageView1.file  = clubfile;
        
        [imageView1 loadInBackground];
        [demoView addSubview:imageView1];
        // Here we need to pass a full frame
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
        
        // Add some custom content to the alert view
        [alertView setContainerView:demoView];
        
        // Modify the parameters
        if (_islink==YES) {
            [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"返回",@"進入詳細", nil]];
            [alertView setDelegate:self];
            
        }
        else{
            [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"返回", nil]];
            [alertView setDelegate:self];
        }
        // You may use a Block, rather than a delegate.
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            if (buttonIndex==0) {
                [alertView close];
            }
            if (buttonIndex==1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[gameScore objectForKey:@"ad_link"]]];
            }
        }];
        
        [alertView setUseMotionEffects:true];
        
        // And launch the dialog
        [alertView show];
        
    }];

//----------------END OF ALERTVIEW----------------------------------------\\
   
    
    /*
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login.png"]];
    [v addSubview:imageView1];
    v.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
    v.layer.cornerRadius = 5;
    v.layer.shadowOpacity = 0.8;
   v.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
    [self.view addSubview:v];

        [self showAnimate];
    /*
    [self stylePFLoadingViewTheHardWay];
    /*
    for (UIView *subView in searchbar.subviews) {
        for (UIView *secondLevelSubview in subView.subviews) {
            if (![secondLevelSubview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                [secondLevelSubview removeFromSuperview];
            }
        }
    }*/
    searchbar.tintColor = [UIColor whiteColor];
    searchbar.barTintColor =[UIColor whiteColor];
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    UIImage *image = [UIImage imageNamed:@"background_news.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    // Add image view on top of table view
    [self.table_view addSubview:imageView];
    
    // Set the background view of the table view
    self.table_view.backgroundView = imageView;

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"refreshTable"
                                               object:nil];

 self.tabBarController.tabBar.hidden = NO;
     [self queryParseMethod_boxer1];
         CGRect newBounds = self.tableView.bounds;
    if (self.tableView.bounds.origin.y < 44) {
        newBounds.origin.y = newBounds.origin.y + self.searchbar.bounds.size.height;
        self.tableView.bounds = newBounds;
    }
    
    self.title =@"泰拳比賽";
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    //self.view.backgroundColor = [UIColor blackColor];
    // searchbar.hidden = !searchbar.hidden;

    searchquery = [PFQuery queryWithClassName:@"Boxers"];
    //[query whereKey:@"Name" containsString:searchTerm];
    
    searchquery.cachePolicy=kPFCachePolicyNetworkElseCache;
    [searchquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
     
        if (!error) {
            boxer_array = [[NSArray alloc] initWithArray:objects];
            
        }
    }];

    //self.navigationController.navigationBar.translucent=YES;

    
}
- (IBAction)launchDialog:(id)sender
{
   }

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
  }


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
- (void)viewWillAppear:(BOOL)animated {
    self.navigationItem.hidesBackButton = YES;

    CGRect newBounds = self.tableView.bounds;
    if (self.tableView.bounds.origin.y < 44) {
        newBounds.origin.y = newBounds.origin.y;
        self.tableView.bounds = newBounds;
    }



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


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    CGRect newBounds = self.tableView.bounds;
    if (self.tableView.bounds.origin.y < 44) {
        newBounds.origin.y = newBounds.origin.y + self.searchbar.bounds.size.height;
        self.tableView.bounds = newBounds;
    }
  
}






-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        
        return self.objects.count;
        
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
    [NSPredicate predicateWithFormat:@"Name CONTAINS[cd]%@", searchTerm];
    _searchResults = [NSMutableArray arrayWithArray:[results filteredArrayUsingPredicate:searchPredicate]];
    

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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
    // Use this to allow upside down as well
    //return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}



- (void)queryParseMethod_boxer1 {

    NSLog(@"count%lu",(unsigned long)self.objects.count);
    PFQuery *query = [PFQuery queryWithClassName:@"Banner"];
  
    //query.cachePolicy = kPFCachePolicyNetworkElseCache;

 //[query whereKey:@"Boxer_id" containsString:@"3"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        }
        if (!error) {
            {
                NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:objects];
                NSUInteger count = [mutableArray count];
                // See http://en.wikipedia.org/wiki/Fisher–Yates_shuffle
              
                    if (count > 1) {
                        for (NSUInteger i = count - 1; i > 0; --i) {
                            [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform((int32_t)(i + 1))];
                            
                        }
                    }

               
                
                bannerarray = [NSArray arrayWithArray:mutableArray];
             
                [_table_view reloadData];
            
     
            }
            

        }
    }];
    
}


- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}
- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}


- (PFQuery *)queryForTable{



    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
   
    [query whereKey:@"allow_display" equalTo:[NSNumber numberWithBool:YES]];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
       if ([self.objects count] == 0) {
     query.cachePolicy = kPFCachePolicyCacheThenNetwork;
       }
    
    [query orderByAscending:@"match_id"];
   
    return query;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (tableView == self.tableView) {
     PFObject *imageObject = [self.objects objectAtIndex:indexPath.row];
    NSNumber * isSuccessNumber3 = (NSNumber *)[imageObject objectForKey: @"banner_allow"];
    if([isSuccessNumber3 boolValue] == YES)
    {
        return 200;
    }
    else
    {
        
       return 145;
        
    }
        }
    else
    {
        return 50;
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
   // selectobject = [boxer_array  objectAtIndex:indexPath.row];
    if (tableView == self.tableView) {
 
        UIActivityIndicatorView *loadingSpinner_2 = (UIActivityIndicatorView*) [cell viewWithTag:111];
        UIActivityIndicatorView *loadingSpinner = (UIActivityIndicatorView*) [cell viewWithTag:110];
       
        loadingSpinner.hidden= NO;
        [loadingSpinner startAnimating];
        loadingSpinner_2.hidden= NO;
        [loadingSpinner_2 startAnimating];
        PFFile *Boxer_1_image = [object objectForKey:@"Boxer_1_image"];
        
             PFImageView *Boxer_1_imageView = (PFImageView*)[cell viewWithTag:100];
       

        


        Boxer_1_imageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
       Boxer_1_imageView.layer.cornerRadius= Boxer_1_imageView.frame.size.width / 2;
        Boxer_1_imageView.layer.borderWidth=4.0f;
        Boxer_1_imageView.layer.masksToBounds = YES;
        Boxer_1_imageView.layer.borderColor=[UIColor colorWithRed:40.0f/255.0f green:0.0f/255.0f blue:10.0f/255.0f alpha:1].CGColor;

        
       // UIGraphicsEndImageContext();
             
       Boxer_1_imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext() ;

        Boxer_1_imageView.image = [UIImage imageNamed:@"ICON.png"];

                Boxer_1_imageView.file    = Boxer_1_image;
        
               
        [Boxer_1_imageView loadInBackground];
        
        
        PFFile *Boxer_2_image = [object objectForKey:@"Boxer_2_image"];
        PFImageView *Boxer_2_imageView = (PFImageView*)[cell viewWithTag:99];
      
        Boxer_2_imageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
        Boxer_2_imageView.layer.cornerRadius= Boxer_2_imageView.frame.size.width / 2;
        Boxer_2_imageView.layer.borderWidth=4.0f;
        Boxer_2_imageView.layer.masksToBounds = YES;
        Boxer_2_imageView.layer.borderColor=[UIColor colorWithRed:40.0f/255.0f green:0.0f/255.0f blue:10.0f/255.0f alpha:1].CGColor;
     
       
   
        Boxer_2_imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext() ;
        
       // UIGraphicsEndImageContext();

        
     ;
                               Boxer_2_imageView.image = [UIImage imageNamed:@"ICON.png"];
            
        
        Boxer_2_imageView.file=Boxer_2_image;
        [loadingSpinner_2 stopAnimating];
        loadingSpinner_2.hidden = YES;
                  [Boxer_2_imageView loadInBackground];
        
        [loadingSpinner stopAnimating];
        loadingSpinner.hidden = YES;
         PFImageView *Match_Result_1_imageView = (PFImageView*)[cell viewWithTag:191];
         PFImageView *Match_Result_1_imageView_lose = (PFImageView*)[cell viewWithTag:133];
        
        Match_Result_1_imageView_lose.layer.backgroundColor=[[UIColor clearColor] CGColor];
        Match_Result_1_imageView_lose.layer.cornerRadius= Boxer_2_imageView.frame.size.width / 2;
    
        Match_Result_1_imageView_lose.layer.masksToBounds = YES;
        UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
        UILabel *nameLabel_2 = (UILabel*) [cell viewWithTag:102];
        
       PFImageView *Match_Result_2_imageView = (PFImageView*)[cell viewWithTag:192];
          PFImageView *Match_Result_2_imageView_lose = (PFImageView*)[cell viewWithTag:134];
        Match_Result_2_imageView_lose.layer.backgroundColor=[[UIColor clearColor] CGColor];
        Match_Result_2_imageView_lose.layer.cornerRadius= Boxer_2_imageView.frame.size.width / 2;
        
        Match_Result_2_imageView_lose.layer.masksToBounds = YES;
        

       // PFFile *Match_Result_1 = [object objectForKey:@"Boxer_1_resulticon"];
    
        NSNumber * isSuccessNumber = (NSNumber *)[object objectForKey: @"Result_allow"];
        if([isSuccessNumber boolValue] == YES)
        {

       
        if ([[object objectForKey:@"Boxer_1_result"]isEqualToString:@"Win"]) {
            
            Match_Result_1_imageView_lose.image=nil;
                  Match_Result_1_imageView.image = [UIImage imageNamed:@"home_win.png"];
             Match_Result_1_imageView.layer.shadowColor =[UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
            Match_Result_1_imageView.layer.shadowOffset = CGSizeMake(.0f,2.5f);
               }
            
               else  if ([[object objectForKey:@"Boxer_1_result"]isEqualToString:@"Lose"]) {
              {
                  Match_Result_1_imageView.image =nil;
                  Match_Result_1_imageView_lose.image = [UIImage imageNamed:@"los1e.png"];
                  nameLabel.alpha = 1;
                 //  Match_Result_1_imageView.layer.cornerRadius= Match_Result_1_imageView.frame.size.width / 2;
                  Match_Result_1_imageView_lose.alpha = 0.8;
                   Match_Result_1_imageView_lose.layer.cornerRadius= Match_Result_1_imageView_lose.frame.size.width / 2;
                 //  Match_Result_1_imageView.image = [UIImage imageNamed:@"los1e.png"];
              }
               }
               else{
                    Match_Result_1_imageView.image = nil;
                   Match_Result_1_imageView_lose.image=nil;
               }
        //PFFile *Match_Result_2 = [object objectForKey:@"Boxer_2_resulticon"];
        
            if ([[object objectForKey:@"Boxer_2_result"]isEqualToString:@"Win"]) {
                
                  Match_Result_2_imageView_lose.image=nil;
                Match_Result_2_imageView.image = [UIImage imageNamed:@"home_win.png"];
                Match_Result_2_imageView.layer.shadowColor =[UIColor colorWithRed:255.f/255.f green:230.f/255.f blue:0.f/255.f alpha:1.f].CGColor;
             Match_Result_2_imageView.layer.shadowOffset = CGSizeMake(.0f,2.5f);
            
            }
            else  if ([[object objectForKey:@"Boxer_2_result"]isEqualToString:@"Lose"]) {
                {
                     nameLabel_2.alpha = 1;
                       Match_Result_2_imageView_lose.layer.cornerRadius= Match_Result_2_imageView_lose.frame.size.width / 2;
                     Match_Result_2_imageView.image =nil;
                     Match_Result_2_imageView_lose.alpha = 0.8;
                     Match_Result_2_imageView_lose.image = [UIImage imageNamed:@"los1e.png"];
                }
            }
            else{
                Match_Result_2_imageView.image = nil;
                 Match_Result_2_imageView_lose.image = nil;
            }
        }
        else
        {
            Match_Result_1_imageView.image=nil;
            Match_Result_2_imageView.image=nil;
              Match_Result_2_imageView_lose.image = nil;
              Match_Result_1_imageView_lose.image=nil;
        }
        
         PFObject *bannerobject = [bannerarray objectAtIndex:indexPath.row  ];
     
        PFFile *banner = [bannerobject objectForKey:@"banner_image"];
      
        PFImageView *banner_imageView = (PFImageView*)[cell viewWithTag:200];
        [Boxer_1_image getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
        NSNumber * isSuccessNumber3 = (NSNumber *)[object objectForKey: @"banner_allow"];
        if([isSuccessNumber3 boolValue] == YES)
        {
            banner_imageView.image = UIGraphicsGetImageFromCurrentImageContext();
   
          //  Boxer_1_imageView.image = [UIImage imageNamed:@"ICON.PNG"];
            banner_imageView.file = banner;
            [banner_imageView loadInBackground];
        }
        else
        {
            
            banner_imageView.hidden=YES;
            
        
        
        }

            }}];
        
        
        
        
        
        
        
      
        nameLabel.text = [object objectForKey:@"Boxer_1"];
        
        
        nameLabel_2.text = [object objectForKey:@"Boxer_2"];
        //  UILabel *prepTimeLabel = (UILabel*) [cell viewWithTag:102];
        //  prepTimeLabel.text = [object objectForKey:@"address"];
        
        count=[object objectForKey:@"favorites"];
        UILabel *count_like = (UILabel*) [cell viewWithTag:105];
        count_like.text = [NSString stringWithFormat:@"%d",count.count];
        
        UILabel *match_time = (UILabel*) [cell viewWithTag:187];
        match_time.text = [object objectForKey:@"Match_Time"];
        UILabel *match_date = (UILabel*) [cell viewWithTag:188];
        match_date.text = [object objectForKey:@"Match_Date"];
        UILabel *match_type = (UILabel*) [cell viewWithTag:146];
        
        match_type.text = [object objectForKey:@"Match_Type"];
        if ([match_type.text  isEqual: @""])
        {
            match_type.text =@"";
        }
        else
        {
            match_type.text = [object objectForKey:@"Match_Type"];
            
        }
        // UICollectionView *cellImageCollection=(UICollectionView *)[cell viewWithTag:9];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        PFObject* object = self.searchResults[indexPath.row];
        
        
        cell.textLabel.text = [object objectForKey:@"Name"];
        cell.detailTextLabel.text =[object objectForKey:@"Club"];
        
    }
    

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     lastClickedRow = indexPath.row;
    if (tableView == self.tableView) {
        
        selectobject = [self.objects  objectAtIndex:indexPath.row];
       
    }
    else {
  
        selectobject = [self.objects  objectAtIndex:indexPath.row];

        searchedobject = [_searchResults  objectAtIndex:indexPath.row];
     
        Boxers_Detail * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Boxers_Detail"];
        [self.navigationController pushViewController:mapVC animated:YES];
        MatchCell * tattoomasterCell = [[MatchCell alloc] init];
        tattoomasterCell.boxer_id = [searchedobject objectForKey:@"boxer_id"];
        tattoomasterCell.boxer_name = [searchedobject objectForKey:@"Name"];
        tattoomasterCell.view = [searchedobject objectForKey:@"view"];
        tattoomasterCell.imageFile=[selectobject objectForKey:@"Boxer_2_image"];
          tattoomasterCell.imageFile=[selectobject objectForKey:@"Boxer_1_image"];
      //  tattoomasterCell.object_id = selectobject.objectId;
        
        mapVC.tattoomasterCell = tattoomasterCell;
     
    }
    
    
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
// Remove the row from data model
//    PFObject *object = [self.objects objectAtIndex:indexPath.row];
//   [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//       [self refreshTable:nil];
//   }];
//}




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"player1"]) {
        UIButton *button = sender;
        CGPoint correctedPoint =
        [button convertPoint:button.bounds.origin toView:self.tableView];
        NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:correctedPoint];
        Boxers_Detail *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        MatchCell *tattoomasterCell = [[MatchCell alloc] init];
        
        tattoomasterCell.object_id = [object objectForKey:@"object"];
        tattoomasterCell.boxer_id = [object objectForKey:@"Boxer_1_id"];
        tattoomasterCell.imageFile=[object objectForKey:@"Boxer_1_image"];
        tattoomasterCell.boxer_name = [object objectForKey:@"Boxer_1"];
        tattoomasterCell.view = [object objectForKey:@"view"];
        tattoomasterCell.object_id = object.objectId;


        destViewController.tattoomasterCell = tattoomasterCell;
         }
    if ([segue.identifier isEqualToString:@"player2"]) {
        UIButton *button = sender;
        CGPoint correctedPoint =
        [button convertPoint:button.bounds.origin toView:self.tableView];
        NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:correctedPoint];
        Boxers_Detail *destViewController = segue.destinationViewController;
        
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        MatchCell *tattoomasterCell = [[MatchCell alloc] init];
        //tattoomasterCell.clickindexpath =[self.tableView indexPathForRowAtPoint:correctedPoint];
        tattoomasterCell.clickindexpath =0;
        
        tattoomasterCell.object_id = [object objectForKey:@"object"];
        tattoomasterCell.boxer_id = [object objectForKey:@"Boxer_2_id"];
        tattoomasterCell.boxer_name = [object objectForKey:@"Boxer_2"];
        tattoomasterCell.view = [object objectForKey:@"view"];
        tattoomasterCell.imageFile=[object objectForKey:@"Boxer_2_image"];
        tattoomasterCell.object_id = object.objectId;

        destViewController.tattoomasterCell = tattoomasterCell;


           }
    
    
}



- (IBAction)gogallery:(id)sender {
}

- (IBAction)showsearch:(id)sender {
         [searchbar becomeFirstResponder];
    
    

}
- (IBAction)gobannersite:(id)sender {
    [sender setEnabled:NO];
    UIButton *button = sender;
    CGPoint correctedPoint =
    [button convertPoint:button.bounds.origin toView:self.tableView];
    NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:correctedPoint];
     PFObject *object = [bannerarray objectAtIndex:indexPath.row];
       [sender setEnabled:NO];
[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[object objectForKey:@"banner_link"]]];
       [sender setEnabled:YES];
  
  // NSDictionary *dimensions = @{@"Banner_id":[object objectForKey:@"banner_id"]};
//[PFAnalytics trackEvent:@"Banner_Count" dimensions:dimensions];
}

@end
