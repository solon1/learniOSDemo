//
//  SNSearchResultCell.m
//  StoreSearch
//
//  Created by solon on 16/5/29.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "SNSearchResultCell.h"

@implementation SNSearchResultCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    UIView *selectedView = [[UIView alloc]initWithFrame:CGRectZero];
    selectedView.backgroundColor = [UIColor colorWithRed:20/255.0f green:160/255.0f blue:160/255.0f alpha:0.5];
    
    self.selectedBackgroundView = selectedView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
