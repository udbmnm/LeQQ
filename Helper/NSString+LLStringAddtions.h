//
//  NSString+LLStringAddtions.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-13.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLQQCommon.h"

@interface NSString (LLStringAddtions)

- (NSString *)stringByReplacingOccurrencesOfKeysWithValues:(NSDictionary *)keysAndValues;
- (LLQQUserStatusType)qqStatusValue;
+ (NSString *)stringFromQQStatus:(LLQQUserStatusType)status;
@end
