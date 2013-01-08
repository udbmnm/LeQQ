//
//  LLQQUserCell.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-17.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQUserCell.h"

@implementation LLQQUserCell

@synthesize faceImgView, nameLabel, signatureLabel;

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49, 320, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line];
        [line release];

        self.faceImgView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"avatar_default_40_40.gif"]];  
        //self.faceImgView = [[EGOImageView alloc] initWithPlaceholderImage:nil];
        [self.faceImgView setFrame:CGRectMake(10, 5, 40, 40)];
        [self.contentView addSubview:self.faceImgView];

        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 255, 20)];
        [self.nameLabel setBackgroundColor:[UIColor clearColor]];
        self.signatureLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 25, 255, 20)];
        [self.signatureLabel setBackgroundColor:[UIColor clearColor]];
        [self.signatureLabel setFont:[UIFont systemFontOfSize:10]];
        [self.signatureLabel setTextColor:[UIColor brownColor]];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.signatureLabel];
        
    }
    return self;
}
@end
