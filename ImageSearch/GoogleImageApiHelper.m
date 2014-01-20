//
//  GoogleImageApiHelper.m
//  ImageSearch
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import "GoogleImageApiHelper.h"
#import "RPImageContent.h"

@implementation GoogleImageApiHelper

+ (void)getImagesForSearchInput:(NSString *)searchText withBlock:(void (^)(BOOL succeeded, NSMutableArray *imageContentArray, NSError *error))completionBlock
{
    if (searchText.length > 0) {
        NSString *queryString;
        
        
        NSString* myIP = @"107.3.152.107";
        
        if ([searchText componentsSeparatedByString:@" "].count > 0) {
            NSMutableString *stringWithSpaces = [[searchText stringByReplacingOccurrencesOfString:@" " withString:@"%20"] mutableCopy];
            queryString =[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@&userip=%@",stringWithSpaces, myIP];
        }else{ //without spaces (one word) string
            queryString =[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@&userip=%@",searchText, myIP];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
            NSURL *jsonURL = [NSURL URLWithString:queryString];
            NSLog(@"about to download %@", queryString);
            NSError* err;
            NSData *jsonData = [NSData dataWithContentsOfURL:jsonURL options:NSDataReadingUncached error:&err];

            if (!err)
            {
                if (jsonData)
                {
                    NSDictionary *parsedJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
                    NSNumber *status = [parsedJSON objectForKey:@"responseStatus"];
                    if ([status intValue] == 200) {
                        NSArray *imagesArray = [[parsedJSON objectForKey:@"responseData"] objectForKey:@"results"];
                        NSMutableArray* imageContentArray = [NSMutableArray array];
                        
                        for(NSDictionary *imageDict in imagesArray){
                            RPImageContent *imageContentObj = [[RPImageContent alloc]
                                                               initRPImageContentWithImageDetails:[imageDict objectForKey: kMatchingSearchText]
                                                               itsThumbURLString:[imageDict objectForKey: kThumbImageURLString]
                                                               andFullImageURLString:[imageDict objectForKey: kOriginalImageURLString]];
                            [imageContentArray addObject:imageContentObj];
                        }
                        
                        NSLog(@"DONE download %@ - size:%d", queryString, [imageContentArray count]);
                        
                        if(completionBlock)
                            completionBlock(TRUE, imageContentArray, nil);
                        
                    }else{
                        NSLog(@"ERROR while downloading: %@, status: %@ ", [parsedJSON objectForKey:@"responseDetails"], [parsedJSON objectForKey:@"responseStatus"]);
                    }
                }else{
                    NSLog(@"Error with query string");
                    if (completionBlock) {
                        completionBlock(FALSE, nil, nil);
                    }
                }
            }
            else
                NSLog(@"Error while downloading image - %@", err.description);
        });
    }
}


@end
