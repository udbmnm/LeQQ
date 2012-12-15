//
//  LLGroupsAndDiscusController.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-21.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "SDNestedTableViewController.h"
#import "LLQQCommonRequest.h"
#import "LLQQModel.h"

@interface LLGroupsAndDiscusController : SDNestedTableViewController<LLQQCommonRequestDelegate>
{
    LLQQCommonRequest *_request;
    
    NSDictionary *_groupsDic;
    NSDictionary *_discusDic;
    
    LLQQGroupsAndDiscusTree *_dataTree;
}
@end
