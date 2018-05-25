//
//  HaloLabel.h
//  Animations
//
//  Created by Mac1 on 2018/5/23.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HaloDirection) {//光晕前进方向
    DirectionLeftToRight,
    DirectionRightToLeft,
    DirectionTopToBottom,
    DirectionBottomToTop,
    DirectionTopLeftToBottomRight,
    DirectionBottomRightToTopLeft,
    DirectionBottomLeftToTopRight,
    DirectionTopRightToBottomLeft
};

@interface HaloLabel : UIView {
    UILabel *_label;
    CGImageRef _alphaImage;
    CALayer *_textLayer;
}

@property (nonatomic, copy) NSString *text;//文字
@property (nonatomic, strong) UIFont *font;//字体
@property (nonatomic, strong) UIColor *textColor;//字体颜色
@property (nonatomic, strong) UIColor *haloColor;//光晕颜色
@property (nonatomic, assign) HaloDirection direction;//方向
- (void)performAnimation;//启动动画

@end
