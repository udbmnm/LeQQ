//
//  LLAuthenticodeAlertInputView.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-6.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLAuthenticodeAlertInputView.h"

@implementation LLAuthenticodeAlertInputView

- (id)initWithTitle:(NSString *)title
  authenticodeImage:(UIImage *)img
           delegate:(id /*<UIAlertViewDelegate>*/)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
   otherButtonTitle:(NSString *)otherButtonTitles
{
    
    if ((self = [super initWithTitle:title message:@"\n\n\n\n\n" delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil])) {
                
        _imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(12.0f+15.0f, 52+0.0f, 230.0f, 28*2)] autorelease];  
        [_imageView setImage:img];
        _secretTextField = [self createSecretTextField];
        
        [self addSubview:_imageView];
        [self addSubview:_secretTextField];
        self.center = CGPointMake(160.0f, (460.0f - 216.0f)/2 + 12.0f);

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];        
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
	}
	return self;
}

- (void)orientationDidChange:(NSNotification *)notification {
	//[self setNeedsLayout];
}

- (void)layoutSubviews 
{
	if ([[UIDevice currentDevice] isGeneratingDeviceOrientationNotifications]) {
		if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
			self.center = CGPointMake(160.0f, (460.0f - 216.0f)/2 + 12.0f);
		} else {
			self.center = CGPointMake(240.0f, (300.0f - 162.0f)/2 + 12.0f);
		}
	}
    _aContentView.frame = CGRectMake(12.0f, 51.0f, 260.0f, 28*2);
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_imageView release]; 
    [super dealloc];
}

- (UITextField *)createSecretTextField 
{
	UITextField *secretTextField = nil;
		secretTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0f+15.0f, 52+28*2, 230.0f, 28.0f)];
		secretTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		secretTextField.secureTextEntry = YES;
		secretTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
		secretTextField.placeholder = @"password";
        secretTextField.backgroundColor = [UIColor whiteColor];
        
	return secretTextField;
}

- (void)show
{
    [_secretTextField becomeFirstResponder];
    [super show];
}


- (NSString *)getVerifyCode
{
    return  [_secretTextField text];
}
@end
