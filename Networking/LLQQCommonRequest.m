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
        
        /* ..... */
        
    }];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQCommonRequestNotify:kQQRequestGetAllFriends info:[request error]];
    }];
    
    [request startAsynchronous];    
    
}

@end
