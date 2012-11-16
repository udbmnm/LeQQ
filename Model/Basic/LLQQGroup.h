//
//  LLQQGroup.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-13.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLModelObject.h"
#import "LLQQUser.h"

@interface LLQQGroup : LLModelObject
{
    NSString *name;                     /* name of the QQ group */
    long gid;
    long code;
    long groupNum;                      /*群号*/
    
    UIImage *face;                      /*图标*/
    NSMutableDictionary *usersMap;      /* The users in the group */
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) long gid;
@property (nonatomic, assign) long code;
@property (nonatomic, assign) long groupNum;
@property (nonatomic, retain) UIImage *face;
@property (nonatomic, retain) NSMutableDictionary *usersMap;

- (BOOL)addUser:(LLQQUser *)user;
- (LLQQUser *)getUser:(long)uin;
@end