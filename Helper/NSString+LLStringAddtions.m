//
//  NSString+LLStringAddtions.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-13.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "NSString+LLStringAddtions.h"

@implementation NSString (LLStringAddtions)

- (NSString *)stringByReplacingOccurrencesOfKeysWithValues:(NSDictionary *)keysAndValues
{
    NSString *finalString = self;
    for (NSString *key in [keysAndValues allKeys]) {
        finalString = [finalString stringByReplacingOccurrencesOfString:key withString:[keysAndValues objectForKey:key]];
    }
    return finalString;
}
@end
