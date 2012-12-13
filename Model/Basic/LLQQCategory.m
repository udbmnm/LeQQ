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

- (BOOL)addUser:(LLQQUser *)user
{
    if (self.index != user.categoryIndex) {
        return NO;
    }
    
    LLQQUser* theUser = (LLQQUser*)[self.usersMap objectForKey:[NSString stringWithLong: user.uin]];
    
    /* if the user exist, update the user*/
    if (theUser != nil) {
        theUser = [theUser mergedWith:user];
        [self.usersMap setObject:user forKey:[NSString stringWithLong: user.uin]];
        return YES;
    }    
    else {
        [self.usersMap setObject:user forKey:[NSString stringWithLong: user.uin]];
        return YES;
    }
        
}

- (LLQQUser *)getUser:(long)uin
{
    id theUser = [self.usersMap objectForKey:[NSString stringWithLong: uin]];
    if (theUser == nil) {
        return NO;
    }    

    return (LLQQUser *)theUser;
}

- (NSComparisonResult)compareWithCategory:(LLQQCategory *)category;
{
    if (self.index > category.index) {
        return NSOrderedDescending;
    } else if (self.index < category.index) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}
@end
