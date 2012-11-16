//
//  LLCommon.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//


typedef enum {
    kQQUserStatusNull = 0,
    kQQUserStatusOnline = 1
    
}LLQQUserStatusType;

typedef enum 
{
    kQQClientTypeNull = 0,
    kQQClientTypeNormal = 1
    
}LLQQClientType;

typedef enum {
    kConstellationTypeNull  = -1,
    kConstellationTypeAquarius= 0,
    kConstellationTypePisces  = 1,
    kConstellationTypeAries   = 2,
    kConstellationTypeTaurus  = 3,
    kConstellationTypeGemini  = 4,
    kConstellationTypeCancer  = 5,
    kConstellationTypeLeo     = 6,
    kConstellationTypeVirgo   = 7,
    kConstellationTypeLibra   = 8,
    kConstellationTypeScorpio = 9,
    kConstellationTypeSagittarius = 10,
    kConstellationTypeCapricorn   = 11
}LLConstellationType;

typedef enum {
    kBloodTypeNull = -1,
    kBloodTypeA = 0,
    kBloodTypeB = 1, 
    kBloodTypeO = 2,
    kBloodTypeAB = 3,
    kBloodTypeOther = 4
}LLBloodType;

typedef enum {
    kAnimalTypeNull = -1,
    kAnimalTypeRat = 0,
    kAnimalTypeCattle = 1,
    kAnimalTypeTiger = 2,
    kAnimalTypeHare = 3,
    kAnimalTypeDragon = 4,
    kAnimalTypeSnake = 5,
    kAnimalTypeHorse = 6,
    kAnimalTypeSheep = 7,
    kAnimalTypeMonkey = 8,
    kAnimalTypeCock = 9,
    kAnimalTypeDog = 10,
    kAnimalTypePig = 11
}LLAnimalType;

typedef enum {
    kGenderNull = 0,
    kGenderMale = 1,
    kGenderFemale = 2
}LLGender;