//
//  LLNotificationCenter.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-5.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLNotificationCenter.h"



@implementation LLNotificationCenter

+ (NSString *)notificationTypeToString:(LLNotificationType)type
{
    static NSString *typeToStringMaps[] = 
    {
        /* 0 */nil, 
        /* 1 */@"User login completed", /* userinfo: dictionary: { "value": (LLQQMoonBox*)object } */
        /* 2 */@"New message comming"   /* userinfo: dictionary: { "value": (LLQQMsg*)object } */
        /* 3 */
        /* 4 */
        /* 5 */
    };
    return [NSString stringWithFormat:@"%@ [%d]: %@", 
            NSStringFromClass([LLNotificationCenter class]), type, typeToStringMaps[(NSInteger)type]];
}

+ (void)add:(id)observer selector:(SEL)selector notificationType:(LLNotificationType)type
{
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:selector 
                                                 name:[LLNotificationCenter notificationTypeToString:type]  
                                               object:nil];
}

+ (void)post:(LLNotificationType)type value:value;
{
    NSAssert(value != nil, @"value cannot be nil");
    [[NSNotificationCenter defaultCenter] postNotificationName:[LLNotificationCenter notificationTypeToString:type] 
                                                        object:nil 
                                                      userInfo:[NSDictionary dictionaryWithObject:value forKey:kNotificationInfoKeyForValue]];
}

+ (void)remove:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}
@end
