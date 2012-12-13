//
//  LLQQPathManager.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-1.
//  Copyright (c) 2012年 GUET/Wondershare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLQQPathManager : NSObject
+ (id)shareInstance;
- (id)init;
+ (NSString *)getPathOfTmp;
+ (NSString *)getPathOfDocuments;
+ (NSString *)getDirPathForVerifyCode;
@end
