//
//  LLQQUserDetail.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLModelObject.h"

typedef enum {
    ConstellationTypeNull  = -1,
    ConstellationTypeAquarius= 0,
    ConstellationTypePisces  = 1,
    ConstellationTypeAries   = 2,
    ConstellationTypeTaurus  = 3,
    ConstellationTypeGemini  = 4,
    ConstellationTypeCancer  = 5,
    ConstellationTypeLeo     = 6,
    ConstellationTypeVirgo   = 7,
    ConstellationTypeLibra   = 8,
    ConstellationTypeScorpio = 9,
    ConstellationTypeSagittarius = 10,
    ConstellationTypeCapricorn   = 11
}LLConstellationType;

typedef enum {
    BloodTypeNull = -1,
    BloodTypeA = 0,
    BloodTypeB = 1, 
    BloodTypeO = 2,
    BloodTypeAB = 3,
    BloodTypeOther = 4
}LLBloodType;

typedef enum {
    AnimalTypeNull = -1,
    AnimalTypeRat = 0,
    AnimalTypeCattle = 1,
    AnimalTypeTiger = 2,
    AnimalTypeHare = 3,
    AnimalTypeDragon = 4,
    AnimalTypeSnake = 5,
    AnimalTypeHorse = 6,
    AnimalTypeSheep = 7,
    AnimalTypeMonkey = 8,
    AnimalTypeCock = 9,
    AnimalTypeDog = 10,
    AnimalTypePig = 11
}LLAnimalType;

typedef enum {
    GenderNull = 0,
    GenderMale = 1,
    GenderFemale = 2
}LLGender;

@interface LLQQUserDetail : LLModelObject
{
    long uin;
    
    NSString *birthDay;             /* 1988-11-06 式的字符串 */
    NSString *occupation;           /* 职业 */
    NSString *phone;      
    int allow;
    NSString *college;              /*大学*/
    long reg_time;                  /*注册时间*/
    LLConstellationType constellation;        /*星座*/
    LLBloodType blood;              /*血型*/
    NSString *homepage;             /*个人主页*/
    int stat;                       
    int vip_info;
    NSString *country;              /*国家*/
    NSString *province;             /*省*/
    NSString *city;                 /*城市*/
    NSString *personal;             /*个人说明*/
    NSString *nickname;             /*昵称*/
    LLAnimalType animal;               /*生肖*/
    NSString *email;                /*邮箱*/
    LLGender gender;                     /*性别,男或女*/
    NSString *mobile;               /*电话*/
    NSString *clientType;          /*optional*/
    
}

@property (nonatomic, assign) long uin;
@property (nonatomic, copy)  NSString *birthDay;
@property (nonatomic, copy)  NSString *occupation; 
@property (nonatomic, copy)  NSString *phone; 
@property (nonatomic, assign) int allow;
@property (nonatomic, copy)  NSString *college; 
@property (nonatomic, assign) long reg_time;
@property (nonatomic, assign)  LLConstellationType constellation; 
@property (nonatomic, assign)  LLBloodType blood; 
@property (nonatomic, copy)  NSString *homepage; 
@property (nonatomic, assign) int stat;
@property (nonatomic, assign) int vip_info;
@property (nonatomic, copy)  NSString *country; 
@property (nonatomic, copy)  NSString *province; 
@property (nonatomic, copy)  NSString *city; 
@property (nonatomic, copy)  NSString *personal; 
@property (nonatomic, copy)  NSString *nickname; 
@property (nonatomic, assign)  LLAnimalType animal; 
@property (nonatomic, copy)  NSString *email; 
@property (nonatomic, assign) LLGender gender;
@property (nonatomic, copy)  NSString *mobile; 
@property (nonatomic, copy)  NSString *clientType; 
@property (nonatomic, assign) int categoryIndex;
@end
