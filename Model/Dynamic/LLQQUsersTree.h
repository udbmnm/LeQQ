//
//  LLQQUsersTree.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-17.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLQQOnlineUsersList.h"

@interface LLQQUsersTree : NSObject
{
    NSDictionary * _categoriesDic;
    LLQQOnlineUsersList *_onlineUsersList;
    
    NSMutableDictionary *_usersOfCategoryDic;
}

/* 
 * the categoriesDic is a dictionary which KEY is the index of 
 * category, and VALUE is the cagegory, the dic contains all
 * categories which contains all users.
 *
 * onlineUsersList contains all online users.
 */
- (id)initWithCategoriesDic:(NSDictionary *)categoriesDic 
              onlineUsersList:(LLQQOnlineUsersList *)onlineUsersList;

/*
 * return a list of users of specified category, 
 * the online users will be placed in lower index.
 * 
 * This method will be called by the Controller, 
 * the nested tree view is so happy to eat this
 * "tree data".
 */
- (NSArray *)getUsersListOfCategory:(long)categoryIndex;

- (LLQQCategory *)getCategory:(long)categoryIndex;
- (long)getCategoriesCount;
- (NSArray *)getCategories;
@end
