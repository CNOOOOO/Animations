//
//  BloomingButton.h
//  Animations
//
//  Created by Mac1 on 2018/5/24.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BloomingButton;
@protocol BloomingButtonDelegate <NSObject>

- (void)selectedItemWithIndex:(NSInteger)index;

@end

@interface BloomingButton : UIView

@property (nonatomic, strong) UIButton *homeButton;//主按钮
@property (nonatomic, strong) NSArray *itemButtons;//子按钮
@property (nonatomic, assign) float bloomRadius;//展开后的半径
@property (nonatomic, assign) float backgroundAlpha;//背景层的透明度
@property (nonatomic, assign) BOOL isRoundDistribution;//按钮是否是360度圆形分布（默认180度半圆形分布）
@property (nonatomic, weak)   id<BloomingButtonDelegate> delegate;

@end
