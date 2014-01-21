//
//  UIImage+ImageManager.h
//  ImageViewer
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageManager)

/** This method resizes the original image to specific size by passing the values in this method */
- (UIImage *)resizeImageToWidth:(float)widthVal andHeight:(float)heightVal;

@end
