//
//  FMDBHelper.m
//  LeQQ
//
//  Created by Xiangle le on 12-10-25.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "FMDBHelper.h"

static NSString *DBNAME = @"happy.db";

@implementation FMDBHelper
+ (id)shareInstance
{
    static FMDBHelper *instance = nil;
    if (instance == nil) {
        instance = [[FMDBHelper alloc] init];
    }
    return instance;
}

- (id)init
{
    if ((self = [super init]) != nil) {
        _db = nil;
        _tableNames = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (_db) {
        [_db close];
        [_db release];
    }
    [_tableNames release];
    [super dealloc];
}
/*
 * return the full path of the SQLite database file
 */
- (NSString *)getDatabasePath
{
    NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                        NSUserDomainMask, YES);
    NSString *dir = [dirs objectAtIndex:0];
    NSString *dbPath = [dir stringByAppendingPathComponent:DBNAME]; 
    return dbPath;
}

/*
 * open the database
 */
- (BOOL)openDB
{
    /* open the database file */
    if (_db == nil) {
        NSString *dbPath = [self getDatabasePath];
        _db = [[FMDatabase databaseWithPath: dbPath] retain];
        if (NO == [_db open]) {
            NSLog(@"Could not open db.");
            return NO;
        }
        /* cache all table names */
        FMResultSet *rs = [_db executeQuery:@"SELECT name FROM sqlite_master where type='table'"];
        if ([rs next]) {
            NSString *tableName = [rs stringForColumnIndex:0];
            [_tableNames addObject:tableName];
        }        
    } else {
        if ([_db open] == NO) {
            [_db release];
            _db = nil;
            return NO;
        }
    }
    return YES;
}

/*
 * return the SQLite type, which is used to store the object
 * in OBJC with type of NSString/NSNumber.
 */
- (NSString *)sqliteTypeOfObject:(id)obj
{
    NSString *type = nil;
    if ([obj isKindOfClass:[NSString class]]) {
        type = @"TEXT";
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        if (strcmp([(NSNumber*)obj objCType], @encode(BOOL)) == 0) {
            type = @"INTEGER";
        }
        else if (strcmp([(NSNumber*)obj objCType], @encode(int)) == 0) {
            type = @"INTEGER";
        }
        else if (strcmp([(NSNumber*)obj objCType], @encode(long)) == 0) {
            type = @"INTEGER";
        }
        else if (strcmp([(NSNumber*)obj objCType], @encode(long long)) == 0) {
            type = @"INTEGER";
        }
        else if (strcmp([(NSNumber*)obj objCType], @encode(unsigned long long)) == 0) {
            type = @"INTEGER";
        }
        else if (strcmp([(NSNumber*)obj objCType], @encode(float)) == 0) {
            type = @"REAL";
        }
        else if (strcmp([(NSNumber*)obj objCType], @encode(double)) == 0) {
            type = @"REAL";
        }                
    } else if([obj isKindOfClass:[NSNull class]]) {
        type = @"TEXT";
    }
    
    return type;
}

- (BOOL)saveObject:(id<FMDBHelperProtocal>)obj
{
    NSDictionary *objDic = [obj dictionaryForFMDB];
    if (objDic == nil) { return NO; }
    
    if (NO == [self openDB]) {
        NSLog(@"ERROR:can not open the db");
        return NO;
    }
    
    NSDictionary *dic = [obj dictionaryForFMDB];
    
    /* create the table if it's NOT exist */
    if ([_tableNames containsObject:[obj tableNameForFMDB]] == NO) {
        
        NSString *sqlTableMembers = @"";
        
        for (NSString *key in [dic allKeys]) {
            
            NSObject *value = [dic objectForKey:key];            
            
            if (![sqlTableMembers isEqualToString:@""]) {
                sqlTableMembers = [sqlTableMembers stringByAppendingString:@","];
            }            
            
            sqlTableMembers = [sqlTableMembers stringByAppendingFormat:@"%@ %@ ", key, [self sqliteTypeOfObject:value]];
            if (key == [obj primaryKeyNameForFMDB]) {
                sqlTableMembers = [sqlTableMembers stringByAppendingString:@"PRIMARY KEY  NOT NULL "];
            }
        }
        NSString *sqlCreateTable = [NSString stringWithFormat:@"CREATE TABLE %@(%@)", [obj tableNameForFMDB], sqlTableMembers]; 
        [_db executeUpdate:sqlCreateTable];
           
        if ([_db hadError] == YES) {
            NSError *error = [_db lastError];
            NSLog(@"ERROR:%@", error);
            [_db close];
            return NO;
        }
        [_tableNames addObject:[obj tableNameForFMDB]];
    }
    
    /* check if the row is already exists */
    /* In the sqlite lib, the '?' is NOT for table name, or attr name, 
       but for values, that is say, it stands for value, not for key */
    FMResultSet *rs = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@=?", 
                                         [obj tableNameForFMDB],
                                         [obj primaryKeyNameForFMDB]], 
                       [dic objectForKey:[obj primaryKeyNameForFMDB]]];
    if ([_db hadError] == YES) {
        NSLog(@"ERROR: %@",  [_db lastError]);
        [_db close];
        return NO;
    }
    
    /* delete the row */
    if ([rs next]) { 
        [_db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=?",
                            [obj tableNameForFMDB],
                            [obj primaryKeyNameForFMDB]], 
         [dic objectForKey:[obj primaryKeyNameForFMDB]]];
        if ([_db hadError]) {
            NSLog(@"ERROR:%@", [_db lastError]);
            _db = nil;
            [_db close];
            return NO;
        }
    }
    
    /* insert the row */
    NSArray *keys = [dic allKeys];
    NSMutableArray *values = [[[NSMutableArray alloc] initWithCapacity:[keys count]] autorelease];
    for (NSString *key in keys) {
        [values addObject:@"?"];
    }
    NSString *sqlInsert = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@) ",[obj tableNameForFMDB], [keys componentsJoinedByString:@","], [values componentsJoinedByString:@","]];
    [_db executeUpdate:sqlInsert withArgumentsInArray:[dic allValues]];
    
    if ([_db hadError] == YES) {
        NSLog(@"ERROR: %@", [_db lastErrorMessage]);
        [_db close];
        return NO;
    }
    
    [_db close];
    return YES;
}

- (id)getObjectBy:(id<FMDBHelperProtocal>)obj
{
    NSString *primaryKey = [obj primaryKeyNameForFMDB];
    NSDictionary *dic = [obj dictionaryForFMDB];
    Class ClassForObj = [obj class];

    
    if ([self openDB] == NO) {
        return nil;
    }
    
    if (![_tableNames containsObject:[obj tableNameForFMDB]]) {
        [_db close];
        return nil;
    }
    
    FMResultSet *rs = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@=?", 
                                            [obj tableNameForFMDB], primaryKey ], 
                                         [dic objectForKey:primaryKey]];
    if ([_db hadError] == YES) {
        NSLog(@"ERROR: %@",  [_db lastError]);
        [_db close];
        return nil;
    }
    
    id newObj = [[[ClassForObj alloc] init] autorelease];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if ([rs next]) {
        for (NSString *key in [dic allKeys]) {
            NSObject *value = [rs objectForColumnName:key];
            [newDic setValue:value forKey:key];
        }
        [newObj setDictionaryFromFMDB:newDic];
        [_db close];
        return newObj;
    } 
    
    [_db close];
    return nil;
}

@end