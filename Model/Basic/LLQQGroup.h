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
    unsigned long gid;
    long code;
    long groupNum;                      /*群号*/
    
    UIImage *face;                      /*图标*/
    NSMutableDictionary *usersMap;      /* The users in the group */
    
    NSString *memo;
    NSString *fingermemo;
    NSTimeInterval createTime;
    long level;
    long ownerUin;
    
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) unsigned long gid;
@property (nonatomic, assign) long code;
@property (nonatomic, assign) long groupNum;
@property (nonatomic, retain) UIImage *face;
@property (nonatomic, retain) NSMutableDictionary *usersMap;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *fingermemo;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, assign) long level;
@property (nonatomic, assign) long ownerUin;

- (BOOL)addUser:(LLQQUser *)user;
- (LLQQUser *)getUser:(long)uin;
- (NSComparisonResult)compareWithGroup:(LLQQGroup *)anotherGroup;
@end