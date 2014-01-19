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

@interface RPViewController (){
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Content Filtering
//
- (void)updateFilteredContentForSearchString:(NSString *)searchString
{
    // strip out all the leading and trailing spaces
    NSString *strippedStr = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedStr.length > 0)
    {
        searchItems = [strippedStr componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    NSCompoundPredicate *finalCompoundPredicate = nil;
    
    for (NSString *searchString in searchItems)
    {
        // each searchString creates an OR predicate for more than one word typed in search bar for the value - searchResultContentStr in ImageContent Object
        //
        // example if searchItems contains "fuzzy monkey":
        //      searchResultContentStr CONTAINS[c] "fuzzy"
        //      searchResultContentStr CONTAINS[c] "monkey",
        
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];

        // name field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath: @"searchResultContentStr"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        // add this to our OR predicate - final predicate. This will make sure, our final predicate contains any of the words typed in the search bar
        finalCompoundPredicate =
        (NSCompoundPredicate *)[NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
    }
    self.searchResultsArray = [[self.searchResultsArray filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
}



#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [GoogleImageApiHelper getImagesForSearchInput:searchString withBlock:^(BOOL succeeded, NSArray *jsonArray, NSError *error) {
    if (succeeded) {
        
        for(NSDictionary *imageDict in jsonArray){
            RPImageContent *imageContentObj = [[RPImageContent alloc] initRPImageContentWithImageDetails:[imageDict objectForKey: kMatchingSearchText] itsThumbURLString:[imageDict objectForKey: kThumbImageURLString] andFullImageURLString:[imageDict objectForKey: kOriginalImageURLString]];
            [self.searchResultsArray addObject:imageContentObj];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateFilteredContentForSearchString:searchString];
        });
    }
}];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.numberOfLines = 0;
//
    cell.imageView.layer.backgroundColor=[[UIColor clearColor] CGColor];
    cell.imageView.layer.cornerRadius=10;
    cell.imageView.layer.borderWidth=1.50;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.borderColor=[[UIColor blackColor] CGColor];
    
    RPImageContent *imageContentObject = [self.searchResultsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = imageContentObject.searchResultContentStr;

    return cell;
}

#pragma mark - UITableViewDelegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RPImageContent *imageContentobj = [self.searchResultsArray objectAtIndex:indexPath.row];
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:imageContentobj.searchResultContentStr
                                                                            attributes:
                                             @{ NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    
    //its not possible to get the cell label width since this method is called before cellForRow so best we can do
    //is get the table width and subtract the default extra space on either side of the label.
    CGSize constraintSize = CGSizeMake(tableView.frame.size.width - 30, MAXFLOAT);
    
    CGRect rect = [attributedString boundingRectWithSize:constraintSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    
    //Add back in the extra padding above and below label on table cell.
    rect.size.height = rect.size.height + 43;
    
    //if height is smaller than a normal row set it to the normal cell height, otherwise return the bigger dynamic height.
    return (rect.size.height < 44 ? 44 : rect.size.height);
}


@end
