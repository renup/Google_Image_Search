//
//  RPAppDelegate.m
//  ImageSearch
//
//  Created by Renu P on 1/17/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import "RPAppDelegate.h"

@implementation RPAppDelegate

@synthesize networkConnectionStatus, networkType;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    self.networkConnectionStatus=YES;
    
    internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
	[self updateInterfaceWithReachability: internetReach];
    return YES;
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Reachability methods
//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* currentReachability = [note object];
    NSParameterAssert([currentReachability isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: currentReachability];
}

- (void) updateInterfaceWithReachability: (Reachability*) currentReach
{
   	if(currentReach == internetReach)
	{
		[self configureNetworkStatus:currentReach];
	}
	else if(currentReach == wifiReach)
	{
        [self configureNetworkStatus:currentReach];
	}
	
}

-(void)configureNetworkStatus:(Reachability*) curReach{
    NetworkStatus internetStatus = [curReach currentReachabilityStatus];
    
    switch (internetStatus)
    {
        case NotReachable:
        {
            self.networkType= @"No network";
            
            self.networkConnectionStatus=NO;
            
            [self noInternet];
            break;
        }
            
        case ReachableViaWWAN:
        {
            if (self.networkConnectionStatus==NO) {
                
                [self networkConnect];
                
            }
            self.networkType= @"WWAN";
            
            self.networkConnectionStatus=YES;
            break;
        }
        case ReachableViaWiFi:
        {
            if (self.networkConnectionStatus==NO) {
                
                [self networkConnect];
            }
            self.networkType= @"WIFI";
            
            self.networkConnectionStatus=YES;
            break;
        }
    }
}


-(void)noInternet
{
    UIImage *backgroundImage = [UIImage imageNamed:@"noImage.png"];
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    backgroundImageView.frame = CGRectMake(0, 0, self.window.rootViewController.view.frame.size.width, self.window.rootViewController.view.frame.size.height);
    networkView  = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    networkView.backgroundColor = [UIColor whiteColor];
    [networkView addSubview:backgroundImageView];
    
    UILabel *connectivityStatusLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.window.rootViewController.view.frame.size.width, 50)];
    connectivityStatusLabel.textColor=[UIColor blackColor];
    connectivityStatusLabel.font=[UIFont boldSystemFontOfSize:25.0f];
    connectivityStatusLabel.text=@"No Internet Connection";
    connectivityStatusLabel.textAlignment = NSTextAlignmentCenter;
    connectivityStatusLabel.backgroundColor=[UIColor clearColor];
    [networkView addSubview:connectivityStatusLabel];
    
    UIImage *wifiImage = [UIImage imageNamed:@"wifi.png"];
    UIImageView *wifiImageView = [[UIImageView alloc] initWithImage:wifiImage];
    wifiImageView.frame=CGRectMake(self.window.rootViewController.view.frame.size.width/4,120,wifiImage.size.width,wifiImage.size.height);
    wifiImageView.center = self.window.rootViewController.view.center;
    [networkView addSubview:wifiImageView];
    
    [self.window.rootViewController.view addSubview: networkView];
}

-(void)networkConnect{
    [networkView removeFromSuperview];
}


@end
