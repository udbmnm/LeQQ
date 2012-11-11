//
//  LLDebug.h
//  LeQQ
//
//  Created by Xiangle le on 12-10-26.
//  Copyright (c) 2012年 GUET/Wondershare. All rights reserved.
//



@protocol LLObjectPrinter <NSObject>
@optional
- (void)printMySelf;

@end



#define DEBUG_LOG_WITH_MSG(msg) NSLog(@"[File:%s] [Func:%s] [Line:%d]:\n--> %@", __FILE__, __FUNC__, __LINE__, msg)
# define DEBUG_LOG_WITH_FORMAT(format, ...) NSLog((@"[File:%s] [Func:%s] [Line:%d]:\n-->" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);    



#define DEBUG_AUTOINPUT_USER_PASSWORD