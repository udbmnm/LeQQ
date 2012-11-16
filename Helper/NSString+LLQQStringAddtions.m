//
//  NSString+LLQQStringAddtions.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-13.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "NSString+LLQQStringAddtions.h"

@implementation NSString (LLQQStringAddtions)

- (NSString *)stringByReplacingOccurrencesOfKeysWithValues:(NSDictionary *)keysAndValues
{
    NSString *finalString = self;
    for (NSString *key in [keysAndValues allKeys]) {
        finalString = [finalString stringByReplacingOccurrencesOfString:key 
                                                             withString:[keysAndValues objectForKey:key]];
    }
    return finalString;
}

- (LLQQUserStatusType)qqStatusValue
{
    if ([self isEqualToString:@"online"]) {
        return kQQUserStatusOnline;
    }
    
    return kQQUserStatusNull;
}

+ (NSString *)stringFromQQStatus:(LLQQUserStatusType)status
{
    switch (status) {
        case kQQUserStatusOnline:
            return @"online";
            break;
            
        default:
            break;
    }
    
    return nil;
}

- (LLGender)genderValue
{
    if ([self isEqualToString:@"male"]) {
        return kGenderMale;
    } else if ([self isEqualToString:@"female"]) {
        return kGenderFemale;
    } else {
        return kGenderNull;
    }
}

+ (NSString *)stringFromGenderValue:(LLGender)gender
{
    return gender == kGenderMale ? @"male" : (gender == kGenderFemale) ? @"female" : nil;    
}
@end
