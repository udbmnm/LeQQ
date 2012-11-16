//
//  LLQQUserStatus.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-15.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQCommon.h"

@interface LLQQUserStatus : NSObject
{
    long uin;
    LLQQUserStatusType status;
    LLQQClientType clientType;
}

@property (nonatomic, assign) long uin;
@property (nonatomic, assign) LLQQUserStatusType status;
@property (nonatomic, assign) LLQQClientType clientType;

@end
