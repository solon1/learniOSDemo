//
//  SNSearchResult.h
//  StoreSearch
//
//  Created by solon on 16/5/29.
//  Copyright © 2016年 solon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNSearchResult : NSObject

/** name */
@property (nonatomic,copy) NSString *name;
/** artistName */
@property (nonatomic,copy) NSString *artistName;
/** 60 * 60image */
@property (nonatomic, copy) NSString *artworkURL60;
/** 100 * 100 image */
@property (nonatomic, copy) NSString *artworkURL100;

@property (nonatomic, copy) NSString *storeURL;
@property (nonatomic, copy) NSString *kind;
/** 货币 */
@property (nonatomic, copy) NSString *currency;
@property (nonatomic, copy) NSDecimalNumber *price;
/** 流派 */
@property (nonatomic, copy) NSString *genre;

- (NSComparisonResult)compareName:(SNSearchResult *)other;

@end
