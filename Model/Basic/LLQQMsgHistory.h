//
//  LLQQMsgHistory.h
//  LeQQ
//
//  Created by Xiangle le on 12-12-1.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLModelObject.h"

@interface LLQQMsgHistory : LLModelObject
{
    
    
    
    /* a dic for chatting msgs with someone(user/group/dicus) */
    NSMutableDictionary *_msgsDicForFriends;
    NSMutableDictionary *_msgsDicForGroup;
    NSMutableDictionary *_msgsDicForDiscus;
}

- (void)addMsg:(LLQQMsg *)msg;
- (void)addMsgs:(NSArray *)msgs;
- (NSArray *)getMsgsForFriend:(long)uin;
- (NSArray *)getMsgsForGroup:(long)gid;
- (NSArray *)getMsgsForDiscus:(long)did;
@end
