//
//  LLModelObject.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-7.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLModelObject.h"
#import "LLFMDBHelper.h"

@implementation LLModelObject

- (id)initWithDictionary:(NSDictionary *)dic
{
    [NSException raise:@"[LLModelObject error]" 
                format:@"You must overide the method %s in %@", __FUNCTION__, NSStringFromClass([self class])];
    return self;
}

- (NSDictionary *)dictionary
{
    [NSException raise:@"[LLModelObject error]" 
                format:@"You must overide the method %s in %@", __FUNCTION__, NSStringFromClass([self class])];
    return nil;
}

/* required for sqlite database */
- (NSString *)primaryKey
{
    [NSException raise:@"[LLModelObject error]" 
                format:@"You must overide the method %s in %@", __FUNCTION__, NSStringFromClass([self class])];
    return nil;
}

- (NSString *)objectClassName
{
    return NSStringFromClass([self class]);
}

/*
 * search the db for an entry which have the same primary key with self.
 * Ensure that the primary key is be set for self, since the db use the 
 * primary key to search in db tables.
 */
- (id)copyFromDB
{
    return [[LLFMDBHelper shareInstance] getObjectBy:self];
}
- (BOOL)saveToDB
{
    return [[LLFMDBHelper shareInstance] saveObject:self];
}

@end
