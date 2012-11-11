//
//  LLQQUserDetail.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLModelObject.h"

@interface LLQQUserDetail : LLModelObject
{
    NSString *birthDay;             /* 1988-11-06 式的字符串 */
    NSString *occupation;           /* 职业 */
    NSString *phone;      
    int allow;
    NSString *college;              /*大学*/
    long reg_time;                  /*注册时间*/
    NSString *constellation;        /*星座*/
    NSString *blood;                /*血型*/
    NSString *homepage;             /*个人主页*/
    int stat;                       
    int vip_info;
    NSString *country;              /*国家*/
    NSString *province;             /*省*/
    NSString *city;                 /*城市*/
    NSString *personal;             /*个人说明*/
    NSString *nickname;             /*昵称*/
    NSString *animal;               /*生肖*/
    NSString *email;                /*邮箱*/
    int gender;                     /*性别,男或女*/
    NSString *mobile;               /*电话*/
    NSString *clientType;          /*optional*/
    
}

@property (nonatomic, copy)  NSString *birthDay;
@property (nonatomic, copy)  NSString *occupation; 
@property (nonatomic, copy)  NSString *phone; 
@property (nonatomic, assign) int allow;
@property (nonatomic, copy)  NSString *college; 
@property (nonatomic, assign) long reg_time;
@property (nonatomic, copy)  NSString *constellation; 
@property (nonatomic, copy)  NSString *blood; 
@property (nonatomic, copy)  NSString *homepage; 
@property (nonatomic, assign) int stat;
@property (nonatomic, assign) int vip_info;
@property (nonatomic, copy)  NSString *country; 
@property (nonatomic, copy)  NSString *province; 
@property (nonatomic, copy)  NSString *city; 
@property (nonatomic, copy)  NSString *personal; 
@property (nonatomic, copy)  NSString *nickname; 
@property (nonatomic, copy)  NSString *animal; 
@property (nonatomic, copy)  NSString *email; 
@property (nonatomic, assign) int gender;
@property (nonatomic, copy)  NSString *mobile; 
@property (nonatomic, copy)  NSString *clientType; 
@property (nonatomic, assign) int categoryIndex;
@end
