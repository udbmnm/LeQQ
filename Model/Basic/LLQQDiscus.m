//
//  LLQQDiscus.m
//  LeQQ
//
//  Created by xiangle gan on 12-12-15.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQDiscus.h"

@implementation LLQQDiscus
@synthesize did, name;

- (id)init
{
    if (self = [super init]) {
        did = -1;
        name = nil;
    }
    return self;
}

- (void)dealloc
{
    self.name = nil;
    [super dealloc];
}

- (NSComparisonResult)compareWithDiscus:(LLQQDiscus *)anotherDiscus;
{
    if (self.did > anotherDiscus.did) {
        return NSOrderedDescending;
    } else if (self.did < anotherDiscus.did) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }       
}
@end
