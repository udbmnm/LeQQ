//
//  LLObjectConversionProtocol.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-7.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//


@protocol LLObjectConversionProtocol <NSObject>
@required
/* required for sqlite database */
- (NSString *)objectClassName;

/* extract object */
- (id)initWithDictionary:(NSDictionary *)dic;
/* 
 * encode object, you can using encription for some properties.
 * the value and the key can all be encription.
 */
- (NSDictionary *)dictionary;

/* required for sqlite database */
- (NSString *)primaryKey;
@end