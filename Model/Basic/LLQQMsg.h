//
//  LLQQMsg.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-19.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLModelObject.h"


typedef enum 
{
    kQQMsgTypeNull = 0,
    kQQMsgTypeUser = 1,
    kQQMsgTypeGroup = 2,
    kQQMsgTypeDiscus =3
}LLQQMsgType;

typedef enum
{
    kQQMsgContentTypeNull = 0,
    kQQMstContentTypeString = 1,
    kQQMsgContentTypeCFace = 2
}LLQQMsgContentType;

@interface LLQQMsgCface : LLModelObject
{
    /* get from poll msg */
    NSString *name;
    long fileId;
    NSString *key;
    NSString *server;
    
    /* local cache*/
    NSString *localPath;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) long fileId;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *server;
@property (nonatomic, retain) NSString *localPath;

@end

@interface LLQQMsgFont : LLModelObject
{
}
@end


@interface LLQQMsgContent : NSObject
{
    /* 
     * and array of msg contents, 
     * string/cface/font
     */
    NSMutableArray *contentMsgs;
}
@property (nonatomic, retain) NSMutableArray *contentMsgs;

- (void)addMsgElement:(id)element;
- (NSString *)getString;
@end

@interface LLQQMsg : LLModelObject
{
    long msgId;
    long MsgId2;
    /*
     * for discus msg, the from uin is 10000, and the send id
     *    is sender uin. did is the discus uin.
     * for normal msg, from uin is the sender uin.
     * for group msg,  the from uin is the group id(gid).
     *    send is is the sender uin.
     */     
    long fromUin;
    long sendUin;
    /* to uin is me*/
    long toUin;
    /* is group/discus/normal message */
    LLQQMsgType type;
    /* sender ip ? */
    long replyIp;
    NSTimeInterval time;
    
    LLQQMsgContent *content;       

    long did;           /* for discus msg */
    long groupCode;     /* for group msg */    
    
    long seq;           /* for group/discus */
    long infoSeq;       /* for group/discus */
    
}

@property (assign) long msgId;;
@property (assign) long MsgId2;;
@property (assign) long fromUin;;
@property (assign) long sendUin;;
@property (assign) long toUin;;
@property (assign) LLQQMsgType type;;
@property (assign) long replyIp;;
@property (assign) NSTimeInterval time;;
@property (assign) LLQQMsgContent *content;;
@property (assign) long did;;
@property (assign) long groupCode;;
@property (assign) long seq;  
@property (assign) long infoSeq;

@end
