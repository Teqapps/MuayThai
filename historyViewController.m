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
    self.textview_1.text=@"在史前時代，當人類還處於原始的生存條件下，為了維持自身的安全，以及來自大自然的強大壓力都迫使人類你爭我奪，相互鬥爭。 起初為生命，家庭和整個部落而鬥，他們最初是利和簡單武器例如籐杖和棍棒等，後來又擴展到用嘴巴，手和腳去咬，抓和踢等等。 後來，人類慢慢進展傾向於團體式的生活，群體之中，注定要有一個人來承擔領導者的職責，這必須是一個富有技巧，具有超人的力量，超出群體中其他人的優良品質的男人，以幫助群體戰勝來自自群體外的敵人。領導人是由選舉產生，他們會用與生俱來的武器如拳頭，肘和腳等來戰鬥，而”古泰拳”亦因此應運而生。 在戰時，泰拳就己經在軍中被用以訓練士兵，提高士兵的戰鬥力，在戰時，泰拳的操練有助於泰國士兵與敵人交鋒得到勝利，而在和平時期，士兵們操練泰拳的主要目的是鍛鍊身體，以備戰時之需。";
    self.textview_1.layer.cornerRadius=8.0f;
    self.textview_1.layer.borderWidth=2.0;
    self.textview_1.layer.borderColor =[[UIColor colorWithRed:150.0/255.0
                                                        green:150.0/255.0
                                                         blue:150.0/255.0
                                                        alpha:1.0] CGColor];
    
    self.textview_1.layer.cornerRadius=8.0f;
    self.textview_1.layer.borderWidth=1.0;
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
