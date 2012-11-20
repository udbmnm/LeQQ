//
//  ASIHTTPRequest+ASIQQHelper.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-10.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "ASIHTTPRequest+ASIQQHelper.h"

@implementation ASIHTTPRequest (ASIQQHelper)
+ (void)setDefaults
{
    [ASIHTTPRequest setDefaultUserAgentString:QQ_REQUEST_DEFAULT_USER_AGENT];
    [ASIHTTPRequest setDefaultTimeOutSeconds:QQ_REQUEST_DEFAULT_TIMEOUT];
    [ASIHTTPRequest setSessionCookies:nil];
    [ASIHTTPRequest clearSession];
}

+ (ASIHTTPRequest*)requestWithURLString:(NSString *)urlString
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request addRequestHeader:@"Accept-Language" value:@"en-US,en;q=0.5"];
    [request addRequestHeader:@"Accept-Encoding" value:@"gzip, deflate"];
    [request addRequestHeader:@"Accept" value:@"*/*"];
    [request addRequestHeader:@"Referer" value:@"http://s.web2.qq.com/proxy.html?v=20110412001&callback=1&id=1"];
    return request;
}
@end

@implementation ASIFormDataRequest (ASIFormDataRequest_LLHelper)
+ (ASIFormDataRequest*)requestWithURLString:(NSString *)urlString
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request addRequestHeader:@"Accept-Language" value:@"en-US,en;q=0.5"];
    [request addRequestHeader:@"Accept-Encoding" value:@"gzip, deflate"];
    [request addRequestHeader:@"Accept" value:@"*/*"];
    [request addRequestHeader:@"Referer" value:@"http://s.web2.qq.com/proxy.html?v=20110412001&callback=1&id=1"];
    return request;
}
@end