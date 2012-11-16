//
//  ASIHTTPRequest+ASIQQHelper.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-10.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <ASIFormDataRequest.h>

@interface ASIHTTPRequest (ASIQQHelper)
+ (void)setDefaults;
+ (ASIHTTPRequest*)requestWithURLString:(NSString *)urlString;
@end

@interface ASIFormDataRequest (ASIFormDataRequest_LLHelper)
+ (ASIFormDataRequest*)requestWithURLString:(NSString *)urlString;
@end