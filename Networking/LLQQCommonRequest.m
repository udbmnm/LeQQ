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
#import "LLQQGroup.h"
#import "LLQQParameterGenerator.h"
#import "NSString+LLStringAddtions.h"
#import "LLQQUserDetail.h"

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

- (void)getALLGroup
{
    static NSString *urlString = @"http://s.web2.qq.com/api/get_group_name_list_mask2";
    static NSString *contentPattern = @"{\"vfwebqq\":\"$(vfwebqq)\"}";
    
    NSString *postContent = [contentPattern stringByReplacingOccurrencesOfString:@"$(vfwebqq)" withString:_box.vfwebqq];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURLString:urlString];
    [request setPostValue:postContent forKey:@"r"];
    
    [request setCompletionBlock:^(void){
        
        NSString *response = [request responseString];
        NSDictionary *resDic = [response JSONValue];
        
        if ([[resDic objectForKey:@"retcode"] longValue] != 0) {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetAllGroup isOK:NO info:[NSString stringWithFormat:@"retcode is %@", [resDic objectForKey:@"retcode"]]];
            return ;
        }
        
        NSDictionary *groups = [[NSMutableDictionary alloc] init];
        
        resDic = [resDic objectForKey:@"result"];
        /* ... there is gmarklist, also */
        NSArray *gnamelist = [resDic objectForKey:@"gnamelist"];
        for (NSDictionary *aGroupDic in gnamelist) {
            LLQQGroup *group = [[LLQQGroup alloc] init];
            group.gid = [[aGroupDic objectForKey:@"gid"] longValue];
            group.code = [[aGroupDic objectForKey:@"code"] longValue];
            group.name = [aGroupDic objectForKey:@"name"];
            /* the flag ?? */
            [groups setValue:group forKey:[NSString stringWithFormat:@"%ld", group.gid]];
            [group release];
        }
        
     [_delegate LLQQCommonRequestNotify:kQQRequestGetAllGroup isOK:YES info:[groups autorelease]];        
        
    }];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetAllGroup isOK:NO info:[request error]];
    }];
    
    [request startAsynchronous];    
}

- (void)getUserDetail:(long)uin
{
    static NSString *urlPattern = @"http://s.web2.qq.com/api/get_friend_info2?tuin=$(uin)&verifysession=&code=&vfwebqq=$(vfwebqq)&t=$(t)";
    
    NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithFormat:@"%ld", uin], @"$(uin)", 
                                                                _box.vfwebqq, @"$(vfwebqq)", 
                                                  [LLQQParameterGenerator t], @"$(t)", nil];
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    
    [request setCompletionBlock:^(void) {
        NSString *response = [request responseString];
        NSDictionary *resDic = [response JSONValue];
        
        long retcode = [[resDic objectForKey:@"retcode"] longValue];
        if (retcode != 0) {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetUserDetail isOK:NO info:[NSString stringWithFormat:@"%ld", retcode]];
            return ;
        }
        
        resDic = [resDic objectForKey:@"result"];
        LLQQUserDetail *userDetail = [[LLQQUserDetail alloc] init];
        /* the flag ? */
        userDetail.uin = [[resDic objectForKey:@"uin"] longValue];
        userDetail.occupation = [resDic objectForKey:@"occupation"];
        userDetail.phone = [resDic objectForKey:@"phone"];
        userDetail.allow = [[resDic objectForKey:@"allow"] intValue];
        userDetail.college = [resDic objectForKey:@"college"];
        userDetail.constellation = [[resDic objectForKey:@"constel"] intValue];
        userDetail.blood = [[resDic objectForKey:@"blood"] intValue];
        userDetail.homepage = [resDic objectForKey:@"homepage"];
        userDetail.stat = [[resDic objectForKey:@"stat"] intValue];
        userDetail.vip_info = [[resDic objectForKey:@"vip_info"] intValue];
        userDetail.country = [resDic objectForKey:@"country"];
        userDetail.city = [resDic objectForKey:@"city"];
        userDetail.personal = [resDic objectForKey:@"personal"];
        userDetail.nickname = [resDic objectForKey:@"nick"];
        userDetail.animal = [[resDic objectForKey:@"shengxiao"] intValue];
        userDetail.email = [resDic objectForKey:@"email"];
        userDetail.province = [resDic objectForKey:@"province"];
        userDetail.gender = [[resDic objectForKey:@"gender"] isEqualToString:@"male"] ? GenderMale : GenderFemale;
        userDetail.mobile = [resDic objectForKey:@"mobile"];
                
        [_delegate LLQQCommonRequestNotify:kQQRequestGetUserDetail isOK:YES info:[userDetail autorelease]];
        
    }];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetUserDetail isOK:NO info:[request error]];
    }];
    
    [request startAsynchronous];
    
}

/* 这个可以用批量的获取好友的签名（operation),因为返加的json包含uin，所以不用维护这个uin值*/
- (void)getUserSignature:(long)uin
{
    static NSString *urlPattern = @"http://s.web2.qq.com/api/get_single_long_nick2?tuin=$(uin)&vfwebqq=$(vfwebqq)&t=$(t)";
    
    NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithFormat:@"%ld", uin], @"$(uin)", 
                                   _box.vfwebqq, @"$(vfwebqq)", 
                                   [LLQQParameterGenerator t], @"$(t)", nil];
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetUserSignature isOK:NO info:[request error]];
    }];
    
    [request setCompletionBlock:^(void) {
        NSString *response = [request responseString];
        NSDictionary *resDic = [response JSONValue];
        
        long retcode = [[resDic objectForKey:@"retcode"] longValue];
        if (retcode != 0) {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetUserSignature 
                                          isOK:NO 
                                          info:[NSString stringWithFormat:@"retcode is NOT 0: %ld", retcode]];
            return ;
        }
        NSArray *signatures = [resDic objectForKey:@"result"];
        
        NSString *signatureString = nil;
        for (NSDictionary *signatureDic in signatures) {
            if ([[signatureDic objectForKey:@"uin"] longValue] == uin) {
                signatureString = [signatureDic objectForKey:@"lnick"];
                break;
            }
        }
     
        [_delegate LLQQCommonRequestNotify:kQQRequestGetUserSignature isOK:YES info:signatureString];        
    }];
    
        
    [request startAsynchronous];
}

- (void)getQQLevel:(long)uin
{
    static NSString *urlPattern = @"http://s.web2.qq.com/api/get_qq_level2?tuin=$(uin)&vfwebqq=$(vfwebqq)&t=$(t)";
    
    NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithFormat:@"%ld", uin], @"$(uin)", 
                                   _box.vfwebqq, @"$(vfwebqq)", 
                                   [LLQQParameterGenerator t], @"$(t)", nil];
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetUserSignature isOK:NO info:[request error]];
    }];
    
    [request setCompletionBlock:^(void) {
        NSString *response = [request responseString];
        NSDictionary *resDic = [response JSONValue];
        
        long retcode = [[resDic objectForKey:@"retcode"] longValue];
        if (retcode != 0) {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetQQLevel 
                                          isOK:NO 
                                          info:[NSString stringWithFormat:@"retcode is NOT 0: %ld", retcode]];
            return ;
        }
        
        resDic = [resDic objectForKey:@"result"];
        
        if ([[resDic objectForKey:@"tuin"] longValue] != uin) {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetQQLevel isOK:NO info:@"uin is NOT desired"];
            return;
        }
        
        long level = [[resDic objectForKey:@"level"] longValue];
        long days =  [[resDic objectForKey:@"days"]  longValue];
        long hours = [[resDic objectForKey:@"hours"] longValue];
        long remainDays = [[resDic objectForKey:@"remainDays"] longValue];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithLong:level],      @"level", 
                             [NSNumber numberWithLong:days],       @"days", 
                             [NSNumber numberWithLong:hours],      @"hours",
                             [NSNumber numberWithLong:remainDays], @"remainDays", 
                             nil];                           
        [_delegate LLQQCommonRequestNotify:kQQRequestGetQQLevel isOK:YES info:dic];        
        
    }];
    
    [request startAsynchronous];
}
@end
