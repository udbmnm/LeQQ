//
//  AirTest.m
//  LeQQ
//
//  Created by Xiangle le on 12-10-25.
//  Copyright (c) 2012年 GUET/Wondershare. All rights reserved.
//

#import "AirTest.h"
#import "FMDBHelper.h"
#import "LLDebug.h"

@interface LLWeatherInfo : NSObject<FMDBHelperProtocal, LLObjectPrinter>
{
    NSString *city;
    NSString *date;
    NSString *week;
    int temp1;
    int temp2;
}
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *week;
@property (nonatomic, assign) int temp1;
@property (nonatomic, assign) int temp2;
@end

@implementation LLWeatherInfo
@synthesize city, date, week, temp1, temp2;
- (id)init
{
    if (self = [super init]) {
        city = nil;
        date = nil;
        week = nil;
        temp1 = 0;
        temp2 = 0;
    }
    return self;
}
- (NSDictionary *)dictionaryForFMDB
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dic setObject:city forKey:@"city"];
    [dic setObject:(date == nil? @"":date) forKey:@"date"];
    [dic setObject:(week == nil? @"":week) forKey:@"week"];
    [dic setObject:[NSNumber numberWithInt:temp1] forKey:@"temp1"];
    [dic setObject:[NSNumber numberWithInt:temp2] forKey:@"temp2"];
    return (NSDictionary *)[dic autorelease];
}

- (void)setDictionaryFromFMDB:(NSDictionary *)dic
{
    city = [dic objectForKey:@"city"];
    date = [dic objectForKey:@"date"];
    week = [dic objectForKey:@"week"];
    temp1 = [[dic objectForKey:@"temp1"] intValue];
    temp2 = [[dic objectForKey:@"temp2"] intValue];
}

- (NSString *)tableNameForFMDB 
{
    return @"weatherInfo";
}

- (NSString *)primaryKeyNameForFMDB
{
    return @"city";
}

- (void)printMySelf
{
    NSLog(@"[%@]\ncity: %@\ndate: %@\nweek: %@\ntemp1: %d\ntemp2: %d\n", 
          NSStringFromClass([self class]), city, date, week, temp1, temp2);
}

@end


@implementation AirTest

-(void)doWithWeatherJsonString:(NSString*) json
{    
    NSDictionary *jsonObj = [json JSONValue];
    NSDictionary *weatherInfo = [jsonObj objectForKey:@"weatherinfo"];
    
    LLWeatherInfo *lweatherInfo = [[LLWeatherInfo alloc] init];
    
    NSLog(@"===================================");
    for (NSString *key in [weatherInfo allKeys]) {
        if ([key isEqualToString:@"city"]) {
            lweatherInfo.city = [weatherInfo objectForKey:key];
        } else if ([key isEqualToString:@"date_y"]) {
            lweatherInfo.date = [weatherInfo objectForKey:key];
        } else if ([key isEqualToString:@"week"]) {
            lweatherInfo.week = [weatherInfo objectForKey:key];            
        } else if ([key isEqualToString:@"temp1"]) {
            NSString *temp = [weatherInfo objectForKey:key];
            NSString *temp1 = [temp substringToIndex:2];
            NSString *temp2 = [temp substringWithRange:NSMakeRange(4, 2)];
            lweatherInfo.temp1 = [temp1 intValue];
            lweatherInfo.temp2 = [temp2 intValue];
        } 
        NSLog(@"%@: %@\n", key, [weatherInfo objectForKey:key]); 
    }
    
    [[FMDBHelper shareInstance] saveObject:lweatherInfo];
    lweatherInfo = nil;

    LLWeatherInfo *weatherInfoForQuery = [[LLWeatherInfo alloc] init];
    weatherInfoForQuery.city = @"广州";
    
    LLWeatherInfo *gotWeatherInfo =(LLWeatherInfo*) [[FMDBHelper shareInstance] getObjectBy:weatherInfoForQuery];
    [gotWeatherInfo printMySelf];
    [weatherInfoForQuery release];
     
}

-(void)doWithWeatherXMLString:(NSString*) xml
{
    DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:xml options:DDXMLDocumentXMLKind error:nil];
    DDXMLElement *root = [xmlDoc rootElement];    
    
    NSArray *cities = [root nodesForXPath:@"/china/city" error:nil];
    
    for (DDXMLElement *city in cities) {
        DDXMLNode *cityName = [city attributeForName:@"cityname"];
        DDXMLNode *temp1 = [city attributeForName:@"tem1"];
        DDXMLNode *temp2 = [city attributeForName:@"tem2"];
        DDXMLNode *dateinfo = [city attributeForName:@"stateDetailed"];
        
        LLWeatherInfo *weatherInfo = [[[LLWeatherInfo alloc] init] autorelease];
        weatherInfo.city = [cityName stringValue];
        weatherInfo.temp1 = [[temp1 stringValue] intValue];
        weatherInfo.temp2 = [[temp2 stringValue] intValue];
        weatherInfo.date = [dateinfo stringValue];
        [weatherInfo printMySelf];
        [[FMDBHelper shareInstance] saveObject:weatherInfo];
    }
}

- (void)airInfoGettingWithJsonTest
{
    static NSString *GZAirInfoURL = @"http://m.weather.com.cn/data/101280101.html";
    NSURL *url = [[[NSURL alloc] initWithString:GZAirInfoURL] autorelease];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *result = [request responseString];
        [self doWithWeatherJsonString:result];        
    } else {
        NSLog(@"ERROR: %@", error);
    }
}

- (void)airInfoGettingWithXMLTest
{
    static NSString *ChinaWeatherInfoURL = @"http://flash.weather.com.cn/wmaps/xml/china.xml";
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:ChinaWeatherInfoURL]];    
    [request setCompletionBlock:^(void){
        NSString *xmlContent = [request responseString];
        [self doWithWeatherXMLString:xmlContent];
    }];
    
    [request setFailedBlock:^(void){
        NSLog(@"ERROR: %@", [request error]);
    }];
    
    [request startAsynchronous];
}
@end
