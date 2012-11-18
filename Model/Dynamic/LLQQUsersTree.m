//
//  LLQQUsersTree.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-17.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQUsersTree.h"

@implementation LLQQUsersTree

- (id)initWithCategoriesDic:(NSDictionary *)categoriesDic 
              onlineUsersList:(LLQQOnlineUsersList *)onlineUsersList
{
    if (self = [super init]) {
        
        _categoriesDic = [categoriesDic retain];
        _onlineUsersList = [onlineUsersList retain];
        _usersOfCategoryDic = [[NSMutableDictionary alloc] init];
        _categoriesArray = nil;
        
        /* loop all categories */
        for (NSString *index in [_categoriesDic allKeys]) {
            
            LLQQCategory *category = [_categoriesDic objectForKey:index];
            NSArray *onlineUsersStatusInCategory = [_onlineUsersList getOnlineStatusListOfCategory:category];        
            
            NSMutableArray *usersOfflineInCategory = [NSMutableArray arrayWithArray:[[category usersMap] allValues]];
            
            NSMutableArray *usersOnlineInCategory = [NSMutableArray arrayWithCapacity:0];
            
            /* 复杂度N2 */
            for (LLQQUserStatus *anOnlineUserStatus in onlineUsersStatusInCategory) {
                LLQQUser *user = nil;
                for (int index = 0; index < [usersOfflineInCategory count]; index++) {
                    user = [usersOfflineInCategory objectAtIndex:index];
                    if (user.uin == anOnlineUserStatus.uin) {
                        [usersOnlineInCategory addObject:user];
                        [usersOfflineInCategory removeObjectAtIndex:index];
                        break;
                    }
                }
            }
            
            NSMutableArray *allUsersInCategory = [NSMutableArray arrayWithArray:usersOnlineInCategory];            
            [allUsersInCategory addObjectsFromArray:usersOfflineInCategory];
            
            [_usersOfCategoryDic setObject:allUsersInCategory 
                                    forKey:[NSString stringWithFormat:index]];
            
            _categoriesArray = [[NSMutableArray alloc] initWithArray:[[_categoriesDic allValues] sortedArrayUsingSelector:@selector(compareWithCategory:)]];
        }        
    }
    return self;
}

-(void)dealloc
{
    [_categoriesDic release];
    [_categoriesArray release];
    [_onlineUsersList release];
    [_usersOfCategoryDic release];
    [super dealloc];
}

- (NSArray *)getUsersListOfCategory:(long)categoryIndex
{
    return [_usersOfCategoryDic objectForKey:[NSString stringWithLong:categoryIndex]];
}

- (LLQQCategory *)getCategory:(long)categoryIndex
{
    return [_categoriesDic objectForKey:[NSString stringWithLong:categoryIndex]];
}

- (long)getCategoriesCount
{
    return  [_categoriesArray count];
}

- (NSArray *)getCategories
{
    return _categoriesArray;
}
@end
