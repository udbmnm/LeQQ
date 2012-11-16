//
//  LLQQOnlineList.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-15.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQUserStatus.h"
#import "LLQQCategory.h"

@interface LLQQOnlineList : NSObject
{
    NSMutableArray *_onlineList;
}
- (void)add:(LLQQUserStatus*)aUserStatus;
- (NSArray *)getOnlineStatusListOfCategory:(LLQQCategory *)category;
@end
