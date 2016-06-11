//
//  SNSearchResultCell.m
//  StoreSearch
//
//  Created by solon on 16/5/29.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "SNSearchResultCell.h"
#import "SNSearchResult.h"
#import "UIImageView+AFNetworking.h"

@interface SNSearchResultCell()

@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;


@end

@implementation SNSearchResultCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    UIView *selectedView = [[UIView alloc]initWithFrame:CGRectZero];
    selectedView.backgroundColor = [UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:0.5];
    
    self.selectedBackgroundView = selectedView;
}

- (void)configureForSearchResult:(SNSearchResult *)searchResult
{
    self.nameLabel.text = searchResult.name;
    //        searchResultCell.artistNameLabel.text = searchResult.artistName;
    NSString *artistName = searchResult.artistName;
    
    if (artistName == nil) {
        artistName = @"Unknown";
    }
    NSString *kind = searchResult.kind;
    
    
    self.artistNameLabel.text = [NSString stringWithFormat:@"%@(%@)",artistName,kind];
    
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:searchResult.artworkURL60] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
}


#pragma mark - 避免cell重用机制导致图片错位，在cell重用时复位
- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.artworkImageView cancelImageDownloadTask];
    self.nameLabel.text = nil;
    self.artistNameLabel.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
