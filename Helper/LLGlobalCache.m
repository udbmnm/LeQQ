//
//  LLGlobalCache.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-12.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLGlobalCache.h"

@implementation LLGlobalCache

static LLQQMoonBox *_moonBox = nil;
static NSArray *_qqCategories = nil;

+ (LLGlobalCache *)getGlobalCache
{
    static LLGlobalCache *cache = nil;
    if (cache == nil) {
        cache = [[LLGlobalCache alloc] init];
    } 
    return cache;
}

+ (void)clearAllCache
{
    [_moonBox release];
    _moonBox = nil;
    
    
}

- (void)saveMoonBox:(LLQQMoonBox *)box
{
    [_moonBox release];
    _moonBox = [box retain];
}

- (LLQQMoonBox *)getMoonBox
{
    return _moonBox;
}

- (void)setQQCategories:(NSArray *)categories
{
    [_qqCategories release];
    _qqCategories = [categories retain];
}

- (NSArray *)getQQCategories
{
    return _qqCategories;
}
@end
