//
//  LLQQCommonRequest.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQCommonRequest.h"
#import "LLQQModel.h"

@implementation LLQQCommonRequest

- (id)initWithBox:(LLQQMoonBox *)box delegate:(id<LLQQCommonRequestDelegate>)delegate
{
    if (self = [super init]) {
        _box = [box retain];
        NSAssert(_box != nil, @"moon box must not be nil");

        _delegate = delegate;
        _nicknamgeOperationQueue = nil;
    }
    return self;
}

- (void)dealloc
{
    [_box release];
    [_nicknamgeOperationQueue release];
    [super dealloc];
}

- (void)getAllFriends
{
    static NSString *urlString = @"http://s.web2.qq.com/api/get_user_friends2";
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURLString:urlString];
    [request addRequestHeader:@"Referer" value:@"http://s.web2.qq.com/"];
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
            category.index = [[aCategoryDic objectForKey:@"index"] longValue];
            category.sort =  [[aCategoryDic objectForKey:@"sort"] longValue];
            category.name =  [aCategoryDic objectForKey:@"name"];
            /*复杂度O(1) */
            /* overide existing category */
            [categoriesDic setObject:category forKey:[NSString stringWithFormat:@"%d", category.index]];
            [category release];
        }
        
        LLQQCategory *defaultCategory = [[LLQQCategory alloc] init];
        defaultCategory.index = 0;
        defaultCategory.name = @"我的好友";  
        [categoriesDic setObject:defaultCategory forKey:@"0"];
        [defaultCategory release];
        
        for (NSDictionary *aFriendDic in friends) {
            LLQQUser *user = [[LLQQUser alloc] init];
            user.uin = [[aFriendDic objectForKey:@"uin"] longValue];
            user.categoryIndex = [[aFriendDic objectForKey:@"categories"] longValue];
            /*复杂度O(1) */
            LLQQCategory *category = [categoriesDic objectForKey:[NSString stringWithFormat:@"%d", user.categoryIndex]];
            [category addUser:user];        
            [user release];
        }
        
        for (NSDictionary *aInfoDic in info) {
            unsigned long uin = [[aInfoDic objectForKey:@"uin"] longValue];
            
            /* 复杂度为 O(N) */
            for (LLQQCategory *category in [categoriesDic allValues]) {
                LLQQUser *user = [category getUser:uin];
                if (user) {
                    user.face = [[aInfoDic objectForKey:@"face"] longValue];
                    user.nickname = [aInfoDic objectForKey:@"nick"];
                    break;
                }
            }            
        }
        
        for (NSDictionary *aVipInfoDic in vipinfo) {
            unsigned long uin = [[aVipInfoDic objectForKey:@"u"] longValue];
            /* 复杂度为 O(N) */
            for (LLQQCategory *category in [categoriesDic allValues]) {
                LLQQUser *user = [category getUser:uin];
                if (user) {
                    user.isVIP = [[aVipInfoDic objectForKey:@"is_vip"] boolValue];
                    user.vipLevel = [[aVipInfoDic objectForKey:@"vip_level"] longValue];
                    break;
                }
            }                
        }
        
        for (NSDictionary *marknameDic in marknames) {
            unsigned long uin = [[marknameDic objectForKey:@"uin"] longValue];
            /* 复杂度为 O(N) */
            for (LLQQCategory *category in [categoriesDic allValues]) {
                LLQQUser *user = [category getUser:uin];
                if (user) {
                    user.markname = [marknameDic objectForKey:@"markname"];
                    break;
                }
            }                
        }
        
        /* ..... */
        [_delegate LLQQCommonRequestNotify:kQQRequestGetAllFriends isOK:YES info:[categoriesDic autorelease]];
        
    }];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetAllFriends isOK:NO info:[request error]];
    }];
    
    [request startAsynchronous];    
}

- (void)getAllGroups
{
    static NSString *urlString = @"http://s.web2.qq.com/api/get_group_name_list_mask2";
    static NSString *contentPattern = @"{\"vfwebqq\":\"$(vfwebqq)\"}";
    
    NSString *postContent = [contentPattern stringByReplacingOccurrencesOfString:@"$(vfwebqq)" withString:_box.vfwebqq];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURLString:urlString];
    [request addRequestHeader:@"Referer" value:@"http://s.web2.qq.com/"];
    [request setPostValue:postContent forKey:@"r"];
    
    [request setCompletionBlock:^(void){
        
        NSString *response = [request responseString];
        NSDictionary *resDic = [response JSONValue];
        
        if ([[resDic objectForKey:@"retcode"] longValue] != 0) {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetAllGroups
                                          isOK:NO 
                                          info:[NSString stringWithFormat:@"retcode is %@", 
                                                [resDic objectForKey:@"retcode"]]];
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
            [groups setValue:group forKey:[NSString stringWithLong: group.gid]];
            [group release];
        }
        
     [_delegate LLQQCommonRequestNotify:kQQRequestGetAllGroups isOK:YES info:[groups autorelease]];        
        
    }];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetAllGroups isOK:NO info:[request error]];
    }];
    
    [request startAsynchronous];    
}

- (void)getAllDiscus
{
    static NSString *urlPattern = @"http://d.web2.qq.com/channel/get_discu_list_new2?clientid=$(clientid)&psessionid=$(psessionid)&vfwebqq=$(vfwebqq)&t=$(t)";
    
    NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   _box.clientid,   @"$(clientid)", 
                                   _box.psessionid, @"$(psessionid)", 
                                   _box.vfwebqq,    @"$(vfwebqq)",
                                   [LLQQParameterGenerator t], @"$(t)", nil];
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    
    [request addRequestHeader:@"Referer" value:@"http://d.web2.qq.com/proxy.html?v=20110331002&callback=1&id=3"];    
    [request setCompletionBlock:^(void){
        
        NSString *response = [request responseString];
        NSDictionary *resDic = [response JSONValue];
        
        if ([[resDic objectForKey:@"retcode"] longValue] != 0) {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetAllDiscus
                                          isOK:NO 
                                          info:[NSString stringWithFormat:@"retcode is %@", 
                                                [resDic objectForKey:@"retcode"]]];
            return ;
        }
           
        NSMutableDictionary *discusesDic = [[NSMutableDictionary alloc] init];
        resDic = [resDic objectForKey:@"result"];
        /* ... there is dmarklist, also, but not resolve now */
        NSArray *discuses = [resDic objectForKey:@"dnamelist"];
        for (NSDictionary *aDiscusDic in discuses) {
            LLQQDiscus *discus = [[LLQQDiscus alloc] init];
            discus.did = [[aDiscusDic objectForKey:@"did"] longValue];
            discus.name = [aDiscusDic objectForKey:@"name"];
            [discusesDic setValue:discus forKey:[NSString stringWithLong:discus.did]];            
        }
        
        [_delegate LLQQCommonRequestNotify:kQQRequestGetAllDiscus isOK:YES info:[discusesDic autorelease]];        
        
    }];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetAllDiscus isOK:NO info:[request error]];
    }];
    
    [request startAsynchronous];        
}

- (void)getUserDetail:(long)uin
{
    static NSString *urlPattern = @"http://s.web2.qq.com/api/get_friend_info2?tuin=$(uin)&verifysession=&code=&vfwebqq=$(vfwebqq)&t=$(t)";
    
    NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithLong: uin], @"$(uin)", 
                                                                _box.vfwebqq, @"$(vfwebqq)", 
                                                  [LLQQParameterGenerator t], @"$(t)", nil];
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    
    [request setCompletionBlock:^(void) {
        NSString *response = [request responseString];
        NSDictionary *resDic = [response JSONValue];
        
        long retcode = [[resDic objectForKey:@"retcode"] longValue];
        if (retcode != 0) {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetUserDetail isOK:NO info:[NSString stringWithLong: retcode]];
            return ;
        }
        
        resDic = [resDic objectForKey:@"result"];
        LLQQUserDetail *userDetail = [[LLQQUserDetail alloc] init];
        /* the flag ? */
        userDetail.uin = [[resDic objectForKey:@"uin"] longValue];
        userDetail.occupation = [resDic objectForKey:@"occupation"];
        userDetail.phone      = [resDic objectForKey:@"phone"];
        userDetail.allow      = [[resDic objectForKey:@"allow"] longValue];
        userDetail.college    = [resDic objectForKey:@"college"];
        userDetail.constellation = [[resDic objectForKey:@"constel"] longValue];
        userDetail.blood      = [[resDic objectForKey:@"blood"] longValue];
        userDetail.homepage   = [resDic objectForKey:@"homepage"];
        userDetail.stat       = [[resDic objectForKey:@"stat"] longValue];
        userDetail.vip_info   = [[resDic objectForKey:@"vip_info"] longValue];
        userDetail.country    = [resDic objectForKey:@"country"];
        userDetail.city       = [resDic objectForKey:@"city"];
        userDetail.personal   = [resDic objectForKey:@"personal"];
        userDetail.nickname   = [resDic objectForKey:@"nick"];
        userDetail.animal     = [[resDic objectForKey:@"shengxiao"] longValue];
        userDetail.email      = [resDic objectForKey:@"email"];
        userDetail.province   = [resDic objectForKey:@"province"];
        userDetail.gender     = [[resDic objectForKey:@"gender"] isEqualToString:@"male"] ? kGenderMale : kGenderFemale;
        userDetail.mobile     = [resDic objectForKey:@"mobile"];
                
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
                                   [NSString stringWithLong: uin], @"$(uin)", 
                                   _box.vfwebqq, @"$(vfwebqq)", 
                                   [LLQQParameterGenerator t], @"$(t)", nil];
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    [request addRequestHeader:@"Referer" value:@"http://s.web2.qq.com/"];

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
     
        NSDictionary *infoToReturn = [NSDictionary dictionaryWithObjectsAndKeys:signatureString, @"signature", [NSNumber numberWithLong:uin], @"uin", nil]; 
        [_delegate LLQQCommonRequestNotify:kQQRequestGetUserSignature isOK:YES info:infoToReturn];      
    }];
    
        
    [request startAsynchronous];
}

- (void)getUsersSignatures:(NSArray *)uins
{        
    static NSString *urlPattern = @"http://s.web2.qq.com/api/get_single_long_nick2?tuin=$(uin)&vfwebqq=$(vfwebqq)&t=$(t)";

    _nicknamgeOperationQueue = [[ASINetworkQueue alloc] init];
    [_nicknamgeOperationQueue setMaxConcurrentOperationCount:4];
    [_nicknamgeOperationQueue setShouldCancelAllRequestsOnFailure:NO];    
    
    for (NSNumber *uinNumber in uins) {
        
        NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSString stringWithFormat:@"%@",uinNumber], @"$(uin)", 
                                       _box.vfwebqq, @"$(vfwebqq)", 
                                       [LLQQParameterGenerator t], @"$(t)", nil];
        
        NSString *urlString = [urlPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];    
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
        [request addRequestHeader:@"Referer" value:@"http://s.web2.qq.com/"];
        request.tag = [uinNumber longValue];
        
        [request setFailedBlock:^(void) {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetUserSignature isOK:NO info:[request error]];
        }];
        
        [request setCompletionBlock:^(void) {
            NSString *response = [request responseString];
            NSDictionary *resDic = [response JSONValue];
            unsigned long uin = request.tag;
            
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
            NSDictionary *infoToReturn = [NSDictionary dictionaryWithObjectsAndKeys:signatureString, @"signature", [NSNumber numberWithLong:uin], @"uin", nil]; 
            [_delegate LLQQCommonRequestNotify:kQQRequestGetUserSignature isOK:YES info:infoToReturn];        
        }];        
        
        [_nicknamgeOperationQueue addOperation:request];        
    }
    
    [_nicknamgeOperationQueue performSelector:@selector(go) withObject:nil afterDelay:0.5];
}

- (void)getQQLevel:(long)uin
{
    static NSString *urlPattern = @"http://s.web2.qq.com/api/get_qq_level2?tuin=$(uin)&vfwebqq=$(vfwebqq)&t=$(t)";
    
    NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithLong: uin], @"$(uin)", 
                                   _box.vfwebqq, @"$(vfwebqq)", 
                                   [LLQQParameterGenerator t], @"$(t)", nil];
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetQQLevel isOK:NO info:[request error]];
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

- (void)changeStatus:(LLQQUserStatusType)status;
{
    static NSString *urlPattern = @"http://d.web2.qq.com/channel/change_status2?newstatus=$(status)&clientid=$(clientid)&psessionid=$(psessionid)&t=$(t)";
    
    NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSString stringFromQQStatus:status], @"$(status)", 
                                   _box.psessionid, @"$(psessionid)",
                                   _box.vfwebqq, @"$(clientid)", 
                                   [LLQQParameterGenerator t], @"$(t)", nil];
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestChangeStatus isOK:NO info:[request error]];
    }];
    
    [request setCompletionBlock:^(void) {
        NSString *response = [request responseString];
        NSDictionary *resDic = [response JSONValue];
        
        long retcode = [[resDic objectForKey:@"retcode"] longValue];
        if (retcode != 0) {
            [_delegate LLQQCommonRequestNotify:kQQRequestChangeStatus
                                          isOK:NO 
                                          info:[NSString stringWithFormat:@"retcode is NOT 0: %ld", retcode]];
            return ;
        }
        
        //resDic = [resDic objectForKey:@"result"];
        [_delegate LLQQCommonRequestNotify:kQQRequestChangeStatus isOK:YES info:nil];
        
    }];
    
    [request startAsynchronous];
}

- (void)getFaceOfUser:(long)uin isMe:(BOOL)isMe
{
    static NSString *urlPattern = @"http://face8.qun.qq.com/cgi/svr/face/getface?cache=$(cache)&type=1&fid=0&uin=$(uin)&vfwebqq=$(vfwebqq)";
    
    NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithLong:uin], @"$(uin)", 
                                   _box.vfwebqq,                  @"$(vfwebqq)", 
                                   isMe ? @"1": @"0", @"$(cache)", nil];
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];  
    if (isMe) {
        urlString = [urlString stringByAppendingFormat:@"&t=%@", [LLQQParameterGenerator t]];
    }    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    [request addRequestHeader:@"Referer" value:@"http://web.qq.com/"];

    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetFaceOfUser isOK:NO info:[request error]];
    }];
    
    [request setCompletionBlock:^(void) {    
        NSDictionary *headersDic = [request responseHeaders];
        
        if (nil != [headersDic objectForKey:@"Content-Type"] && 
            [@"image/jpeg" isEqualToString:[headersDic objectForKey:@"Content-Type"]]) {
            
            UIImage *faceImage = [UIImage imageWithData:[request responseData]];
            [_delegate LLQQCommonRequestNotify:kQQRequestGetFaceOfUser isOK:YES info:faceImage];
        } else {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetFaceOfUser isOK:NO info:@"Not the image type"];
        }
        
    }];
    
    [request startAsynchronous];
}

- (NSURL *)getFaceOfUserURL:(long)uin isMe:(BOOL)isMe
{
    static NSString *urlPattern = @"http://face8.qun.qq.com/cgi/svr/face/getface?cache=$(cache)&type=1&fid=0&uin=$(uin)&vfwebqq=$(vfwebqq)";
    
    NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithLong:uin], @"$(uin)", 
                                   _box.vfwebqq,                  @"$(vfwebqq)", 
                                   isMe ? @"1": @"0", @"$(cache)", nil];
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];  
    if (isMe) {
        urlString = [urlString stringByAppendingFormat:@"&t=%@", [LLQQParameterGenerator t]];
    }    
    return [NSURL URLWithString:urlString];
}

- (void)getAllOnlineFriends
{
    static NSString *urlPattern = @"http://d.web2.qq.com/channel/get_online_buddies2?clientid=$(clientid)&psessionid=$(psessionid)&t=$(t)";
    
    NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   _box.clientid,              @"$(clientid)", 
                                   _box.psessionid,            @"$(psessionid)", 
                                   [LLQQParameterGenerator t], @"$(t)", nil];
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    [request addRequestHeader:@"Referer" value:@"http://d.web2.qq.com/"];

    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetAllOnlineFriends isOK:NO info:[request error]];
    }];
    
    [request setCompletionBlock:^(void) {    
        NSString *response = [request responseString];
        NSDictionary *resDic = [response JSONValue];
        
        long retcode = [[resDic objectForKey:@"retcode"] longValue];
        if (retcode != 0) {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetAllOnlineFriends
                                          isOK:NO 
                                          info:[NSString stringWithFormat:@"retcode is NOT 0: %ld", retcode]];
            return;            
        } 
        
        NSArray *userStatusArray = [resDic objectForKey:@"result"];
        
        LLQQOnlineUsersList *onlineList = [[LLQQOnlineUsersList alloc] init];
        
        for (NSDictionary *userStatusDic in userStatusArray) {
            LLQQUserStatus *userStatus = [[LLQQUserStatus alloc] init];
            userStatus.uin = [[userStatusDic objectForKey:@"uin"] longValue];
            userStatus.status = [[userStatusDic objectForKey:@"status"] qqStatusValue];
            userStatus.clientType = [[userStatusDic objectForKey:@"client_type"] longValue];        
            [onlineList add:userStatus];
            [userStatus release];
        }
        
        [_delegate LLQQCommonRequestNotify:kQQRequestGetAllOnlineFriends isOK:YES info:[onlineList autorelease]];
        
    }];
    
    [request startAsynchronous];
}

- (void)getRecentFriends
{
    static NSString *urlString = @"http://d.web2.qq.com/channel/get_recent_list2";
    static NSString *contentPattern = @"{\"vfwebqq\":\"$(vfwebqq)\", \"clientid\":\"$(clientid)\", \"psessionid\":\"$(psessionid)\"}";
    
    NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   _box.vfwebqq,    @"$(vfwebqq)", 
                                   _box.clientid,   @"$(clientid)", 
                                   _box.psessionid, @"$(psessionid)", nil];
    
    NSString *postContent = [contentPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURLString:urlString];
    [request addRequestHeader:@"Referer" value:@"http://d.web2.qq.com/"];
    [request setPostValue:postContent forKey:@"r"];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetRecentFriends isOK:NO info:[request error]];
    }];
    
    [request setCompletionBlock:^(void){
        
        NSString *response = [request responseString];
        NSDictionary *resDic = [response JSONValue];
        
        if ([[resDic objectForKey:@"retcode"] longValue] != 0) {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetRecentFriends
                                          isOK:NO 
                                          info:[NSString stringWithFormat:@"retcode is %@", 
                                                [resDic objectForKey:@"retcode"]]];
            return ;
        }
        
        NSArray *recentsArray = [resDic objectForKey:@"result"];
        NSMutableArray *recentUins = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in recentsArray) {
            /* what the type value means ?  0:user, 1:group 2:discus group*/
            //long type = [[dic objectForKey:@"type"] longValue]; /*何用？*/
            unsigned long uin = [[dic objectForKey:@"uin"] longValue];
            [recentUins addObject:[NSNumber numberWithLong:uin]];            
        } 
        
        [_delegate LLQQCommonRequestNotify:kQQRequestGetRecentFriends isOK:YES info:[recentUins autorelease]];
        
    }];
    
    [request startAsynchronous];
}

- (void)getGroupInfoAndMembers:(long)gcode
{
    static NSString *urlPattern = @"http://s.web2.qq.com/api/get_group_info_ext2?gcode=$(gcode)&vfwebqq=$(vfwebqq)&t=$(t)";
    
    NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSString stringWithLong: gcode],@"$(gcode)", 
                                   _box.vfwebqq,                   @"$(vfwebqq)", 
                                   [LLQQParameterGenerator t],     @"$(t)", nil];
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfKeysWithValues:keysAndValues];    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    [request addRequestHeader:@"Referer" value:@"http://s.web2.qq.com/"];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetGroupInfoAndMembers isOK:NO info:[request error]];
    }];
    
    [request setCompletionBlock:^(void) {    
        NSString *response = [request responseString];
        NSDictionary *resDic = [response JSONValue];
        
        if ([[resDic objectForKey:@"retcode"] longValue] != 0) {
            [_delegate LLQQCommonRequestNotify:kQQRequestGetGroupInfoAndMembers
                                          isOK:NO 
                                          info:[NSString stringWithFormat:@"retcode is %@", 
                                                [resDic objectForKey:@"retcode"]]];
            return ;
        }
        
        resDic = [resDic objectForKey:@"result"];
        
        NSDictionary *groupInfoDic = [resDic objectForKey:@"ginfo"];
        LLQQGroup *group = [[LLQQGroup alloc] init];
        group.memo = [groupInfoDic objectForKey:@"memo"];
        group.fingermemo = [groupInfoDic objectForKey:@"fingermemo"];
        group.createTime = [[groupInfoDic objectForKey:@"createtime"] doubleValue];
        group.level = [[groupInfoDic objectForKey:@"level"] longValue];
        group.name = [groupInfoDic objectForKey:@"name"];
        group.gid = [[groupInfoDic objectForKey:@"gid"] longValue];
        group.ownerUin = [[groupInfoDic objectForKey:@"owner"] longValue];
        NSArray *membersArray = [groupInfoDic objectForKey:@"members"];
        for (NSDictionary *memberDic in membersArray) {
            LLQQUser *user = [[LLQQUser alloc] init];
            user.uin = [[memberDic objectForKey:@"muin"] longValue];
            [group addUser:user];
            [user release];
        }
        
        NSArray *vipinfoArray = [resDic objectForKey:@"vipinfo"];
        for (NSDictionary *vipinfoDic in vipinfoArray) {
            unsigned long uin = [[vipinfoDic objectForKey:@"u"] longValue];
            LLQQUser *user = [group getUser:uin];
            if (user) {
                user.vipLevel = [[vipinfoDic objectForKey:@"vip_level"] longValue];
                user.isVIP = [[vipinfoDic objectForKey:@"is_vip"] boolValue];
            }
        }
        
        NSArray *minfoArray = [resDic objectForKey:@"minfo"];
        for (NSDictionary *minfoDic in minfoArray) {
            unsigned long uin = [[minfoDic objectForKey:@"uin"] longValue];
            LLQQUser *user = [group getUser:uin];
            if (user) {
                user.nickname = [minfoDic objectForKey:@"nick"];
                user.userDetail.gender = [[minfoDic objectForKey:@"gender"] genderValue];
            }                                          
        }
        
        LLQQOnlineGroupUsersList *onlineGroupUsersList = [[LLQQOnlineGroupUsersList alloc] init];
        NSArray *statsArray = [resDic objectForKey:@"stats"];
        for (NSDictionary *statDic in statsArray) {
            LLQQUserStatus *state = [[LLQQUserStatus alloc] init];
            state.uin = [[statDic objectForKey:@"uin"] longValue];
            state.clientType = (LLQQClientType) [[statDic objectForKey:@"client_type"] longValue];
            state.status = [[statDic objectForKey:@"stat"] longValue];
            [onlineGroupUsersList add:state];
            [state release];
        }
        
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:group, @"group", 
                                                         onlineGroupUsersList, @"onlineList", nil];
        
        [group release];
        [onlineGroupUsersList release];        
        [_delegate LLQQCommonRequestNotify:kQQRequestGetGroupInfoAndMembers isOK:YES info:info];
    }];
    
    [request startAsynchronous];    
}

- (void)sendMsgTemplate:(unsigned long)uin msgs:(NSArray *)msgs type:(LLQQCommonRequestType)requestType
{
    NSString *urlString = nil;
    NSString *uinKeyName = nil;
    switch (requestType) {
        case kQQRequestSendMsg:
            urlString = @"http://d.web2.qq.com/channel/send_buddy_msg2";
            uinKeyName = @"to";
            break;
        case kQQRequestSendGroupMsg:    
            urlString = @"http://d.web2.qq.com/channel/send_qun_msg2";
            uinKeyName = @"group_uin";
            break;
        case kQQRequestSendDiscusMsg:
            urlString = @"http://d.web2.qq.com/channel/send_discu_msg2";
            uinKeyName = @"did";
            break;
        default:
            break;
    }    

    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    [json setObject:[NSNumber numberWithUnsignedLong:(unsigned long)uin] forKey:uinKeyName];
    if (requestType == kQQRequestSendMsg) {
        [json setObject:[NSNumber numberWithLong:0] forKey:@"face"];
    }
    [json setObject:[LLQQParameterGenerator msgId] forKey:@"msg_id"];
    [json setObject:_box.clientid forKey:@"clientid"];
    [json setObject:_box.psessionid forKey:@"psessionid"];
    NSArray *fontArray = [[LLQQParameterGenerator fontJsonStringForMsg] JSONValue];
    NSMutableArray *contentArray = [NSMutableArray arrayWithArray:msgs];
    [contentArray addObject:fontArray];
    [json setObject:[contentArray JSONRepresentation] forKey:@"content"];
    
    NSString *postContent = [json JSONRepresentation];
    DEBUG_LOG_WITH_FORMAT(@"post content for msg is %@", postContent);
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURLString:urlString];
    [request setPostValue:postContent forKey:@"r"];
    [request setPostValue:_box.clientid forKey:@"clientid"];
    [request setPostValue:_box.psessionid forKey:@"psessionid"];
    [request addRequestHeader:@"Referer" value:@"http://d.web2.qq.com/"];
    [request setCompletionBlock:^(void){        
        NSString *response = [request responseString];
        NSDictionary *resDic = [response JSONValue];
        if ([[resDic objectForKey:@"retcode"] longValue] != 0) {
            [_delegate LLQQCommonRequestNotify:requestType
                                          isOK:NO 
                                          info:[NSString stringWithFormat:@"retcode is %@", 
                                                [resDic objectForKey:@"retcode"]]];
            return ;
        }        
        [_delegate LLQQCommonRequestNotify:requestType isOK:YES info:nil];
        
    }];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:requestType isOK:NO info:[request error]];
    }];
    
    [request startAsynchronous];   
}

- (void)sendMsgTo:(unsigned long)uin msgs:(NSArray *)msgs
{
    NSMutableArray *msgsToSend = [NSMutableArray arrayWithArray:msgs];
    //[msgsToSend addObject:@"\n\n【来自 LeQQ for iPhone(https://github.com/lemacs/LeQQ)】"];
    [self sendMsgTemplate:uin msgs:msgsToSend type:kQQRequestSendMsg];
}

- (void)sendDiscusMsgTo:(unsigned long)did msgs:(NSArray *)msgs
{
    [self sendMsgTemplate:did msgs:msgs type:kQQRequestSendDiscusMsg];       
}

- (void)sendGroupMsgTo:(unsigned long)gid msgs:(NSArray *)msgs
{
    [self sendMsgTemplate:gid msgs:msgs type:kQQRequestSendGroupMsg];
}

- (void)poll
{
    static NSString *urlString = @"http://d.web2.qq.com/channel/poll2";
    
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    [json setObject:[NSArray array] forKey:@"ids"];
    [json setObject:[NSNumber numberWithLong:0] forKey:@"key"];
    [json setObject:_box.clientid forKey:@"clientid"];
    [json setObject:_box.psessionid forKey:@"psessionid"];
    
    NSString *postContent = [json JSONRepresentation];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURLString:urlString];    
    [request setPostValue:postContent forKey:@"r"];
    [request setPostValue:_box.clientid forKey:@"clientid"];
    [request setPostValue:_box.psessionid forKey:@"psessionid"];
    [request addRequestHeader:@"Referer" value:@"http://d.web2.qq.com/"];
    [request setTimeOutSeconds:QQ_REQUEST_POLLING_TIMEOUT];
    [request setCompletionBlock:^(void){
        
        NSString *response = [request responseString];
        NSDictionary *resDic = [response JSONValue];
        long retcode = [[resDic objectForKey:@"retcode"] longValue];
        
        if (retcode == 102){
            /* not msg */
            return;
        }
        else if (retcode != 0) {
            [_delegate LLQQCommonRequestNotify:kQQRequestPoll
                                          isOK:NO 
                                          info:[NSString stringWithFormat:@"retcode is %@", 
                                                [resDic objectForKey:@"retcode"]]];
            return ;
        }        
        
        NSArray *polls = [resDic objectForKey:@"result"];
        for (NSDictionary *poll in polls) {
            
            if ([[poll objectForKey:@"poll_type"] isEqualToString:@"message"] ||
                [[poll objectForKey:@"poll_type"] isEqualToString:@"discu_message"] ||
                [[poll objectForKey:@"poll_type"] isEqualToString:@"discu_message"]) {
                NSDictionary *msgDic = [poll objectForKey:@"value"];
                LLQQMsg *msg = [[LLQQMsg alloc] init];
                msg.msgId   = [[msgDic objectForKey:@"msg_id"]   longValue];
                msg.fromUin = [[msgDic objectForKey:@"from_uin"] longValue];
                msg.toUin   = [[msgDic objectForKey:@"to_uin"]   longValue];
                msg.MsgId2  = [[msgDic objectForKey:@"msg_id2"]  longValue];
                msg.replyIp = [[msgDic objectForKey:@"reply_ip"] longValue];
                /* use the time base on local time */
                //msg.time = [[msgDic objectForKey:@"time"] longValue];
                msg.time = [[NSDate date] timeIntervalSince1970];
                msg.content = [[[msgDic objectForKey:@"content"] JSONRepresentation] msgContentValue];
                
                if ([[poll objectForKey:@"poll_type"] isEqualToString:@"message"]) {
                    msg.srcType = kQQMsgSourceUser;
                } else if ([[poll objectForKey:@"poll_type"] isEqualToString:@"discu_message"]) {
                    msg.srcType = kQQMsgSourceDiscus;
                    msg.did = [[msgDic objectForKey:@"did"] longValue];
                    msg.sendUin = [[msgDic objectForKey:@"send_uin"] longValue];
                    msg.seq = [[msgDic objectForKey:@"seq"] longValue];
                    msg.infoSeq = [[msgDic objectForKey:@"info_seq"] longValue];
                } else {
                    msg.srcType = kQQMsgSourceGroup;
                    msg.sendUin = [[msgDic objectForKey:@"send_uin"] longValue];
                    msg.groupCode = [[msgDic objectForKey:@"group_code"] longValue];
                    msg.seq = [[msgDic objectForKey:@"seq"] longValue];
                    msg.infoSeq = [[msgDic objectForKey:@"info_seq"] longValue];
                }
                
                [_delegate LLQQCommonRequestNotify:kQQRequestPoll isOK:YES info:msg]; 
                [msg release];
            }
        }
        
        /* ..... many and many code.... */        
        //[_delegate LLQQCommonRequestNotify:kQQRequestPoll isOK:YES info:nil];        
    }];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestPoll isOK:NO info:[request error]];
    }];
    
    [request startAsynchronous];   
}

@end
