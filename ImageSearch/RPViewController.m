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
#import "FileDownloadManager.h"
#import "UIImage+ImageManager.h"

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
    self.searchResultsArray = [[NSMutableArray alloc] init];
 //   [self configureSearchBarView:searchTextfield];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//
//
//#pragma mark -
//#pragma mark UISearchDisplayController Delegate Methods
//


- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar                    // called when cancel button pressed
{
    [self.searchResultsArray removeAllObjects];
    [[AppCache sharedAppCache] cleanUpWholeCache];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText   // called when text changes (including clear)
{
    if ([searchText length]>0) {
        [self.searchResultsArray removeAllObjects];
        [self getImagesForSearchStr:searchText];
        NSLog(@"SEARCHING %@", searchText);
    }else{
        [self.searchResultsArray removeAllObjects];
        [[AppCache sharedAppCache] cleanUpWholeCache];
    }
    
}

-(void) getImagesForSearchStr:(NSString*) searchText
{
    //Remove the cache for old strings here

    [GoogleImageApiHelper getImagesForSearchInput: searchText withBlock:^(BOOL succeeded, NSMutableArray *imageContentArray, NSError *error){
        if (succeeded) {
            self.searchResultsArray = imageContentArray;
            NSLog(@"Size of imageContentArray = %d",[imageContentArray count]);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //            [self updateFilteredContentForSearchString:searchString];
                [self.searchDisplayController.searchResultsTableView reloadData];
            });
        }else
            NSLog(@"getting imagecontent failed");
    }];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar // called when text ends editing - search button clicked or scrolling the tableview and the keyboard gets dismissed
{
//    NSLog(@"cleaning partial cache");
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
    UIImage *picture = nil;//[[AppCache sharedAppCache] getImageForString:searchTextfield.text forRow:indexPath.row];
    
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
                                             NSLog(@"downloaded image - %@", searchTextfield.text);
                         cell.cellImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170);
                         UIImage* resizedImage = [image resizeImageToWidth:image.size.width andHeight:170];
                         imageContentObject.thumbImageDownloaded = YES;
                         imageContentObject.thumbImage = resizedImage;
                         cell.cellImageView.image = resizedImage;

                         [[AppCache sharedAppCache] setImage:resizedImage forString:searchTextfield.text forRow:indexPath.row];
                     });
                 }else{
                     NSLog(@"Error in downloading the image in cellForRowAtIndexPath - %@", error);
                 }
             }];
        }
    }else{
        cell.cellImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, picture.size.height);
//        NSLog(@"From cache - %@", searchTextfield.text);
        cell.cellImageView.image = picture;
    }
    
    return cell;
}



#pragma mark - UITableViewDelegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  170;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RPImageContent *imageObject = [self.searchResultsArray objectAtIndex:indexPath.row];
    
}
@end
