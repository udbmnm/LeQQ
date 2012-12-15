//
//  LLQQGroupsAndDiscusTree.h
//  LeQQ
//
//  Created by xiangle gan on 12-12-15.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLQQGroup.h"
#import "LLQQDiscus.h"

@interface LLQQGroupsAndDiscusTree : NSObject
{
    NSDictionary *_groupsDic;
    NSDictionary *_discusDic;
    
    NSMutableArray *_groupsList;
    NSMutableArray *_discusList;
}

- (id)initWithGroupsDic:(NSDictionary *)groupsDic
              discusDic:(NSDictionary *)discusDic;


/* interface for groups and discus view controller */
- (long)getSectionCount;
- (NSInteger)getMembersCountAtSection:(long)section;

- (NSArray *)getListOfSection:(long)section;
- (id)getMemberAtIndexPath:(NSIndexPath *)indexPath;
@end
