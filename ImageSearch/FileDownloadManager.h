//
//  FileDownloadManager.h
//  ImageSearch
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

/** This is a helper class. It is used for downloading files */
#import <Foundation/Foundation.h>

@interface FileDownloadManager : NSObject

/** Downloads the image using the URL value that is passed in. This method is called from RPViewController while diplaying thumb images in the tableview cells. This method is also called from RPDetailViewController to display the image in that View controller */
+(void)downloadAndGetImageForURL:(NSString *)imageString
                andKeyForCaching:(NSString *)searchString
                    forRowNumber:(int)rowNumber
                           block:(void (^)(BOOL succeeded, UIImage *image, NSError *error))blockAfterCompletion;

/** Simply downloads the file given a URL str and reports back to the calling method through the call back block */
+(void)downloadTheFile:(NSString *)URLStr
                 block:(void (^)(BOOL succeeded, NSData *data, NSError *error))completionBlock;

@end
