//
//  LLQQGroup.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-13.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQGroup.h"

@implementation LLQQGroup

@synthesize name, gid, code, face, usersMap, groupNum;

- (id)init
{
    if (self = [super init]) {
        name = nil;
        gid = (long)-1;
        code = (long)-1;
        groupNum = (long)-1;
        face = nil;
        usersMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.name = nil;
    self.face = nil;
    self.usersMap = nil;
    [super dealloc];
}

@end
