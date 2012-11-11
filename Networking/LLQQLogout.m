//
//  LLQQLogout.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQLogout.h"
#import "ASIHTTPRequest+ASIHTTPRequest_LLHelper.h"

@implementation LLQQLogout

- (id)initWithClientID:(NSString *)clientid psessionid:(NSString *)psessionid delegate:(id<LLQQLogoutDelegate>)delegate
{
    if (self = [super init]) {
        _clientid = [clientid copy];
        _psessionid = [psessionid copy];
        _delegate = delegate;
    }
    return self;
}

- (void)dealloc
{
    [_clientid release];
    [_psessionid release];
    [super dealloc];
}

- (void)startAsynchronous
{
    static NSString *urlPattern = @"http://d.web2.qq.com/channel/logout2?ids=&clientid=$(clientid)&psessionid=$(psessionid)";
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfString:@"$(clientid)" withString:_clientid];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"$(psessionid)" withString:_psessionid];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    [request addRequestHeader:@"Referer" value:@"http://d.web2.qq.com/proxy.html?v=20110331002&callback=1&id=3"];
    
    [request setCompletionBlock:^(void){
        NSString *result = [request responseString];
        NSDictionary *resDic = [result JSONValue];
        if ([[resDic objectForKey:@"retcode"] longValue] == 0) {
            [_delegate LLQQLogoutNotifyFailOrSuccess:YES info:nil];
        } else {
            [_delegate LLQQLogoutNotifyFailOrSuccess:NO info:[resDic objectForKey:@"result"]];
        }
    }];
    
    [request setFailedBlock:^(void) {
        [_delegate LLQQLogoutNotifyFailOrSuccess:NO info:[request error]];
    }];
    
    [request startAsynchronous];
}

@end
