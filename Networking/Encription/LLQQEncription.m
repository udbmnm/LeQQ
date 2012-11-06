//
//  LLQQEncription.m
//  LeQQ
//
//  Created by Xiangle le on 12-10-31.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQEncription.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NSStringMD5)
- (NSString *) md5 
{
    char cStr[1024];
    int i = 0;
    for (; i < [self length] && i < 1023; i++ ){
        cStr[i] = (char)([self characterAtIndex:i] & 0xFF);
    }
    cStr[i] = '\0';
     
    unsigned char result[16];
 	    CC_MD5(cStr, [self length], result);
 	    return [NSString stringWithFormat:
                          @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                ];
 }
@end

@implementation NSString(QQEncriptionAdditions)

- (NSString *)hexchar2bin
{
    const char *cStr = [self cStringUsingEncoding:NSASCIIStringEncoding];
    char aPair[3] = {0, 0, 0};
    NSString *result = @"";
    for (int i = 0; i < strlen(cStr); i+=2) {
        strncpy(aPair, cStr + i, 2);
        long number = strtol(aPair, NULL, 16); 
        unichar aChar = (char)(number & 0xFF);
        result = [result stringByAppendingString:[NSString stringWithCharacters:&aChar length:1]];

    }
    return result;
}
@end

@implementation LLQQEncription
+ (NSString *)hashPasswordForLogin:(NSString *)password v1:(NSString *)verifyCode v2:(NSString *)verifyCodeHex
{
    NSString *I = [[password md5] hexchar2bin];
    NSString *HH = [I stringByAppendingString:[[verifyCodeHex stringByReplacingOccurrencesOfString:@"\\x" withString:@""] hexchar2bin]];
    NSString *H = [HH md5];
    NSString *G = [[H stringByAppendingString:[verifyCode uppercaseString]] md5];
    return G;
}
@end
