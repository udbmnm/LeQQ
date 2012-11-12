//
//  LLFriendsController.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLQQCommonRequest.h"

@interface LLFriendsController : UIViewController <LLQQCommonRequestDelegate>
{
    UISegmentedControl *_segment;
    LLQQCommonRequest *_request;
}

@end
