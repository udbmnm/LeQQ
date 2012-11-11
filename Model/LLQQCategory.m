//
//  LLQQCategory.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQCategory.h"

@implementation LLQQCategory
@synthesize index, sort, name, usersMap;

-(id)init
{
    if (self = [super init]) {
        index = -1;
        sort = -1;
        name = nil;
        usersMap = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

-(void)dealloc
{
    self.usersMap = nil;
    [super dealloc];
}

@end
