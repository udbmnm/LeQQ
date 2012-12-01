//
//  LLQQChattingViewController.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-8.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLQQCommonRequest.h"

@interface LLQQChattingViewController : UIViewController<UIBubbleTableViewDataSource, LLQQCommonRequestDelegate>
{
    long friendUin;
    LLQQCommonRequest *_request;
}

@property (nonatomic, assign) long friendUin;
- (IBAction)sendMsgBtnClicked:(id)sender;
- (id)initWitFriendUin:(long)uin;
@end
