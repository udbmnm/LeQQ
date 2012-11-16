//
//  LLModelObject.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-7.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLObjectConversionProtocol.h"

@protocol LLObjectXMLConversionProtocol 
@optional
- (id)initWithXML:(NSString *)xmlString;
- (id)initWithXMLFile:(NSString *)xmlPath;
- (NSString *)toXML;
@end

@protocol LLObjectJSONConversionProtocol 
@optional
- (id)initWithJSON:(NSString *)jsonString;
- (id)initWithJSONFile:(NSString *)jsonPath;
- (NSString *)toJSON;
@end

@protocol LLObjectSQLiteDBConversionProtocol
@optional
/*
 * search the db for an entry which have the same primary key with self,
 * and create the new one with that record.
 */
- (id)copyFromDB;
- (BOOL)saveToDB;
@end

@interface LLModelObject : NSObject<LLObjectConversionProtocol,
                                    LLObjectXMLConversionProtocol,
                                    LLObjectJSONConversionProtocol,
                                    LLObjectSQLiteDBConversionProtocol>
{
    
    
}
@end
