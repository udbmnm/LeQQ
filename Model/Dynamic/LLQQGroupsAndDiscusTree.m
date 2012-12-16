//
//  LLQQGroupsAndDiscusTree.m
//  LeQQ
//
//  Created by xiangle gan on 12-12-15.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQGroupsAndDiscusTree.h"

@implementation LLQQGroupsAndDiscusTree

- (id)initWithGroupsDic:(NSDictionary *)groupsDic
              discusDic:(NSDictionary *)discusDic
{
    if (self = [super init]) {
    _groupsDic = [groupsDic retain];
    _discusDic = [discusDic retain];
        
    
        _groupsList = [[NSMutableArray alloc] initWithArray:[[groupsDic allValues]
                                                                    sortedArrayUsingSelector:@selector(compareWithGroup:)]];
        
        _discusList = [[NSMutableArray alloc] initWithArray:[[discusDic allValues] 
                                                                    sortedArrayUsingSelector:@selector(compareWithDiscus:)]];
    }
    
    return self;
}

- (void)dealloc
{
    [_groupsDic release];
    [_discusDic release];
    [super dealloc];
}

- (long)getSectionCount
{
    return 2;
}

- (NSInteger)getMembersCountAtSection:(long)section
{
    switch (section) {
        case 1:
            return [_groupsList count];
            break;
        case 2:
            return [_discusList count];
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)getTitleForSection:(long)section
{
    return section == 0 ? @"组" : @"讨论组";
}

- (NSArray *)getListOfSection:(long)section
{
    switch (section) {
        case 0:
            return _groupsList;
            break;
        case 1:
            return _discusList;
        default:
            break;
    }
    return nil;
}

- (id)getMemberAtIndexPath:(NSIndexPath *)indexPath
{
    int section = indexPath.section;
    int row = indexPath.row;
    
    NSArray *list = [self getListOfSection:section];
    if (list) 
        return [list objectAtIndex:row];
    else 
        return nil;
    
}
@end
