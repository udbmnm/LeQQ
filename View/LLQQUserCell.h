//
//  LLQQUserCell.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-17.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "SDSubCell.h"

@interface LLQQUserCell : SDSubCell
{
    EGOImageView *faceImgView;
    UILabel *nameLabel;
    UILabel *signatureLabel;
}

@property (nonatomic, assign) IBOutlet EGOImageView *faceImgView;
@property (nonatomic, assign) IBOutlet UILabel *nameLabel;
@property (nonatomic, assign) IBOutlet UILabel *signatureLabel;
@end
