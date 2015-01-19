//
//  AppDelegate.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 28/7/14.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "AppDelegate.h"
#import "SidebarViewController.h"
#import "MainViewController.h"
#import "LoginUIViewController.h"
#import "news_ViewController.h"
//#import "GAI.h"
@implementation AppDelegate
UINavigationController *navigation;
LoginUIViewController *viewController ;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    sleep(1);

   
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];


    
    //然后这里设定关联，此处把indexPath关联到alert上
    


          // Optional: automatically send uncaught exceptions to Google Analytics.
  //  [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
  //  [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
  //  [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
   // [[GAI sharedInstance] trackerWithTrackingId:@"UA-56329849-2"];

    // Override point for customization after application launch.
    [Parse setApplicationId:@"Edo4mqMRpZRho3V0KMhNU3L56qFh9TOQ1SfwMx6o"
                  clientKey:@"a1pOFTR9QQrDIZcYo6TaCi4z49wlPqxNDDS71mHv"];
    [PFFacebookUtils initializeFacebook];
    // Override point for customization after application launch.
    //-- Set Notification
    PFQuery *query = [PFQuery queryWithClassName:@"muay_member"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:@"muay_id" equalTo:@"1"];
    [query whereKey:@"update_allert" equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] == 0) {
        }
        else
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下載最新版本"
                                                            message:@"需要前往App Store嗎？"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"前往",nil];
            
            [alert show];
        }}];

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation saveInBackground];


    //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"background.jpg"]
                                     //  forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:0/255.0 blue:30.0/255.0 alpha:1.0]];
    
     //  [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.755 green:0.655 blue:0.0 alpha:1]];
        NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"TimesNewRomanPS-ItalicMT" size:21.0], NSFontAttributeName, nil]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
   // NSLog(@"hehe%@",[PFInstallation currentInstallation].installationId  );
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    [UINavigationBar appearance].translucent=NO;
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
       return YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
       if([button isEqualToString:@"前往"])
    {
        NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id946793334"];
        [[UIApplication sharedApplication] openURL:itunesURL];
        
        
    }
    
}
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
    NSLog(@"%@",currentInstallation);


}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [[PFFacebookUtils session] close];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


@end
