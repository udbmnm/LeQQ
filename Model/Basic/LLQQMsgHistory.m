//
//  LLQQMsgHistory.m
//  LeQQ
//
//  Created by Xiangle le on 12-12-1.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQMsgHistory.h"

@implementation LLQQMsgHistory

- (id)init
{
    if (self = [super init]) {
        _msgsDicForFriends = [[NSMutableDictionary alloc] init];
        _msgsDicForGroup   = [[NSMutableDictionary alloc] init];
        _msgsDicForDiscus  = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_msgsDicForFriends release];
    [_msgsDicForGroup release];
    [_msgsDicForDiscus release];
    [super dealloc];
}

- (void)addMsgs:(NSArray *)msgs
{
    for (LLQQMsg *msg in msgs) {
        NSAssert(msg != nil, @"the array content is NOT msg");
        [self addMsg:msg];
    }    
}

- (void)addMsg:(LLQQMsg *)msg
{
    switch (msg.srcType) {
        case kQQMsgSourceUser:
        {
            NSMutableArray *msgs = [_msgsDicForFriends objectForKey:[NSString stringWithLong:msg.fromUin]];
            if (msgs == nil) {
                msgs = [[NSMutableArray alloc] init];
                [_msgsDicForFriends setObject:msgs forKey:[NSString stringWithLong:msg.fromUin]];
            }
            
            [msgs insertObject:msg atIndex:0];
        }
        break;
        
        case kQQMsgSourceGroup:
        {
            NSMutableArray *msgs = [_msgsDicForGroup objectForKey:[NSString stringWithLong:msg.fromUin]];
            if (msgs == nil) {
                msgs = [[NSMutableArray alloc] init];
                [_msgsDicForGroup setObject:msgs forKey:[NSString stringWithLong:msg.fromUin]];
            }
            
            [msgs insertObject:msg atIndex:0]; 
        }
        break;
            
        case kQQMsgSourceDiscus:
        {
            NSMutableArray *msgs = [_msgsDicForDiscus objectForKey:[NSString stringWithLong:msg.did]];
            if (msgs == nil) {
                msgs = [[NSMutableArray alloc] init];
                [_msgsDicForDiscus setObject:msgs forKey:[NSString stringWithLong:msg.did]];
            }
            
            [msgs insertObject:msg atIndex:0];
        }
        break;
            
        default:
        {
            
        }
        break;
    }
    
}

- (NSArray *)getMsgsForFriend:(long)uin
{
    
    return [_msgsDicForFriends objectForKey:[NSString stringWithLong:uin]];
}

- (NSArray *)getMsgsForGroup:(long)gid
{
    return [_msgsDicForGroup objectForKey:[NSString stringWithLong:gid]];
}

- (NSArray *)getMsgsForDiscus:(long)did
{
    return [_msgsDicForDiscus objectForKey:[NSString stringWithLong:did]];
}
@end
