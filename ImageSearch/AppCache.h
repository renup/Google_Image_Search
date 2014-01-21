//
//  AppCache.h
//  ImageViewer
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

//This class caches all the images so that we don't have to fresh download each time user scrolls repeatedly table view in RPViewController or the full image in RPDetailViewController
#import <Foundation/Foundation.h>

@interface AppCache : NSObject

/** Creating a singleton AppCache object */
+(id)sharedAppCache;

/** Creating Setters and Getters for images stored in the cache */
-(void)setImage:(UIImage *)pic forString:(NSString *)searchString forRow:(int)rowNumber;
-(UIImage *)getImageForString:(NSString *)searchString forRow:(int)rowNumber;

-(void)cleanUpCacheExceptFinalSearchString:(NSString *)finalSearchString;

-(void)cleanUpWholeCache;


@end
