//
//  GoogleImageApiHelper.m
//  ImageSearch
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import "GoogleImageApiHelper.h"

@implementation GoogleImageApiHelper

+ (void)getImagesForSearchInput:(NSString *)searchText withBlock:(void (^)(BOOL succeeded, NSArray *jsonArray, NSError *error))completionBlock
{
    if (searchText.length > 0) {
        NSString *queryString;
        
        if ([searchText componentsSeparatedByString:@" "].count > 0) {
            NSMutableString *stringWithSpaces = [[searchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
            queryString =[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@",stringWithSpaces];
        }else{ //without spaces (one word) string
            queryString =[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@",searchText];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
            NSURL *jsonURL = [NSURL URLWithString:queryString];
            NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL];
            
            if (jsonData) {
                NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
                NSArray *imagesArray = [[parsedJSON objectForKey:@"responseData"] objectForKey:@"results"];

                if(completionBlock)
                    completionBlock(TRUE, imagesArray, nil);
            }else{
                NSLog(@"Error with query string");
                if (completionBlock) {
                    completionBlock(FALSE, nil, nil);
                }
            }
        });
    }
}


@end
