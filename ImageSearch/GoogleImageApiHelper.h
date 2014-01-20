//
//  GoogleImageApiHelper.h
//  ImageSearch
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleImageApiHelper : NSObject

+ (void)getImagesForSearchInput:(NSString *)searchText withBlock:(void (^)(BOOL succeeded, NSMutableArray *imageContentArray, NSError *error))completionBlock;


@end
