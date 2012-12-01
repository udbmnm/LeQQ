//
//  LLNotificationCenter.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-5.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLNotificationCenter : NSObject

#define kNotificationInfoKeyForValue @"value"

typedef enum {
    kNotificationTypeNull = 0,
    kNotificationTypeLoginSuccess = 1,
    kNotificationTypeNewMessage = 2,               /* for polling msg noti */
    kNotificationTypeUnreadMessageFromFriend = 3,   /* noti the chatting view*/
}LLNotificationType;

+ (void)add:(id)observer selector:(SEL)selector notificationType:(LLNotificationType)type;
+ (void)post:(LLNotificationType)type value:value;
+ (void)remove:(id)observer;
@end
