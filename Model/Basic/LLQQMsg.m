//
//  LLQQMsg.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-19.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQMsg.h"

@implementation LLQQMsgFont 
@end

@implementation LLQQMsgCface
@synthesize key,name,fileId,server,localPath;
-(id)init
{
    if (self = [super init]) {
        key = nil;
        name = nil;
        fileId = -1;
        server = nil;
        localPath = nil;
    }    
    return self;
}

- (void)dealloc
{
    self.key = nil;
    self.name = nil;
    self.server = nil;
    self.localPath = nil;
    [super dealloc];
}
@end


@implementation LLQQMsgContent
@synthesize contentMsgs;
- (id)init
{
    if (self = [super init]) {
        contentMsgs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [contentMsgs release];
    [super dealloc];
}

- (void)addMsgElement:(id)element
{
    if ([element isKindOfClass:[NSString class]]     ||
        [element isKindOfClass:[LLQQMsgCface class]] ||
        [element isKindOfClass:[LLQQMsgFont class]] ) {
        
        [contentMsgs addObject:element];
    } else {
        [NSException raise:@"ERROR msg content type" 
                    format:@"You can not add this type(%d) to msg content except string/cface/font",
         NSStringFromClass([element class])];
    }
    
}

- (NSString *)getString
{
    NSString *retString = @"";
    for (id msgElement in contentMsgs) {
        if ([msgElement isKindOfClass:[NSString class]]) {
            retString = [retString stringByAppendingString:msgElement];
        }
    }
    return retString;
}
@end


@implementation LLQQMsg
@synthesize did, seq, time, srcType, msgId, toUin, MsgId2, content, fromUin,
infoSeq, replyIp, sendUin, groupCode;

-(id)init
{
    if (self = [super init]) {
        
        msgId = -1;
        MsgId2 = -1;
        fromUin = -1;
        sendUin = -1;
        toUin = -1;
        srcType = kQQMsgSourceNull;
        replyIp = -1;
        time = -1;
        content = nil;
        
        did = -1;
        groupCode = -1;
        
        seq = -1;
        sendUin = -1;        
    }
    return self;
}

-(void)dealloc
{
    self.content = nil;
    [super dealloc];
}

- (NSBubbleData *)toBubbleData:(NSBubbleType)meOrSomeoneElse
{
    NSString *msgString = [self.content getString];
    NSBubbleData *chatMsg = [[NSBubbleData alloc] initWithText:msgString
                                                          date:[NSDate dateWithTimeIntervalSince1970:self.time]
                                                          type:meOrSomeoneElse];
    return [chatMsg autorelease];
}
@end
