//
//  noticeViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 6/10/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import "noticeViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
@interface noticeViewController ()

@end

@implementation noticeViewController

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
    NSDictionary *dimensions = @{ @"Notice":@"Muay_Notice"};
    [PFAnalytics trackEvent:@"show_Notice" dimensions:dimensions];
    self.title=@"泰拳注意事項";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textview_1.layer.cornerRadius=8.0f;
    self.textview_1.layer.borderWidth=2.0;
    self.textview_1.layer.borderColor =[[UIColor colorWithRed:150.0/255.0
                                                        green:150.0/255.0
                                                         blue:150.0/255.0
                                                        alpha:1.0] CGColor];
    
    
    _sidebarButton.tintColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    // Do any additional setup after loading the view.
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _sidebarButton.tintColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    // Do any additional setup after loading the view.
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //self.title =@"紋身注意事項";
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
