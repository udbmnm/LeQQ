//
//  LLQQMsgManager.h
//  LeQQ
//
//  Created by Xiangle le on 12-12-1.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLQQMsgHistory.h"

@interface LLQQMsgManager : NSObject
{
    LLQQMsgHistory *_msgHistory;
    NSMutableDictionary *_unreadMsgsFromFriends;
    NSMutableDictionary *_unreadMsgsFromGroup;
    NSMutableDictionary *_unreadMsgsFromDiscus;
}

+ (LLQQMsgManager *)getShareManager;
- (void)addNewMsg:(LLQQMsg *)msg;
- (NSArray *)getUnreadMsgsFromFriend:(long)friendUin;
- (NSArray *)getUnreadMsgsFromGroup:(long)gid;
- (NSArray *)getUnreadMsgsFromDiscus:(long)did;

@end
