//
//  LLQQPathManager.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-1.
//  Copyright (c) 2012年 GUET/Wondershare. All rights reserved.
//

#import "LLQQPathManager.h"

@implementation LLQQPathManager
+ (id)shareInstance
{
    static LLQQPathManager *m = nil;
    if (m == nil) {
        m = [[LLQQPathManager alloc] init];
    }
    return m;
}

- (id)init
{
    self = [super init];
    return self;
}

+ (NSString *)getPathOfTmp
{
    return NSTemporaryDirectory();
}

+ (NSString *)getPathOfDocuments
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    return documentPath;
}
@end
