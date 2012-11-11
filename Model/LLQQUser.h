//
//  LLQQUser.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLModelObject.h"
#import "LLQQUserDetail.h"

@interface LLQQUser : LLModelObject
{
    long qqNum;               /*QQ号*/
    int categoryIndex;        /*所属分组的唯一标识*/
    NSString *signature;      /*个性签名*/
    NSString *nickname;       /*昵称*/
    
    
    LLQQUserDetail *userDetail;
}

@property (nonatomic, assign) long qqNum;  
@property (nonatomic, assign) int categoryIndex;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy)  NSString *nickname; 
@property (nonatomic, retain) LLQQUserDetail *userDetail;
@end
