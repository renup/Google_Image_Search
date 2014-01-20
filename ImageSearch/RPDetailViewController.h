//
//  RPDetailViewController.h
//  ImageSearch
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageManager.h"
#import "FileDownloadManager.h" //Imported in .h file because note that RPViewController class has imported RPDetailViewController. That makes all imports in this class available for RPViewController class as well which includes the FileDownloadManager and UIImage+ImageManager class also.



@interface RPDetailViewController : UIViewController

@property (nonatomic)NSString *fullImageURLString;
@property (nonatomic)NSString *searchString;

@end
