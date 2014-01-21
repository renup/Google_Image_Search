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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
	// Do any additional setup after loading the view.
    [FileDownloadManager downloadAndGetImageForURL:self.fullImageURLString andKeyForCaching:self.searchString forRowNumber: 100 block:^(BOOL succeeded, UIImage *image, NSError *error) {
        if (succeeded) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage * resizedImage;
               resizedImage = [image resizeImageToWidth:self.photoView.frame.size.width andHeight:self.photoView.frame.size.height];
                self.photoView.image = resizedImage;
                [self centerImage];

                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Download Error" message:@"Sorry couldn't download the full picture" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            NSLog(@"Error while downloading full image in DetailVC");
        }
    }];
    
}

-(void)centerImage{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGSize imageSize = self.photoView.image.size;
    CGFloat differenceWidth = screenSize.width - imageSize.width;
    CGFloat differenceHeight = screenSize.height - imageSize.height;
    
    scrollView.frame = self.view.frame;
    
    scrollView.contentSize = imageSize;
    
    if (differenceWidth <= 0 && differenceHeight >=0) {
        self.photoView.frame = CGRectMake(0, differenceHeight/2, imageSize.width, imageSize.height);
        [scrollView setContentOffset:CGPointMake(-(differenceWidth/2), 0) animated:NO];
    }
    else if (differenceHeight <=0 && differenceWidth >=0){
        self.photoView.frame = CGRectMake(differenceWidth/2, 0, imageSize.width, imageSize.height);
        [scrollView setContentOffset:CGPointMake(0, -(differenceHeight/2)) animated:NO];
    }
    else if (differenceWidth <= 0 && differenceHeight <= 0){
        self.photoView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        [scrollView setContentOffset:CGPointMake(-(differenceWidth/2), -(differenceHeight/2)) animated:NO];
    }
    else{
        self.photoView.frame = CGRectMake(differenceWidth/2, differenceHeight/2, imageSize.width, imageSize.height);
    }
    
    //    cellImageView.frame = CGRectMake(differenceWidth/2,differenceHeight/2,imageSize.width,imageSize.height);
    //    [scrollView setContentOffset:CGPointMake(90, 0) animated:NO];
    
    [scrollView setScrollEnabled:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
