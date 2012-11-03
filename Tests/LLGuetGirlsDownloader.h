//
//  LLGuetGirlsDownloader.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-3.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLGuetGirlsDownloader : NSObject
{
    NSOperationQueue *_queue;
    NSUInteger _count;

}

- (void)downloadAllGuetGirls;
@end
