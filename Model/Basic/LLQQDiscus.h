//
//  LLQQDiscus.h
//  LeQQ
//
//  Created by xiangle gan on 12-12-15.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLQQDiscus : NSObject
{
    unsigned long did;
    NSString *name;
}

@property (nonatomic, assign) unsigned long did;
@property (nonatomic, retain) NSString *name;

- (NSComparisonResult)compareWithDiscus:(LLQQDiscus *)anotherDiscus;
@end
