//
//  LLBomtomCompassMenu.h
//
//  Created by Xiangle le on 12-11-2.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define LLBOMTOMCOMPASSMENU_VIEW_HEIGHT 148.0
#define LLBOMTOMCOMPASSMENU_VIEW_WIDTH  296.0

typedef enum {
    kLLBomtomCompassMenuNULL = 0,
    kLLBomtomCompassMenuCenterBtnTag = 100,
    kLLBomtomCompassMenuInnerBtnTag_1 = 1,
    kLLBomtomCompassMenuInnerBtnTag_2 = 2,
    kLLBomtomCompassMenuInnerBtnTag_3 = 3, 
    kLLBomtomCompassMenuInnerBtnTag_4 = 4,
    kLLBomtomCompassMenuInnerBtnTag_5 = 5,
    kLLBomtomCompassMenuOutterBtnTag_1 = 11,
    kLLBomtomCompassMenuOutterBtnTag_2 = 12,
    kLLBomtomCompassMenuOutterBtnTag_3 = 13,
    kLLBomtomCompassMenuOutterBtnTag_4 = 14,
    kLLBomtomCompassMenuOutterBtnTag_5 = 15,
    kLLBomtomCompassMenuOutterBtnTag_6 = 16,
    kLLBomtomCompassMenuOutterBtnTag_7 = 17
}LLBomtomCompassMenuButtonTag;

@class LLBomtomCompassMenu;
@protocol LLBomtomCompassMenuDelegate <NSObject>

@optional
- (void)LLBomtomCompassMenu:(LLBomtomCompassMenu *)menu outterMenuButtonDidClicked:(LLBomtomCompassMenuButtonTag)innerBtnTag withInnerMenuButton:(LLBomtomCompassMenuButtonTag)innerBtnTag;
- (void)LLBomtomCompassMenu:(LLBomtomCompassMenu *)menu innerMenuButtonDidClicked:(LLBomtomCompassMenuButtonTag)tag;

- (void)LLBomtomCompassMenuWillHide:(LLBomtomCompassMenu *)menu;
- (void)LLBomtomCompassMenuWillShow:(LLBomtomCompassMenu *)menu;
- (void)LLBomtomCompassMenuDidHide:(LLBomtomCompassMenu *)menu;
- (void)LLBomtomCompassMenuDidShow:(LLBomtomCompassMenu *)menu;
- (void)LLBomtomCompassMenuWillShowRotationAnimation:(LLBomtomCompassMenu *)menu;
- (void)LLBomtomCompassMenuWillHideRotationAnimation:(LLBomtomCompassMenu *)menu;
- (void)LLBomtomCompassMenuDidShowRotationAnimation:(LLBomtomCompassMenu *)menu;
- (void)LLBomtomCompassMenuDidHideRotationAnimation:(LLBomtomCompassMenu *)menu;
@end

@interface LLBomtomCompassMenu : UIView
{
    UIView *_rotationView;
    UIImageView *_innerView;
    BOOL _isRotationViewShow;//NO 为不显示状态 
    BOOL _isMenuShow;
    id<LLBomtomCompassMenuDelegate> delegate;
    NSMutableDictionary *_outterImgsForInnerMenuButtons;
    NSMutableDictionary *_outterHighlightedImgsForInnerMenuButtons;
    LLBomtomCompassMenuButtonTag _currentSelectedMenuButtonTag;
    LLBomtomCompassMenuButtonTag _currentSelectedInnerMenuButtonTag;
    CGPoint _origin;
    BOOL _isInAnimation;
}

@property (nonatomic, retain)  id<LLBomtomCompassMenuDelegate> delegate;

- (id)initAboveOfView:(UIView *)view;

- (BOOL)isMenuShow;
- (void)showOrHideMenu;

- (void)addButtonToCenterWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

- (void)addButtonsToFirstRoundWithImages:(NSArray *)images 
                       highlightedImages:(NSArray *)highlightedImages;
- (void)addButtonsToFirstRoundWithImages:(NSArray *)images;
- (void)addButtonsToSecondRoundWithImages:(NSArray *)images 
                        highlightedImages:(NSArray *)highlightedImages 
             bindingToInnerMenuItemByTag:(LLBomtomCompassMenuButtonTag)tag;
- (void)addButtonsToSecondRoundWithImages:(NSArray *)images 
             bindingToInnerMenuItemByTag:(LLBomtomCompassMenuButtonTag)tag;

@end

