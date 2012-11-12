//
//  LLGlobalCache.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-12.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLQQMoonBox.h"

@interface LLGlobalCache : NSObject

+ (LLGlobalCache *)getGlobalCache;
+ (void)clearAllCache;

- (void)saveMoonBox:(LLQQMoonBox *)box;
- (LLQQMoonBox *)getMoonBox;

- (void)setQQCategories:(NSArray *)categories;
- (NSArray *)getQQCategories;
@end
