//
//  LLQQEncription.h
//  LeQQ
//
//  Created by Xiangle le on 12-10-31.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLQQEncription : NSObject

/* 
 * encript the password with two parameters, the method using 
 * the md5 three times mixing the 3 string
 */
+ (NSString *)hashPasswordForLogin:(NSString *)password v1:(NSString *)verifyCode v2:(NSString *)verifyCodeHex;

@end
