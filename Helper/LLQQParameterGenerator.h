//
//  LLQQParameterGenerator.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-13.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLQQParameterGenerator : NSObject


+ (NSString *)r;
+ (NSString *)clientid;
+ (NSString *)t;
+ (NSString *)msgId;
+ (NSString *)fontJsonStringForMsg;
@end
