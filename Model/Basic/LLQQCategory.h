//
//  LLQQCategory.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLModelObject.h"
#import "LLQQUser.h"

@interface LLQQCategory : LLModelObject
{
    long index;       /*分组的唯一标识*/
    long sort;        /* ? */
    NSString *name;  /*分组名称*/
    NSMutableDictionary *usersMap;  /*该组下所有的用户, key是QQ号的字符串形式 */
}

@property (nonatomic, assign) long index;  
@property (nonatomic, assign) long sort;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSMutableDictionary *usersMap;

- (BOOL)addUser:(LLQQUser *)user;
- (LLQQUser *)getUser:(long)uin;
@end
