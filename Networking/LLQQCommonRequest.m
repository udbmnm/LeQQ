//
//  LLQQCommonRequest.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQCommonRequest.h"
#import "ASIHTTPRequest+ASIHTTPRequest_LLHelper.h"

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
            [_delegate LLQQCommonRequestNotify:kQQRequestGetAllFriends info:@"未知错误"];
        }
        
        resDic = [resDic objectForKey:@"result"];
        NSArray *friends = [resDic objectForKey:@"friends"];
        NSArray *marknames = [resDic objectForKey:@"marknames"];
        NSArray *categories = [resDic objectForKey:@"categories"];
        NSArray *vipinfo = [resDic objectForKey:@"vipinfo"];
        NSArray *info = [resDic objectForKey:@"info"];
        
        for (NSDictionary *aCategory in categories) {
            
        }
        
        /* ..... */
        
    }];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetAllFriends info:[request error]];
    }];
    
    [request startAsynchronous];    
    
}

@end
