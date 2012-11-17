//
//  LLFriendsController.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLQQCommonRequest.h"
#import "LLQQUserCell.h"

@interface LLFriendsController : SDNestedTableViewController <LLQQCommonRequestDelegate>
{
    UISegmentedControl *_segment;
    LLQQCommonRequest *_request;
    LLQQUsersTree *_usersTree;
    NSDictionary *_categoriesDic;
    LLQQOnlineUsersList *_onlineUsersList;
}

@end
