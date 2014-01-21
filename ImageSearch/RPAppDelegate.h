//
//  RPAppDelegate.h
//  ImageSearch
//
//  Created by Renu P on 1/17/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface RPAppDelegate : UIResponder <UIApplicationDelegate>{
    Reachability* internetReach;
    Reachability* wifiReach;
    UIView *networkView;
}

@property (strong, nonatomic) UIWindow *window;

/** BOOL value indicating the status of presence of network */
@property (nonatomic) BOOL networkConnectionStatus;

/** NSString indicating the type of network */
@property (nonatomic) NSString *networkType;

@end
