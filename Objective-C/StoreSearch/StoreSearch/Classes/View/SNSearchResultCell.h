//
//  SNSearchResultCell.h
//  StoreSearch
//
//  Created by solon on 16/5/29.
//  Copyright © 2016年 solon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SNSearchResult;

@interface SNSearchResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;

- (void)configureForSearchResult:(SNSearchResult *)searchResult;
@end
