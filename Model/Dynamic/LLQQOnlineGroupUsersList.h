//
//  LLQQOnlineGroupUsersList.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-16.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLQQUserStatus.h"

@interface LLQQOnlineGroupUsersList : NSObject
{
    NSMutableArray *_onlineList;
}
- (void)add:(LLQQUserStatus*)aUserStatus;
- (NSArray *)getArrayOfUserStatus;
@end
