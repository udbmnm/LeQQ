//
//  LLQQLogout.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LLQQLogoutDelegate <NSObject>
@required
- (void)LLQQLogoutNotifyFailOrSuccess:(BOOL)ret info:(id)info;
@end

@interface LLQQLogout : NSObject
{
    NSString *_clientid;
    NSString *_psessionid;
    id<LLQQLogoutDelegate> _delegate;
}
- (id)initWithClientID:(NSString *)clientid psessionid:(NSString *)psessionid delegate:(id<LLQQLogoutDelegate>)delegate;
- (void)startAsynchronous;
@end