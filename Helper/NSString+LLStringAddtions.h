//
//  NSString+LLStringAddtions.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-13.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LLStringAddtions)

- (NSString *)stringByReplacingOccurrencesOfKeysWithValues:(NSDictionary *)keysAndValues;
@end
