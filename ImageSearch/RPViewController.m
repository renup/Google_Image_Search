//
//  RPViewController.m
//  ImageSearch
//
//  Created by Renu P on 1/17/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import "RPViewController.h"
#import "GoogleImageApiHelper.h"
#import "RPImageContent.h"
#import "RPBaseCell.h"
#import "RPDetailViewController.h"

@interface RPViewController (){
    RPImageContent *imageContentObject;
}

@property (nonatomic) IBOutlet UISearchBar *searchTextfield;
@property (nonatomic) NSMutableArray *searchResultsArray;


@end

@implementation RPViewController
@synthesize searchTextfield, searchResultsArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.searchResultsArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar                    // called when cancel button pressed
{
    [self.searchResultsArray removeAllObjects];
//    [[AppCache sharedAppCache] cleanUpWholeCache];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear)
{
    if ([searchText length]>0) {
        [self.searchResultsArray removeAllObjects];
        [self getImagesForSearchStr:searchText];
    }else{
        [self.searchResultsArray removeAllObjects];
//        [[AppCache sharedAppCache] cleanUpWholeCache];
    }
    
}

-(void) getImagesForSearchStr:(NSString*) searchText
{
    //Remove the cache for old strings here
//    [[AppCache sharedAppCache] cleanUpCacheExceptFinalSearchString:searchText];
    
    [GoogleImageApiHelper getImagesForSearchInput: searchText withBlock:^(BOOL succeeded, NSMutableArray *imageContentArray, NSError *error){
        if (succeeded) {
            self.searchResultsArray = imageContentArray;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
        }else{
            NSLog(@"Getting ERROR response from Google = %@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error while getting Images" message:@"Sorry couldn't fetch Images at this time" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BaseCell";
    
    RPBaseCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RPBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.cellInsetWidth = kCellInsetWidth;
    }else{
        //        NSLog(@"reused a cell!!!!!!");
    }

    UIImage *picture = nil; //[[AppCache sharedAppCache] getImageForString:searchTextfield.text forRow:indexPath.row];

    if (!picture) { //if not cached yet
        imageContentObject = [self.searchResultsArray objectAtIndex:indexPath.row];
        cell.imageView.image = imageContentObject.thumbImage;
        if (imageContentObject.thumbImageDownloaded == NO){
            
            [FileDownloadManager downloadAndGetImageForURL:imageContentObject.thumbURLStr
                                          andKeyForCaching:searchTextfield.text
                                              forRowNumber:indexPath.row
                                                     block:^(BOOL succeeded, UIImage *image, NSError *error)
             {
                 if (succeeded) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIImage* resizedImage = [image resizeImageToWidth:image.size.width andHeight:kCellHeight];
                         cell.cellImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kCellHeight);
                         imageContentObject.thumbImageDownloaded = YES;
                         imageContentObject.thumbImage = resizedImage;
                         cell.cellImageView.image = resizedImage;

//                         [[AppCache sharedAppCache] setImage:resizedImage forString:searchTextfield.text forRow:indexPath.row];
                     });
                 }else{
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Image Download Error" message:@"Sorry couldn't download the search pictures" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     [alert show];
                     
                     NSLog(@"Error in downloading the image in cellForRowAtIndexPath - %@", error);
                 }
             }];
        }
    }
//    else{
////        cell.cellImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, picture.size.height);
////        NSLog(@"From cache - %@", searchTextfield.text);
//        cell.cellImageView.image = picture;
//    }
    
    return cell;
}



#pragma mark - UITableViewDelegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  kCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    imageContentObject = [self.searchResultsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ViewControllerToDetailVC" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RPDetailViewController *photoDetailVC = [segue destinationViewController];
    photoDetailVC.fullImageURLString = imageContentObject.originalImageURLStr;
    photoDetailVC.searchString = searchTextfield.text;

}


@end
