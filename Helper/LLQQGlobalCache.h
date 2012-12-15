//
//  LLGlobalCache.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-12.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLQQMoonBox.h"
#import "LLQQModel.h"

@interface LLGlobalCache : NSObject

+ (LLGlobalCache *)getGlobalCache;
+ (void)clearAllCache;

- (void)saveMoonBox:(LLQQMoonBox *)box;
- (LLQQMoonBox *)getMoonBox;

- (void)setQQCategories:(NSArray *)categories;
- (NSArray *)getQQCategories;

- (void)saveTreeOfUsers:(LLQQUsersTree *)dataTree;
- (LLQQUsersTree *)getTreeOfUsers;

- (void)saveTreeOfGroupsAndDiscus:(LLQQGroupsAndDiscusTree*)dataTree;
- (LLQQGroupsAndDiscusTree *)getTreeOfGroupsAndDiscus;

- (void)addPollingTimeoutCountByOne;
- (long)getPollingTimeoutCount;
@end
