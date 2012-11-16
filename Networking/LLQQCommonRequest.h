//
//  LLQQCommonRequest.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLQQMoonBox.h"
#import "LLQQUser.h"
#import "LLQQCommon.h"

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
    kQQRequestGetGroupInfoAndMembers = 110
}LLQQCommonRequestType;

@protocol LLQQCommonRequestDelegate <NSObject>
/* 回调，不同的requestType有不同的info返回，要注意区分 */
- (void)LLQQCommonRequestNotify:(LLQQCommonRequestType)requestType isOK:(BOOL)success info:(id)info;
@end

@interface LLQQCommonRequest : NSObject
{
    LLQQMoonBox *_box;
    id<LLQQCommonRequestDelegate> _delegate;
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
 * return the signature string
 */
- (void)getUserSignature:(long)uin;

/* 
 * get a user's qq level info, returns 
 * an dictionary:
 *    KEY: level, VALUE: (NSNumber*)
 *    KEY: days,  VALUE: (NSNumber*)
 *    KEY: hours, VALUE: (NSNumber*)
 *    KEY: remainDays, VALUE: (NSNumber*)
 */
- (void)getQQLevel:(long)uin;

//- (long)getQQNumber:(long)uin;

/*
 * change the login status:
 * "online", "away" ... 
 * if success, nil is return.
 */
- (void)changeStatus:(LLQQUserStatusType)status;

/* 
 * return a UIImage of user
 */
- (void)getFaceOfUser:(long)uin;

/* 
 * return an Object of LLQQOnlineUsersList
 * which contains an array of 
 * LLQQUserStatus
 */
- (void)getAllOnlineFriends;

- (void)getRecentFriends;


- (void)getGroupInfoAndMembers:(long)gcode;

//- (UIImage *)getGroupLogo:(long)code;


//- (long)getGroupNumber:(long)code;




@end
