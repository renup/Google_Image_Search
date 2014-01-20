//
//  AppCache.m
//  ImageViewer
//
//  Created by Renu P on 1/12/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import "AppCache.h"

@interface AppCache(){
    NSMutableArray *keysArray;
}

@property (nonatomic, strong)NSCache *cache;

@end


@implementation AppCache

@synthesize cache;

+ (id)sharedAppCache
{
    static AppCache *sharedMyManager = nil;
    
    static dispatch_once_t onceToken;
 
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        sharedMyManager.cache = [[NSCache alloc] init];
    });
    
    return sharedMyManager;
}

-(AppCache *)init
{
    self = [super init];
    if (self) {
        keysArray = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)setImage:(UIImage *)pic forString:(NSString *)searchString forRow:(int)rowNumber
{
    if (pic != nil) {
        [keysArray addObject:[NSString stringWithFormat:@"%@_%i", searchString, rowNumber]];
        [self.cache setObject:pic forKey:[NSString stringWithFormat:@"%@_%i", searchString, rowNumber]];
    }
}

-(UIImage *)getImageForString:(NSString *)searchString forRow:(int)rowNumber
{
   return [self.cache objectForKey:[NSString stringWithFormat:@"%@_%i", searchString, rowNumber]];
}

-(void)cleanUpCacheExceptFinalSearchString:(NSString *)finalSearchString
{
    return;
    NSMutableArray *keysToKeep = [[NSMutableArray alloc] init];
    if (finalSearchString != nil && finalSearchString.length > 1) {
        for(NSString *searchString in keysArray){
            char startingLetter = [finalSearchString characterAtIndex:0];

            if ([searchString hasPrefix:[NSString stringWithFormat:@"%c", startingLetter]] && [searchString rangeOfString:finalSearchString options:NSCaseInsensitiveSearch].location == NSNotFound)
                [self.cache removeObjectForKey:searchString];
            else if ([searchString rangeOfString:finalSearchString options:NSCaseInsensitiveSearch].location != NSNotFound)
                     [keysToKeep addObject:searchString];
        }
    }
    [keysArray removeAllObjects];
    keysArray = keysToKeep;
}

-(void)cleanUpWholeCache
{
    [self.cache removeAllObjects];
}

@end
