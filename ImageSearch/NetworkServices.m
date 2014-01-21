//
//  NetworkServices.m
//  ImageSearch
//
//  Created by Renu P on 1/20/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import "NetworkServices.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@implementation NetworkServices

/**
 * Returns the IP adress of the device.
 * Source: https://gist.github.com/JacobOscarson/7469727
 */
+ (NSString*)ipaddr {
    NSString *address = nil;
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    int success = 0;
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                if(strcmp(temp_addr->ifa_name, "en0") == 0) {
                    address = [NSString
                               stringWithUTF8String:
                               inet_ntoa(((struct sockaddr_in *)
                                          temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@end