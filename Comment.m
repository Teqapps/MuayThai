//
//  ViewController.m
//  2
//
//  Created by Teqwin on 24/2/2015.
//  Copyright (c) 2015年 Teqwin. All rights reserved.
//

#import "Comment.h"
#import "NewRecipeViewController.h"
@interface Comment ()

@end

@implementation Comment
- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"Comment";
        
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

- (void)viewDidLoad {
    [super viewDidLoad];
      self.title=@"留言";
    NSDate *currentDateWithOffset = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone localTimeZone] secondsFromGMT]];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTable:)
                                                 name:@"refreshTable"
                                               object:nil];

}
- (void)refreshTable:(NSNotification *) notification
{
    // Reload the recipes
    [self loadObjects];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query whereKey:@"muay_id" containsString:self.tattoomasterCell.muay_id ];
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    /*    if ([self.objects count] == 0) {
     
     }*/
    
        [query orderByDescending:@"createdAt"];
    
    return query;
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"RecipeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    UILabel *date = (UILabel*) [cell viewWithTag:102];
    
    // Configure the cell
    NSTimeInterval createdsec = [object.createdAt timeIntervalSinceNow];
    NSTimeInterval createdmins = createdsec/60.0f;
    NSTimeInterval createdhrs = createdmins/60.0f;
    NSTimeInterval createddays = createdmins/(60.0f*24.0f);
    NSTimeInterval createdweeks = createdmins/(60.0f*24.0f*7.0f);
    NSTimeInterval createdmons = createdmins/(60.0f*24.0f*30.0f);
    NSTimeInterval createdyrs = createdmins/(60.0f*24.0f*365.0f);
    NSString *sec =[NSString stringWithFormat:@"%f",createdsec];
    int sec_int = [sec intValue];
    NSString *mins =[NSString stringWithFormat:@"%f",createdmins];
    int mins_int = [mins intValue];
    NSString *hours =[NSString stringWithFormat:@"%f",createdhrs];
    int hrs_int = [hours intValue];
    NSString *days =[NSString stringWithFormat:@"%f",createddays];
    int days_int = [days intValue];
    NSString *weeks =[NSString stringWithFormat:@"%f",createdweeks];
    int weeks_int = [weeks intValue];
    NSString *mons =[NSString stringWithFormat:@"%f",createdmons];
    int mons_int = [mons intValue];
    NSString *years =[NSString stringWithFormat:@"%f",createdyrs];
    int years_int = [years intValue];
    if (createdsec > -4) {
        date.text =@"";
    }
    else  if (createdsec > -5) {
       date.text =@"Just now";
    }
    
    else  if (createdsec > -60) {
       date.text = [NSString stringWithFormat:@"%d s ago",sec_int*-1];
    }
    else  if (createdsec > -120) {
        
       date.text = @"A minute ago";
    }
    else  if (createdmins > -60) {
        
        date.text = [NSString stringWithFormat:@"%d mins ago",mins_int*-1];
    }
    else  if (createdmins > -120) {
        
        date.text = @"An hour ago";
    }
    else  if (createdmins > -(24 * 60)) {
        
       date.text = [NSString stringWithFormat:@"%d hrs ago",hrs_int*-1];
    }
    else  if (createdmins > -(24 * 60*2)) {
        
        date.text = @"Yesterday";
    }
    else  if (createdmins > -(24 * 60*7)) {
        
        date.text = [NSString stringWithFormat:@"%d days ago",days_int*-1];
    }
    else  if (createdmins > (24 * 60*14)) {
        
        date.text = @"Last week";
    }
    else  if (createdmins > -(24 * 60*31)) {
        
        date.text = [NSString stringWithFormat:@"%d weeks ago",weeks_int*-1];
    }
    else  if (createdmins > -(24 * 60*61)) {
        
        date.text = @"Last month";
    }
    else  if (createdmins > -(24 * 60*365.25)) {
        
       date.text = [NSString stringWithFormat:@"%d months ago",mons_int *-1];
    }
    else  if (createdmins > -(24 * 60*731)) {
        
        date.text = @"Last year";
    }
    else
    {
        date.text = [NSString stringWithFormat:@"%d years ago",years_int *-1];
    }

   PFFile *thumbnail = [object objectForKey:@"profile_image"];
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:100];
   
    //thumbnailImageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    thumbnailImageView.layer.cornerRadius= 8.0f;
    thumbnailImageView.layer.borderWidth=0.0;
    thumbnailImageView.layer.masksToBounds = YES;
    thumbnailImageView.layer.borderColor=[UIColor colorWithRed:45.0f/255.0f green:0.0f/255.0f blue:10.0f/255.0f alpha:1].CGColor;
    
    
    thumbnailImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //
    // thumbnailImageView.image = [UIImage imageNamed:@"image_icon.png"];
    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];

    
    UILabel *nameLabel = (UILabel*) [cell viewWithTag:101];
       nameLabel.text = [object objectForKey:@"username"];
    
    UITextView *content = (UITextView*) [cell viewWithTag:103];
     content.text = [object objectForKey:@"content"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    // Remove the row from data model
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    

    if ([object objectForKey:@"userid"]==[PFUser currentUser].objectId) {
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self refreshTable:nil];
        }];
    }
    else{};

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
         PFObject *object = [self.objects objectAtIndex:indexPath.row];
        NSLog(@"userid %@",[object objectForKey:@"userid"]);
        NSLog(@"pfuserobjectid %@",[PFUser currentUser].objectId );
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    
    if ([PFUser currentUser].objectId !=[object objectForKey:@"userid"]) {
        return NO;
    }
else
    return YES;


}
    

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    
    NSLog(@"error: %@", [error localizedDescription]);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    if ([segue.identifier isEqualToString:@"newcomment"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NewRecipeViewController *destViewController = segue.destinationViewController;
        
              TattooMasterCell *tattoomasterCell = [[TattooMasterCell alloc] init];
        
       
        tattoomasterCell.muay_id = self.tattoomasterCell.muay_id;
               destViewController.tattoomasterCell = tattoomasterCell;
        //  NSInteger myInteger = [tattoomasterCell.view integerValue];
        //  object[@"view"] =[NSNumber numberWithFloat:(myInteger+ 1)];
        //  [object saveInBackground];
 
        
       }
    
}


@end
