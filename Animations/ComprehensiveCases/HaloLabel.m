//
//  HaloLabel.m
//  Animations
//
//  Created by Mac1 on 2018/5/23.
//  Copyright © 2018年 Mac1. All rights reserved.
//

/***************************************光晕扫过文字***************************************/

#import "HaloLabel.h"

@interface UIImage (LabelAdditions)

+ (UIImage *)imageWithView:(UIView *)view;

@end

@implementation UIImage (LEffectLabelAdditions)

//view转image
+ (UIImage *)imageWithView:(UIView *)view {
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是不透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

@implementation HaloLabel

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}


- (void)initialize {
    _textColor = [UIColor whiteColor];
    _haloColor = [UIColor redColor];
    _font = [UIFont systemFontOfSize:15];
    _label = [[UILabel alloc] initWithFrame:self.bounds];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.numberOfLines = 1;
    _label.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.backgroundColor = [[UIColor clearColor] CGColor];
}

- (void)layoutSubviews {
    _textLayer.frame = self.bounds;
}

+ (Class)layerClass {
    return [CAGradientLayer class];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _label.frame = frame;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    _label.font = _font;
    [self updateLabel];
}

- (void)setText:(NSString *)text {
    _text = text;
    _label.text = _text;
    [self updateLabel];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _label.textColor = _textColor;
    [self updateLabel];
}

- (void)updateLabel {
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.colors = [self colorsForStage:0];
    //根据文字调整label的size，然后调整self.frame
//    [_label sizeToFit];
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, _label.frame.size.width, _label.frame.size.height);
    _alphaImage = [[UIImage imageWithView:_label] CGImage];
    _textLayer = [CALayer layer];
    _textLayer.contents = (__bridge id)_alphaImage;
    [self.layer setMask:_textLayer];
    [self setNeedsLayout];
}

- (void)performAnimation {
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.colors = [self colorsForStage:0];
    switch (_direction) {
        case DirectionLeftToRight:
            gradientLayer.startPoint = CGPointMake(0.0, 0.5);
            gradientLayer.endPoint = CGPointMake(1.0, 0.5);
            break;
        case DirectionRightToLeft:
            gradientLayer.startPoint = CGPointMake(1.0, 0.5);
            gradientLayer.endPoint = CGPointMake(0.0, 0.5);
            break;
        case DirectionTopToBottom:
            gradientLayer.startPoint = CGPointMake(0.5, 0.0);
            gradientLayer.endPoint = CGPointMake(0.5, 1.0);
            break;
        case DirectionBottomToTop:
            gradientLayer.startPoint = CGPointMake(0.5, 1.0);
            gradientLayer.endPoint = CGPointMake(0.5, 0.0);
            break;
        case DirectionBottomLeftToTopRight:
            gradientLayer.startPoint = CGPointMake(0.0, 1.0);
            gradientLayer.endPoint = CGPointMake(1.0, 0.0);
            break;
        case DirectionBottomRightToTopLeft:
            gradientLayer.startPoint = CGPointMake(1.0, 1.0);
            gradientLayer.endPoint = CGPointMake(0.0, 0.0);
            break;
        case DirectionTopLeftToBottomRight:
            gradientLayer.startPoint = CGPointMake(0.0, 0.0);
            gradientLayer.endPoint = CGPointMake(1.0, 1.0);
            break;
        case DirectionTopRightToBottomLeft:
            gradientLayer.startPoint = CGPointMake(1.0, 0.0);
            gradientLayer.endPoint = CGPointMake(0.0, 1.0);
            break;
    }
    
    CABasicAnimation *animation0 = [self animationForStage:0];
    CABasicAnimation *animation1 = [self animationForStage:1];
    CABasicAnimation *animation2 = [self animationForStage:2];
    CABasicAnimation *animation3 = [self animationForStage:3];
    CABasicAnimation *animation4 = [self animationForStage:4];
    CABasicAnimation *animation5 = [self animationForStage:5];
    CABasicAnimation *animation6 = [self animationForStage:6];
    CABasicAnimation *animation7 = [self animationForStage:7];
    CABasicAnimation *animation8 = [self animationForStage:8];
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = animation8.beginTime + animation8.duration;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode = kCAFillModeForwards;
    [groupAnimation setAnimations:@[animation0, animation1, animation2, animation3, animation4, animation5, animation6, animation7, animation8]];
    
    [gradientLayer addAnimation:groupAnimation forKey:@"animationOpacity"];
}

- (CABasicAnimation *)animationForStage:(NSUInteger)stage {
    CGFloat duration = 0.3;
    CGFloat inset = 0.1;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    animation.fromValue = [self colorsForStage:stage];
    animation.toValue = [self colorsForStage:stage + 1];
    animation.beginTime = stage * (duration - inset);
    animation.duration = duration;
    animation.repeatCount = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    return animation;
}

- (NSArray *)colorsForStage:(NSUInteger)stage {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:8];
    for (int i = 0; i < 9; i++) {
        [array addObject:stage != 0 && stage == i ? (id)[_haloColor CGColor] : (id)[_textColor CGColor]];
    }
    return [NSArray arrayWithArray:array];
}

@end
