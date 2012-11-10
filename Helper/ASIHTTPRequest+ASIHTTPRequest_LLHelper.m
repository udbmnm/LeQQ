//
//  ASIHTTPRequest+ASIHTTPRequest_LLHelper.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-10.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "ASIHTTPRequest+ASIHTTPRequest_LLHelper.h"

@implementation ASIHTTPRequest (ASIHTTPRequest_LLHelper)
+ (void)setDefaults
{
    [ASIHTTPRequest setDefaultUserAgentString:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20100101 Firefox/16.0"];
    [ASIHTTPRequest setDefaultTimeOutSeconds:5.0];
    [ASIHTTPRequest setSessionCookies:nil];
    [ASIHTTPRequest clearSession];
}

+ (ASIHTTPRequest*)requestWithURLString:(NSString *)urlString
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request addRequestHeader:@"Accept-Language" value:@"en-US,en;q=0.5"];
    [request addRequestHeader:@"Accept-Encoding" value:@"gzip, deflate"];
    [request addRequestHeader:@"Accept" value:@"*/*"];
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
    return request;
}
@end