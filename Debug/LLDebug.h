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



#define DEBUG_WITH_MSG(msg) NSLog(@"[%@ %@ %d]: %@", __FILE__, __FUNC__, __LINE__, msg)






