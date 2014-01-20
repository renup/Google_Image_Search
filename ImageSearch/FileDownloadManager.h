//
//  FileDownloadManager.h
//  ImageViewer
//
//  Created by Renu P on 1/11/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

/** This is a helper class. It is used for downloading files */
#import <Foundation/Foundation.h>

@interface FileDownloadManager : NSObject

/** Downloads the image using the URL value that is passed in. "imageNeedResizing" value determines wether the image needs to be reseized or not. This method is called from MasterViewController while diplaying thumb images in the tableview cells. This method is also called from DetailView controller to display the image in that View controller */
+(void)downloadAndGetImageForURL:(NSString *)imageString
                andKeyForCaching:(NSString *)searchString
                    forRowNumber:(int)rowNumber
                           block:(void (^)(BOOL succeeded, UIImage *image, NSError *error))blockAfterCompletion;

/** Simply downloads the file given a URL str and reports back to the calling method through the call back block */
+(void)downloadTheFile:(NSString *)URLStr
                 block:(void (^)(BOOL succeeded, NSData *data, NSError *error))completionBlock;

/** Downloads JSON file for the URL string that is passed in and returns the contents of JSON in an array. This method is called from MasterViewController where the respective caption string and images will be displyed based on the result returned in the call back block */
+(void)downloadAndGetJSONForURL:(NSString *)URLStr
                          block:(void (^)(BOOL succeeded, NSArray* jsonArr, NSError *error))blockForCompletion;

@end
