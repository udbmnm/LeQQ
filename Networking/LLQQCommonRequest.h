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
    kQQRequestGetUserDetail = 102
}LLQQCommonRequestType;

@protocol LLQQCommonRequestDelegate <NSObject>
/* 回调，不同的requestType有不同的info返回，要注意区分 */
- (void)LLQQCommonRequestNotify:(LLQQCommonRequestType)requestType info:(id)info;
@end

@interface LLQQCommonRequest : NSObject
{
    LLQQMoonBox *_box;
    id<LLQQCommonRequestDelegate> _delegate;
}

/* the box contains all infomation that used to request Tencent server */
- (id)initWithBox:(LLQQMoonBox *)box delegate:(id)delegate;

/* returns an array of categories which contains all users */
- (void)getAllFriends;

/* get user detail info by uin */
//- (LLQQUserDetail *)getUserDetail:(long)uin;

/* get the sinature of user by uin */
//- (NSString *)getUserSinature:(long)uin;

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

//- (NSArray *)getALLGroup;

//- (UIImage *)getGroupLogo:(long)code;

//- (NSArray *)getGroupMembers:(long)code;

//- (long)getGroupNumber:(long)code;




@end
