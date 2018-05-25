//
//  BubbleMenu.h
//  Animations
//
//  Created by Mac1 on 2018/5/14.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ExpansionDirection) {//菜单展开的方向
    DirectionTop,
    DirectionLeft,
    DirectionBottom,
    DirectionRight
};

@class BubbleMenu;
@protocol BubbleMenuDelegate <NSObject>

@optional
- (void)bubbleMenuWillExpand:(BubbleMenu *)expandableView;//菜单将要展开
- (void)bubbleMenuDidExpand:(BubbleMenu *)expandableView;//菜单展开完成
- (void)bubbleMenuWillCollapse:(BubbleMenu *)expandableView;//菜单将要收起
- (void)bubbleMenuDidCollapse:(BubbleMenu *)expandableView;//菜单收起完成

@end

@interface BubbleMenu : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<BubbleMenuDelegate> delegate;
@property (nonatomic, assign) enum ExpansionDirection direction;//气泡按钮的方向
@property (nonatomic, strong) UIView *homeButtonView;//菜单按钮
@property (nonatomic, assign) float animationDuration;//动画时长
@property (nonatomic, assign) float buttonSpacing;//按钮间隔
@property (nonatomic, assign) BOOL collapseAfterSelection;//选中button后菜单是否收起
@property (nonatomic, readonly) BOOL isCollapsed;//菜单是否是收起状态
@property (nonatomic, assign) BOOL animatedHighlighting;//homeButtonView点击时是否动态高亮
@property (nonatomic, assign) float defaultAlpha;//homeButtonView默认透明度
@property (nonatomic, assign) float highlightAlpha;//高亮时的透明度
@property (nonatomic, weak, readonly) NSArray *allButtons;//供外界获取视图中所有添加的按钮
- (instancetype)initWithFrame:(CGRect)frame expansionDirection:(ExpansionDirection)direction;//带方向的初始化
- (void)addButtons:(NSArray *)buttons;//添加多个按钮
- (void)addButton:(UIButton *)button;//添加单个按钮
- (void)expandButtons;//展开
- (void)collapseButtons;//收起

@end
