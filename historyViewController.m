//
//  historyViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 6/10/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import "historyViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
@interface historyViewController ()

@end

@implementation historyViewController

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
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    [super viewDidLoad];
    NSDictionary *dimensions = @{ @"Notice":@"Muay_History"};
    [PFAnalytics trackEvent:@"show_History" dimensions:dimensions];
    _sidebarButton.tintColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    // Do any additional setup after loading the view.
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.title=@"泰拳歷史";
   
    self.textview_1.layer.cornerRadius=8.0f;
    self.textview_1.layer.borderWidth=2.0;
    self.textview_1.layer.borderColor =[[UIColor colorWithRed:150.0/255.0
                                                        green:150.0/255.0
                                                         blue:150.0/255.0
                                                        alpha:1.0] CGColor];
    
    self.textview_1.layer.cornerRadius=8.0f;
    self.textview_1.layer.borderWidth=0.0;
    //for use labrect with UITextView you set the font of UITextView:
    //label.font = [UIFont systemFontOfSize:17];
    
    
    
    
    [self.textview_1 setUserInteractionEnabled:YES];
    [self.textview_1 setScrollEnabled:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)sidebarButton:(id)sender {
}
@end
