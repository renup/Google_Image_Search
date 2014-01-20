//
//  RPImageContent.m
//  ImageSearch
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import "RPImageContent.h"

@implementation RPImageContent

@synthesize searchResultContentStr, thumbURLStr, originalImageURLStr, thumbImage, originalImage, originalImageDownloaded, thumbImageDownloaded;

-(RPImageContent *)initRPImageContentWithImageDetails:(NSString *)searchResultStr itsThumbURLString:(NSString *)thumbURLString andFullImageURLString:(NSString *)fullImageURLString
{
    self.searchResultContentStr = searchResultStr;
    self.thumbURLStr = thumbURLString;
    self.originalImageURLStr = fullImageURLString;
    self.thumbImage = [UIImage imageNamed:@"Placeholder.png"];
    self.originalImage = [UIImage imageNamed:@"Placeholder.png"];
    self.thumbImageDownloaded = NO;
    self.originalImageDownloaded = NO;

    return self;
}

@end
