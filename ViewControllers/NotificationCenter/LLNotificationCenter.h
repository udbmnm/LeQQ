//
//  LLNotificationCenter.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-5.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLNotificationCenter : NSObject

typedef enum {
    kNotificationTypeLoginSuccess = 1
}LLNotificationType;

+ (void)add:(id)observer selector:(SEL)selector notificationType:(LLNotificationType)type;
+ (void)post:(LLNotificationType)type info:(NSDictionary *)info;
+ (void)remove:(id)observer;
@end
