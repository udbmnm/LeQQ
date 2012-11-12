//
//  LLFMDBHelper.h
//  LeQQ
//
//  Created by Xiangle le on 12-10-25.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLObjectConversionProtocol.h"
/*
 * the protocal LLObjectConversionProtocol provides the infomation about 
 * how to create the database table of this obj 
 *
 * the dictionary's key is the string of member name of 
 * the object, value is the wapper class type of member,
 * such as NSString, NSNumber. 
 */

@interface LLFMDBHelper : NSObject
{
    FMDatabase *_db;
    NSMutableSet *_tableNames;
}
+ (id)shareInstance;
- (BOOL)saveObject:(id<LLObjectConversionProtocol>)obj;
/* the obj must at least have the value of primary key */
- (id)getObjectBy:(id<LLObjectConversionProtocol>)obj;
@end
