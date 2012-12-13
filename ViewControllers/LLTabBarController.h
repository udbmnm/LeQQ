//
//  RaisedCenterTabBarController.h
//  RaisedCenterTabBar
//
//  Created by Peter Boctor on 12/15/10.
//  modified by Ganxiangle on 2012/11/02
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

@interface LLTabBarController : UITabBarController
{
    NSMutableArray *_viewControllerArray;
}

-(id)init;

-(void)addViewController:(UIViewController*)viewContrller
                tabImage:(UIImage *)image 
                   title:(NSString *)title;


//This method add a comtom button tabbar, overide the 3nd item of the tabbar.
//the button may be round, or any shake you like. click the button is just like
//click the 3nd tabbar item(the delegate method will be called)
//
//The image must large inagh to overide the 3nd tabbar item's view, 
//the items count must be no less than 5
-(void) setCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage;

@end
