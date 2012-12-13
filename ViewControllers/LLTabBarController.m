    //
//  BaseViewController.m
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//
// Copyright (c) 2011 Peter Boctor
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE
//

#import "LLTabBarController.h"

@implementation LLTabBarController

- (id)init
{
    if (self = [super init]) {
        _viewControllerArray = [[NSMutableArray alloc] init];
        [self.tabBar setTintColor:[UIColor grayColor]];
        
    }
    return self;
}

- (void)dealloc
{
    [_viewControllerArray release];
    [super dealloc];
}

-(void)addViewController:(UIViewController *)viewContrller 
                tabImage:(UIImage *)image title:(NSString *)title
{

    viewContrller.tabBarItem = [[[UITabBarItem alloc] initWithTitle:title 
                                                              image:image tag:0] autorelease];

    [_viewControllerArray addObject:viewContrller];
    [super setViewControllers:_viewControllerArray];
}

-(void)setViewControllers:(NSArray *)viewControllers
{
    [_viewControllerArray release];
    _viewControllerArray = [[NSMutableArray alloc] initWithArray:[viewControllers retain]];
    [super setViewControllers:viewControllers];
}

// Create a custom UIButton and put it to the center of our tab bar, upper than the tab bar
-(void) setCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    if (_viewControllerArray.count >= 3) {
        [[_viewControllerArray objectAtIndex:2] setTabBarItem:nil];
    }    
    
  UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
  button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
  [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
  [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];

  CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
  if (heightDifference < 0)
    button.center = self.tabBar.center;
  else
  {
    CGPoint center = self.tabBar.center;
    center.y = center.y - heightDifference/2.0;
    button.center = center;
  }
  
    [button addTarget:self action:@selector(centerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];  
    
  [self.view addSubview:button];
}

- (void)centerButtonClicked:(id)sender
{
    //self.selectedIndex = 2;

    if (self.delegate && 
        [self.delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) 
    {
        if (_viewControllerArray.count > 2) {
            [self.delegate tabBarController:self didSelectViewController:[_viewControllerArray objectAtIndex:2]];
        }
    }
}

@end
