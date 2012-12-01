//
//  LLQQCommonRequest.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum 
{
    kQQRequestGetAllFriends = 101,         /* - (void)getAllFriends; */
    kQQRequestGetAllGroups  = 102,         /* - (void)getALLGroup;  */
    kQQRequestGetUserDetail = 103,         /* - (void)getUserDetail:(long)qqNum; */
    kQQRequestGetUserSignature = 104,      /* - (void)getUserSinature:(long)qqNum; */
    kQQRequestGetQQLevel = 105,            /* - (void)getQQLevel:(long)uin; */
    kQQRequestChangeStatus = 106,          /* - (void)changeStatus:(LLQQUserStatus)status;*/
    kQQRequestGetFaceOfUser = 107,         /* - (void)getFaceOfUser:(long)uin; */
    kQQRequestGetAllOnlineFriends = 108,   /* - (void)getAllOnlineFriends; */
    kQQRequestGetRecentFriends = 109,      /* - (void)getRecentFriends; */
    kQQRequestGetGroupInfoAndMembers = 110, 
    kQQRequestSendMsg = 111,
    kQQRequestSendDiscusMsg = 112,
    kQQRequestSendGroupMsg = 113,
    kQQRequestPoll = 114
}LLQQCommonRequestType;

@protocol LLQQCommonRequestDelegate <NSObject>
/* 回调，不同的requestType有不同的info返回，要注意区分 */
- (void)LLQQCommonRequestNotify:(LLQQCommonRequestType)requestType isOK:(BOOL)success info:(id)info;
@end

@interface LLQQCommonRequest : NSObject
{
    LLQQMoonBox *_box;
    id<LLQQCommonRequestDelegate> _delegate; /*not retain*/
    ASINetworkQueue *_nicknamgeOperationQueue;
}

/* the box contains all infomation that used to request Tencent server */
- (id)initWithBox:(LLQQMoonBox *)box delegate:(id<LLQQCommonRequestDelegate>)delegate;

/*
 * returns a dictionary of categories which contains all users, 
 * The dictionary: 
 *     KEY:   string representation index of category
 *     VALUE: (LLQQCatogory *)category
 */

- (void)getAllFriends;
/*
 * returns a dictionary of groups, 
 * The dictionary: 
 *     KEY:   string representation gid of the group
 *     VALUE: (LLQQGroup*)group
 */
- (void)getAllGroups;

/* 
 * get user detail info by uin 
 * return the LLQQUserDetail object
 */
- (void)getUserDetail:(long)uin;

/*
 * get the sinature of user by uin 
 * the return dictionray:
 *    KEY: @"signature" VALUE:(NSString*)
 *    KEY: @"uin"       VALUE:(NSString*)uinString
 */
- (void)getUserSignature:(long)uin;

/*
 * get many users' sinatures.
 * return the signature string many times 
 * for many users.
 * the return dictionray:
 *    KEY: @"signature" VALUE:(NSString*)
 *    KEY: @"uin"       VALUE:(NSNumber*)uin
 */
- (void)getUsersSignatures:(NSArray *)uins;

/* 
 * get a user's qq level info, returns 
 * an dictionary:
 *    KEY: level, VALUE: (NSNumber*)
 *    KEY: days,  VALUE: (NSNumber*)
 *    KEY: hours, VALUE: (NSNumber*)
 *    KEY: remainDays, VALUE: (NSNumber*)
 */
- (void)getQQLevel:(long)uin;

/*
 * change the login status:
 * "online", "away" ... 
 * if success, nil is return.
 */
- (void)changeStatus:(LLQQUserStatusType)status;

/* 
 * return a UIImage of user
 */
- (void)getFaceOfUser:(long)uin isMe:(BOOL)isMe;

/* 
 * not download but return a request URL
 * added for EGOImageView
 */
- (NSURL *)getFaceOfUserURL:(long)uin isMe:(BOOL)isMe;

/* 
 * return an Object of LLQQOnlineUsersList
 * which contains an array of 
 * LLQQUserStatus
 */
- (void)getAllOnlineFriends;

- (void)getRecentFriends;

/* 
 * returns a dic:
 *     KEY: @"group"  VALUE: (LLQQGroup*)
 *     KEY: @"onlineList"  VALUE: (LLQQGroupOnlineList*)
 *
 */
- (void)getGroupInfoAndMembers:(long)gcode;

/*
 * no data return, just return YES/NO
 */
- (void)sendMsgTo:(long)uin msgs:(NSArray *)msgs;
- (void)sendDiscusMsgTo:(long)did msgs:(NSArray *)msgs;
- (void)sendGroupMsgTo:(long)gid msgs:(NSArray *)msgs;

/*
 * for msg poll, return LLQQMsg
 * for ...
 */
- (void)poll;
//- (UIImage *)getGroupLogo:(long)code;

//- (long)getQQNumber:(long)uin;

//- (long)getGroupNumber:(long)code;




@end
