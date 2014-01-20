//
//  RPDetailViewController.m
//  ImageSearch
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import "RPDetailViewController.h"

@interface RPDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation RPDetailViewController

@synthesize photoView, fullImageURLString, searchString, scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [FileDownloadManager downloadAndGetImageForURL:self.fullImageURLString andKeyForCaching:self.searchString forRowNumber: 100 block:^(BOOL succeeded, UIImage *image, NSError *error) {
        if (succeeded) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage * resizedImage;
                resizedImage = [image resizeImageToWidth:self.photoView.frame.size.width andHeight:self.photoView.frame.size.height];
                
                if (resizedImage.size.width > self.view.frame.size.width)
                    self.scrollView.contentSize = CGSizeMake(resizedImage.size.width + (resizedImage.size.width - self.view.frame.size.width), resizedImage.size.height);
                else if (resizedImage.size.height > self.view.frame.size.height)
                    self.scrollView.contentSize = CGSizeMake(resizedImage.size.width, resizedImage.size.height + (resizedImage.size.height - self.view.frame.size.height));
                else
                    self.scrollView.contentSize = CGSizeMake(resizedImage.size.width, resizedImage.size.height);


                self.photoView.image = resizedImage;
            });
        }else{
            NSLog(@"Error while downloading full image in DetailVC");
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
