//
//  LLGuetGirlsDownloader.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-3.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLGuetGirlsDownloader.h"
#import "LLQQPathManager.h"
#import "ASIHTTPRequest.h"

@implementation LLGuetGirlsDownloader

- (id)init
{
    self = [super init];
    if (self) {
        _queue = [[NSOperationQueue alloc] init];
        [_queue setMaxConcurrentOperationCount:30];

        _count = 0;
    }
    return self;
}

- (void)dealloc
{
    [_queue release];
    [super dealloc];
}

- (void)downloadAllGuetGirls
{
    
    NSString *aUrl = @"http://news.guet.edu.cn/BeautyAPI/image/X93Y.png";
    [self downloadAGirlFromUrl:[NSURL URLWithString:aUrl]];
    // return;
    
    
    static NSString *path = @"http://news.guet.edu.cn/BeautyAPI/image";
    
    char characters[] = "0123456789abcdefghijklmnopqrstuvwxyz";
    
    //for (int i = 0; i < sizeof(characters)/sizeof(char); i++) 
        for (int j = 0; j < sizeof(characters)/sizeof(char); j++) 
            for (int k = 0; k < sizeof(characters)/sizeof(char); k++) {

                for (int l = 0; l < sizeof(characters)/sizeof(char); l++) {
                    
                    //char A = characters[i];
                    char B = characters[j];
                    char C = characters[k];
                    char D = characters[l];
                    NSString *imgFileName = [NSString stringWithFormat:@"%c%c%c%c.png", 
                                             '1' , B, C, D];
                    NSURL *imgUrl = [[NSURL URLWithString:path] URLByAppendingPathComponent:imgFileName];
                    
                    [self downloadAGirlFromUrl:imgUrl];
                }    
                //if ([_queue operationCount] >= 10)
                    //[NSThread sleepForTimeInterval:4];
            }
}

- (void)downloadAGirlFromUrl:(NSURL *)url
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(HTTPRequestError:)];
    [request setDidFinishSelector:@selector(HTTPRequestDone:)];
    [request setQueuePriority:NSOperationQueuePriorityVeryHigh];
    
    [_queue addOperation:request];  
}

- (void)HTTPRequestDone:(ASIHTTPRequest *)request
{
    NSURL *url = [request url];
    NSString *fileName = [url lastPathComponent];
    
    if ([request responseStatusCode] != 404) {
        NSDictionary *dic = [request responseHeaders];
        NSString *type = [dic objectForKey:@"Content-Type"];
        
        if ([type isEqualToString:@"image/png"]) {            
            NSData *data = [request responseData];
            NSString *path = [[LLQQPathManager getPathOfDocuments] 
                              stringByAppendingPathComponent:fileName];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                NSLog(@"[%d/900]get one img <%@>", ++_count, fileName);
                [data writeToFile:path atomically:YES];
                if (_count == 900) {
                    NSLog(@"============== completed [900/900]================");
                    exit(0);
                }                
                
            } else {
                NSLog(@"[%d/900]img already exist <%@>", ++_count, fileName);
            }
            return;
        }
    }

    NSLog(@"[%d/900]NOT valid url: {%@}", _count, url);

}

- (void)HTTPRequestError:(ASIHTTPRequest *)request
{
    NSLog(@"[%d/900]error return %@: {%@}", _count, [request error], [request url]);

}


@end
