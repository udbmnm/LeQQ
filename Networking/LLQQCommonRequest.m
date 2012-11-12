//
//  LLQQCommonRequest.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQCommonRequest.h"
#import "ASIHTTPRequest+ASIHTTPRequest_LLHelper.h"
#import "LLQQCategory.h"

@implementation LLQQCommonRequest

- (id)initWithBox:(LLQQMoonBox *)box delegate:(id)delegate
{
    if (self = [super init]) {
        _box = [box retain];
        NSAssert(_box != nil, @"moon box must not be nil");

        _delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    [_box release];
    [super dealloc];
}

- (void)getAllFriends
{
    static NSString *urlString = @"http://s.web2.qq.com/api/get_user_friends2";
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURLString:urlString];
    NSString *postContent = @"{\"h\":\"hello\",\"vfwebqq\":\"$(vfwebqq)\"}";
    postContent = [postContent stringByReplacingOccurrencesOfString:@"$(vfwebqq)" withString:_box.vfwebqq];
    [request setPostValue:postContent forKey:@"r"];
    
    [request setCompletionBlock:^(void) {
        NSString *result = [request responseString];
        NSLog(@"result is %@", result);
        
        NSDictionary *resDic = [result JSONValue];
        if ([[resDic objectForKey:@"retcode"] longValue] != 0) {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetAllFriends isOK:NO info:@"未知错误"];
        }
        
        resDic = [resDic objectForKey:@"result"];
        NSArray *friends    = [resDic objectForKey:@"friends"];
        NSArray *marknames  = [resDic objectForKey:@"marknames"];
        NSArray *categories = [resDic objectForKey:@"categories"];
        NSArray *vipinfo    = [resDic objectForKey:@"vipinfo"];
        NSArray *info       = [resDic objectForKey:@"info"];
        
        /* return to delegate */
        NSMutableDictionary *categoriesDic = [[NSMutableDictionary alloc] init];
        
        for (NSDictionary *aCategoryDic in categories) {
            LLQQCategory *category = [[LLQQCategory alloc] init];
            category.index = [[aCategoryDic objectForKey:@"index"] intValue];
            category.sort =  [[aCategoryDic objectForKey:@"sort"] intValue];
            category.name =  [aCategoryDic objectForKey:@"name"];
            /*复杂度O(1) */
            /* overide existing category */
            [categoriesDic setObject:category forKey:[NSString stringWithFormat:@"%d", category.index]];
            [category release];
        }
        
        for (NSDictionary *aFriendDic in friends) {
            LLQQUser *user = [[LLQQUser alloc] init];
            user.uin = [[aFriendDic objectForKey:@"uin"] longValue];
            user.categoryIndex = [[aFriendDic objectForKey:@"categories"] intValue];
            /*复杂度O(1) */
            LLQQCategory *category = [categoriesDic objectForKey:[NSString stringWithFormat:@"%d", user.categoryIndex]];
            LLQQUser *existUser = [category.usersMap objectForKey:[NSString stringWithFormat:@"%ld", user.uin]];
            
            if (existUser == nil) {
                [category.usersMap setObject:user forKey:[NSString stringWithFormat:@"%ld", user.uin]];
            } else {
                /*update existing user, NO overide */
                existUser.categoryIndex = user.categoryIndex;
            }
        
            [user release];
        }
        
        for (NSDictionary *aInfoDic in info) {
            long uin = [[aInfoDic objectForKey:@"uin"] longValue];
            
            /* 复杂度为 O(N) */
            for (LLQQCategory *category in [categoriesDic allValues]) {
                LLQQUser *user = [[category usersMap] objectForKey:[NSString stringWithFormat:@"%ld", uin]];
                if (user) {
                    user.face = [[aInfoDic objectForKey:@"face"] longValue];
                    user.nickname = [aInfoDic objectForKey:@"nick"];
                    break;
                }
            }            
        }
        
        for (NSDictionary *aVipInfoDic in vipinfo) {
            long uin = [[aVipInfoDic objectForKey:@"u"] longValue];
            /* 复杂度为 O(N) */
            for (LLQQCategory *category in [categoriesDic allValues]) {
                LLQQUser *user = [[category usersMap] objectForKey:[NSString stringWithFormat:@"%ld", uin]];
                if (user) {
                    user.isVIP = [[aVipInfoDic objectForKey:@"is_vip"] boolValue];
                    user.vipLevel = [[aVipInfoDic objectForKey:@"vip_level"] longValue];
                    break;
                }
            }                
        }
        
        for (NSDictionary *marknameDic in marknames) {
            long uin = [[marknameDic objectForKey:@"uin"] longValue];
            /* 复杂度为 O(N) */
            for (LLQQCategory *category in [categoriesDic allValues]) {
                LLQQUser *user = [[category usersMap] objectForKey:[NSString stringWithFormat:@"%ld", uin]];
                if (user) {
                    user.markname = [marknameDic objectForKey:@"markname"];
                    break;
                }
            }                
        }
        
        /* ..... */
        [_delegate LLQQCommonRequestNotify:kQQRequestGetAllFriends isOK:YES info:categoriesDic];
        
    }];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetAllFriends isOK:NO info:[request error]];
    }];
    
    [request startAsynchronous];    
}

@end
