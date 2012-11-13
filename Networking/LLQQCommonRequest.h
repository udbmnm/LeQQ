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

typedef enum 
{
    kQQRequestGetAllFriends = 101,  /* - (void)getAllFriends; */
    kQQRequestGetAllGroup   = 102,  /* - (void)getALLGroup;  */
    kQQRequestGetUserDetail = 103   /* - (void)getUserDetail:(long)qqNum; */
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
- (void)getALLGroup;

//
/* get user detail info by uin */
- (void)getUserDetail:(long)qqNum;

/* get the sinature of user by uin */
- (void)getUserSinature:(long)uin;

/* 
 * get a user's qq level info, returns an array of two 
 * numbers, 1st is the level, 2nd is the remain days to
 * the next level
 */
//- (NSArray *)getQQLevel:(long)uin;

//- (long)getQQNumber:(long)uin;

//- (BOOL)changeStatus:(NSString *)status;

//- (UIImage *)getFaceOfUser:(long)uin;

/* return an array of {uin, status} */
//- (NSArray *)getALLOnlineFriends;

//- (NSArray *)getRecentFriends;


//- (UIImage *)getGroupLogo:(long)code;

//- (NSArray *)getGroupMembers:(long)code;

//- (long)getGroupNumber:(long)code;




@end
