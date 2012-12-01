//
//  LLQQMsgManager.m
//  LeQQ
//
//  Created by Xiangle le on 12-12-1.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQMsgManager.h"

@implementation LLQQMsgManager

+ (LLQQMsgManager *)getShareManager
{
    static LLQQMsgManager *manager = nil;
    if (manager == nil) {
        manager = [[LLQQMsgManager alloc] init];
    }
    return manager;
}

- (id)init
{
    if (self = [super init]) {
        _msgHistory = [[LLQQMsgHistory alloc] init];
        _unreadMsgsFromFriends = [[NSMutableDictionary alloc] init];
        _unreadMsgsFromGroup = [[NSMutableDictionary alloc] init];
        _unreadMsgsFromDiscus = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_msgHistory release];
    [_unreadMsgsFromFriends release];
    [_unreadMsgsFromGroup release];
    [_unreadMsgsFromDiscus release];
    [super dealloc];
}

- (void)addNewMsg:(LLQQMsg *)msg
{
    switch (msg.srcType) {
        case kQQMsgSourceUser:
        {
            NSMutableArray *msgs = [_unreadMsgsFromFriends objectForKey:[NSString stringWithLong:msg.fromUin]];
            if (msgs == nil) {
                msgs = [[NSMutableArray alloc] init];
                [_unreadMsgsFromFriends setObject:msgs forKey:[NSString stringWithLong:msg.fromUin]];
            }
            
            [msgs insertObject:msg atIndex:0];            
        }
        break;
            
        case kQQMsgSourceGroup:
        {
            NSMutableArray *msgs = [_unreadMsgsFromGroup objectForKey:[NSString stringWithLong:msg.fromUin]];
            if (msgs == nil) {
                msgs = [[NSMutableArray alloc] init];
                [_unreadMsgsFromGroup setObject:msgs forKey:[NSString stringWithLong:msg.fromUin]];
            }
            
            [msgs insertObject:msg atIndex:0];            
        }
        break;
            
        case kQQMsgSourceDiscus:
        {
            NSMutableArray *msgs = [_unreadMsgsFromDiscus objectForKey:[NSString stringWithLong:msg.did]];
            if (msgs == nil) {
                msgs = [[NSMutableArray alloc] init];
                [_unreadMsgsFromDiscus setObject:msgs forKey:[NSString stringWithLong:msg.did]];
            }
            
            [msgs insertObject:msg atIndex:0];            
        }
        break;
            
        default:
            break;
    }
}

- (NSArray *)getUnreadMsgsFromFriend:(long)friendUin
{
    NSArray *unReadMsgs = [_unreadMsgsFromFriends objectForKey:[NSString stringWithLong:friendUin]];
    [_msgHistory addMsgs:unReadMsgs];
    NSArray *msgsToReturn = [NSArray arrayWithArray:unReadMsgs];
    [_unreadMsgsFromFriends removeObjectForKey:[NSString stringWithLong:friendUin]];
    return msgsToReturn;    
}

- (NSArray *)getUnreadMsgsFromGroup:(long)gid
{
    NSArray *unReadMsgs = [_unreadMsgsFromGroup objectForKey:[NSString stringWithLong:gid]];
    [_msgHistory addMsgs:unReadMsgs];
    NSArray *msgsToReturn = [NSArray arrayWithArray:unReadMsgs];
    [_unreadMsgsFromFriends removeObjectForKey:[NSString stringWithLong:gid]];
    return msgsToReturn; 
}

- (NSArray *)getUnreadMsgsFromDiscus:(long)did
{
    NSArray *unReadMsgs = [_unreadMsgsFromDiscus objectForKey:[NSString stringWithLong:did]];
    [_msgHistory addMsgs:unReadMsgs];
    NSArray *msgsToReturn = [NSArray arrayWithArray:unReadMsgs];
    [_unreadMsgsFromDiscus removeObjectForKey:[NSString stringWithLong:did]];
    return msgsToReturn; 
}

@end
