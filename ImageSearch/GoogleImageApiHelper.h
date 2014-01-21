//
//  GoogleImageApiHelper.h
//  ImageSearch
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

/**Google API helper class. */
#import <Foundation/Foundation.h>

@interface GoogleImageApiHelper : NSObject

/** Gets Images for search text entered by user */
+ (void)getImagesForSearchInput:(NSString *)searchText withBlock:(void (^)(BOOL succeeded, NSMutableArray *imageContentArray, NSError *error))completionBlock;


@end
