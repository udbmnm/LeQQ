//
//  LLAuthenticodeAlertInputView.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-6.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLAuthenticodeAlertInputView : UIAlertView
{
    UITextField *_secretTextField;
    UIImageView *_imageView;
    UIView *_aContentView;
}

- (id)initWithTitle:(NSString *)title 
  authenticodeImage:(UIImage *)img
           delegate:(id<UIAlertViewDelegate>)delegate 
  cancelButtonTitle:(NSString *)cancelButtonTitle 
   otherButtonTitle:(NSString *)otherButtonTitles;

- (NSString *)getVerifyCode;
@end
