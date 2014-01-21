//
//  RPDetailViewController.h
//  ImageSearch
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ImageManager.h"
#import "FileDownloadManager.h"
#import "MBProgressHUD.h"

/**This class shows the full image of the thumb image selected in RPViewController */
@interface RPDetailViewController : UIViewController

@property (nonatomic)NSString *fullImageURLString;
@property (nonatomic)NSString *searchString;

@end
