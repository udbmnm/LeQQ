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
    long uin;                 /*唯一标识*/
    long qqNum;               /*QQ号*/
    int categoryIndex;        /*所属分组的唯一标识*/
    NSString *status;         /*当前些QQ用户的登录状态(在线、离开..)*/
    UIImage *faceImg;         /*头像*/
    
    NSString *signature;      /*个性签名*/
    NSString *nickname;       /*昵称*/
    int qqLevel;              /*qq等级*/
    int nextLeveRemainDays;   /*距升级还有多少天*/    
    
    LLQQUserDetail *userDetail;
}


@property (nonatomic, assign) long uin;  
@property (nonatomic, assign) long qqNum;  
@property (nonatomic, assign) int categoryIndex;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, retain) UIImage *faceImg; 

@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy)  NSString *nickname; 
@property (nonatomic, assign) int qqLevel;
@property (nonatomic, assign) int nextLeveRemainDays;
@property (nonatomic, retain) LLQQUserDetail *userDetail;
@end
