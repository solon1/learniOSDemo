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

- (NSString *)kind
{
    if (_kind) {
        
        return [self kindForDisplay];
    }else {
        return _kind;
    }
}


#pragma mark - 过滤接收的数据kind
- (NSString *)kindForDisplay
{
    if ([_kind isEqualToString:@"album"]) {
        return @"Album";
    }else if ([_kind isEqualToString:@"audiobook"]) {
        return @"Audio Book";
    } else if ([_kind isEqualToString:@"book"]) {
        return @"Book";
    } else if ([_kind isEqualToString:@"ebook"]) {
        return @"E-Book";
    } else if ([_kind isEqualToString:@"feature-movie"]) {
        return @"Movie";
    } else if ([_kind isEqualToString:@"music-video"]) {
        return @"Music Video";
    } else if ([_kind isEqualToString:@"podcast"]) {
        return @"Podcast";
    } else if ([_kind isEqualToString:@"software"]) {
        return @"App";
    } else if ([_kind isEqualToString:@"song"]) {
        return @"Song";
    } else if ([_kind isEqualToString:@"tv-episode"]) {
        return @"TV Episode";
    } else if (_kind == nil) {
        return @"UnknownKind";
    }else {
        return _kind;
    }
}

@end
