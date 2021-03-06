//
//  RPImageContent.h
//  ImageSearch
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//


/**This class saves the result objects as RPImageContent objects */
#import <Foundation/Foundation.h>

@interface RPImageContent : NSObject

@property (nonatomic, copy)NSString *searchResultContentStr;
@property (nonatomic, copy)NSString *thumbURLStr;
@property (nonatomic, copy)NSString *originalImageURLStr;
@property (nonatomic, copy)UIImage *thumbImage;
@property (nonatomic, copy)UIImage *originalImage;
@property (nonatomic, assign)BOOL thumbImageDownloaded;
@property (nonatomic, assign)BOOL originalImageDownloaded;


//Initiating instance of this class
-(RPImageContent *)initRPImageContentWithImageDetails:(NSString *)searchResultStr itsThumbURLString:(NSString *)thumbURLString andFullImageURLString:(NSString *)fullImageURLString;


@end
