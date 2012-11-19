//
//  LLQQParameterGenerator.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-13.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQParameterGenerator.h"

@implementation LLQQParameterGenerator

+ (NSString *)r
{
    return [NSString stringWithFormat:@"%.2f", 
            [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] longValue]/100.0 ];
}

+ (NSString *)clientid
{
    return @"73937879";
}

+ (NSString *)t
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", interval];
}

+ (NSString *)msgId
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", interval/ 1000.0];
}

+ (NSString *)fontJsonStringForMsg
{
    return @"[\"font\",{\"name\":\"宋体\",\"size\":\"10\",\"style\":[0,0,0],\"color\":\"000000\"}]";
}

@end
