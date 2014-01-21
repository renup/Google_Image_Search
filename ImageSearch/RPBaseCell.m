//
//  RPBaseCell.m
//  ImageSearch
//
//  Created by Renu P on 1/18/14.
//  Copyright (c) 2014 Renu Punjabi. All rights reserved.
//

#import "RPBaseCell.h"

@interface RPBaseCell(){
    BOOL hideSeparator; // True if the separator shouldn't be shown
}

@end

@implementation RPBaseCell

@synthesize cellImageView, cellInsetWidth;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.cellInsetWidth = 0.0f;
        hideSeparator = NO;
        self.clipsToBounds = NO;
        
        self.opaque = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.backgroundColor = [UIColor clearColor];
        
        self.cellImageView = [[UIImageView alloc] init];
        self.cellImageView.backgroundColor = [UIColor clearColor];
        self.cellImageView.opaque = YES;
        [self addSubview:self.cellImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
