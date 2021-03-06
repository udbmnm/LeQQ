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
    unsigned long uin;                 /*唯一标识*/
    unsigned long qqNum;               /*QQ号*/
    long categoryIndex;        /*所属分组的唯一标识*/
    NSString *nickname;       /*昵称，用户设置的名称*/
    NSString *markname;       /*备注名称*/
    
    UIImage *faceImg;         /*头像*/
    long face;                /* ? */
    
    NSString *signature;      /*个性签名*/
    long qqLevel;             /*qq等级*/
    long nextLeveRemainDays;  /*距升级还有多少天*/  
    BOOL isVIP;                 
    long vipLevel;
    
    LLQQUserDetail *userDetail;
}

@property (nonatomic, assign) unsigned long uin;  
@property (nonatomic, assign) unsigned long qqNum;  
@property (nonatomic, assign) long categoryIndex;
@property (nonatomic, copy)  NSString *nickname; 
@property (nonatomic, copy)  NSString *markname; 
@property (nonatomic, retain) UIImage *faceImg; 
@property (nonatomic, assign) long face;

@property (nonatomic, copy) NSString *signature;
@property (nonatomic, assign) long qqLevel;
@property (nonatomic, assign) long nextLeveRemainDays;
@property (nonatomic, assign) BOOL isVIP;   
@property (nonatomic, assign) long vipLevel;

//@property (nonatomic, retain) LLQQUserDetail *userDetail;

-(LLQQUser *)mergedWith:(LLQQUser *)anotherUser;
- (LLQQUserDetail *)userDetail;
- (void)setUserDetail:(LLQQUserDetail *)aUserDetail;

@end
