//
//  SNSearchResult.m
//  StoreSearch
//
//  Created by solon on 16/5/29.
//  Copyright © 2016年 solon. All rights reserved.
//

#import "SNSearchResult.h"

@implementation SNSearchResult

- (NSComparisonResult)compareName:(SNSearchResult *)other
{
    return [_name localizedStandardCompare:other.name];
}

@end
