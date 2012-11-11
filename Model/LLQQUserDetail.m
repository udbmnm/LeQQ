//
//  LLQQUserDetail.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQUserDetail.h"

@implementation LLQQUserDetail
@synthesize uin, allow, nickname, categoryIndex, city, stat, blood, email, phone, animal, gender, mobile, college,
country, birthDay, homepage, personal,province,reg_time,vip_info,clientType,occupation,constellation;

- (id)init
{
    if (self = [super init]) {
        uin = 0;
        birthDay = nil;
        occupation = nil;
        phone = nil;
        allow = -1;
        college = nil;
        reg_time = 0;       
        constellation = nil;
        blood = nil;
        homepage = nil;
        stat = -1;
        vip_info = -1;
        country = nil;
        province = nil;             /*省*/
        city = nil;                 /*城市*/
        personal = nil;             /*个人说明*/
        nickname = nil;             /*昵称*/
        animal = nil;               /*生肖*/
        email = nil;                /*邮箱*/
        gender = -1;                /*性别,男或女*/
        mobile = nil;               /*电话*/
        clientType = nil;           /*optional*/

    }
    
    return self;
}

- (void)dealloc
{
    self.birthDay = nil;
    self.occupation = nil;
    self.phone = nil;
    self.college = nil;
    self.constellation = nil;
    self.blood = nil;
    self.homepage = nil;
    self.country = nil;
    self.province = nil;
    self.city = nil;
    self.personal = nil;
    self.nickname = nil;
    self.animal = nil;
    self.email = nil;
    self.mobile = nil;
    self.clientType = nil;
    [super dealloc];
}

@end
