//
//  LLQQCategory.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLModelObject.h"

@interface LLQQCategory : LLModelObject
{
    int index;       /*分组的唯一标识*/
    int sort;        /* ? */
    NSString *name;  /*分组名称*/
    NSMutableDictionary *usersMap;  /*该组下所有的用户, key是QQ号的字符串形式 */
}

@property (nonatomic, assign) int index;  
@property (nonatomic, assign) int sort;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSMutableDictionary *usersMap;

@end
