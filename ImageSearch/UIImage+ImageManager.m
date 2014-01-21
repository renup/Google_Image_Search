//
//  UIImage+ImageManager.m
//  ImageViewer
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import "UIImage+ImageManager.h"

@implementation UIImage (ImageManager)


- (UIImage *)resizeImageToWidth:(float)widthVal andHeight:(float)heightVal
{
    CGSize newSize = CGSizeMake(widthVal, heightVal);
    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
