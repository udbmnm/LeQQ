//
//  LLObjectValidator.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-13.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLObjectValidator.h"

@implementation LLObjectValidator

+ (BOOL)isQQUserNameFormatLegal:(NSString *)user
{
    return  [user isKindOfClass:[NSString class]] && user.length >= 4;
}

+ (BOOL)isQQPasswordFormatLegal:(NSString *)password
{
    return [password isKindOfClass:[NSString class]] && password.length >= 3;
}

@end
