//
//  NSString+LLQQStringAddtions.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-13.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "NSString+LLQQStringAddtions.h"
#import "LLQQMsg.h"

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

+ (NSString *)stringWithLong:(long)value
{
    return [NSString stringWithFormat:@"%ld", value];
}

- (LLQQMsgContent *)msgContentValue;
{
    NSArray *contents = [self JSONValue];
    LLQQMsgContent *msgContent = [[LLQQMsgContent alloc] init];
    for (id obj in contents) {
        if ([obj isKindOfClass:[NSString class]]) {
            [msgContent addMsgElement:obj];
            continue;
        } else if ([obj isKindOfClass:[NSArray class]]) {
            if ([[obj objectAtIndex:0] isEqualToString:@"font"]) {
                LLQQMsgFont *font = [[LLQQMsgFont alloc] init];
                /* add the interpretation of font */  
                [msgContent addMsgElement:font];
                [font release];
            } else if ([[obj objectAtIndex:0] isEqualToString:@"cface"]) {
                LLQQMsgCface *cface = [[LLQQMsgCface alloc] init];
                NSDictionary *objDic = [obj objectAtIndex:1];
                cface.name = [objDic objectForKey:@"name"];
                cface.fileId = [[objDic objectForKey:@"file_id"] longValue];
                cface.key = [objDic objectForKey:@"key"];
                cface.server = [objDic objectForKey:@"server"];
                [msgContent addMsgElement:cface];
                [cface release];
            }
        }        
    }
    return msgContent;
}
@end
