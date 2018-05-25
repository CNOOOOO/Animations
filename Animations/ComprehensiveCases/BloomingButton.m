//
//  BloomingButton.m
//  Animations
//
//  Created by Mac1 on 2018/5/24.
//  Copyright © 2018年 Mac1. All rights reserved.
//

/**********************************360度或180度展开按钮*********************************/

#import "BloomingButton.h"

@interface BloomingButton ()

@property (nonatomic, strong) UIView *backgroundView;//背景
@property (nonatomic, assign) BOOL isBloom;//是否展开

@end

@implementation BloomingButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView {
    _isRoundDistribution = NO;
    _backgroundAlpha = 0.0;
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backgroundView.backgroundColor = [UIColor blackColor];
    self.backgroundView.alpha = 0.0;
    [self addSubview:self.backgroundView];
}

- (void)setHomeButton:(UIButton *)homeButton {
    _homeButton = homeButton;
    [_homeButton addTarget:self action:@selector(homeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_homeButton];
}

- (void)setItemButtons:(NSArray *)itemButtons {
    _itemButtons = itemButtons;
}

- (void)setBloomRadius:(float)bloomRadius {
    _bloomRadius = bloomRadius;
}

- (void)setBackgroundAlpha:(float)backgroundAlpha {
    _backgroundAlpha = backgroundAlpha;
    self.backgroundView.alpha = _backgroundAlpha;
}

- (void)setIsRoundDistribution:(BOOL)isRoundDistribution {
    _isRoundDistribution = isRoundDistribution;
}

//主按钮点击事件
- (void)homeButtonClicked:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        [self bloomItems];
    }else {
        [self foldItems];
    }
}

//展开按钮
- (void)bloomItems {
    //homeButton和backgroundView的操作
    [self insertSubview:self.backgroundView belowSubview:self.homeButton];
    [UIView animateWithDuration:0.35
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         if (self.backgroundAlpha) {
                             self.backgroundView.alpha = _backgroundAlpha;
                         }else {
                             self.backgroundView.alpha = 0.3;
                         }
                     }
                     completion:nil];

    [UIView animateWithDuration:0.15f
                     animations:^{
                         _homeButton.transform = CGAffineTransformMakeRotation(-0.75f * M_PI);
                     }];
    //展开操作
    for (int i = 1; i <= self.itemButtons.count; i++) {
        UIButton *itemButton = self.itemButtons[i - 1];
        itemButton.tag = i - 1;
        itemButton.transform = CGAffineTransformMakeTranslation(1, 1);
        itemButton.alpha = 1.0f;
        [itemButton addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        itemButton.center = self.homeButton.center;
        CGFloat currentAngle = i * M_PI / (self.itemButtons.count + 1);
        [self insertSubview:itemButton belowSubview:self.homeButton];
        
        if (_isRoundDistribution) {
            CGFloat averageAngle = 360 / self.itemButtons.count * M_PI / 180;
            CGPoint toPoint = [self calculateRoundItemBloomingPoingWithRadius:self.bloomRadius angle:averageAngle * (i - 1)];
            CAAnimationGroup *bloomAnimation = [self bloomAnimationWithToPoint:toPoint];
            [itemButton.layer addAnimation:bloomAnimation forKey:@"bloomAnimation"];
            itemButton.center = toPoint;
        }else {
            CGPoint toPoint = [self calculateSemicircleItemBloomingPointWithRadius:self.bloomRadius angle:currentAngle];
            CAAnimationGroup *bloomAnimation = [self bloomAnimationWithToPoint:toPoint];
            [itemButton.layer addAnimation:bloomAnimation forKey:@"bloomAnimation"];
            itemButton.center = toPoint;
        }
    }
    self.isBloom = YES;
}

//展开动画
- (CAAnimationGroup *)bloomAnimationWithToPoint:(CGPoint)toPoint {
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@0.0,@1.0];
    scaleAnimation.duration = 0.35f;
    
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@(0.0), @(- M_PI), @(- M_PI * 2)];//旋转角度控制
    rotationAnimation.duration = 0.35f;
    rotationAnimation.keyTimes = @[@(0.0), @(0.5), @(1.0)];//每一个旋转角度对应的时间比例

    CAKeyframeAnimation *movingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.homeButton.center.x, self.homeButton.center.y);
    CGPathAddLineToPoint(path, NULL, toPoint.x, toPoint.y);
    CGPathAddLineToPoint(path, NULL, toPoint.x, toPoint.y);//添加两个同样的点是为了控制按钮到达终点后看得到旋转
    movingAnimation.path = path;
    movingAnimation.keyTimes = @[@(0.0), @(0.5), @(1.0)];//移动到每个点的时间比例
    movingAnimation.duration = 0.35f;
    CGPathRelease(path);

    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[scaleAnimation, movingAnimation, rotationAnimation];
    animations.duration = 0.35f;
    return animations;
}

- (void)itemButtonClicked:(UIButton *)button {
    button.selected = YES;
    if ([self.delegate respondsToSelector:@selector(selectedItemWithIndex:)]) {
        [self.delegate selectedItemWithIndex:button.tag];
    }
    self.homeButton.selected = !self.homeButton.selected;
    [self foldItems];
}

//收起按钮
- (void)foldItems {
    for (int i = 1; i <= self.itemButtons.count; i++) {
        UIButton *itemButton = self.itemButtons[i - 1];
        CAAnimationGroup *foldAnimation = [self foldAnimationFromPoint:itemButton.center];
        [itemButton.layer addAnimation:foldAnimation forKey:@"foldAnimation"];
        itemButton.center = self.homeButton.center;
    }
    [self bringSubviewToFront:self.homeButton];
    //homeButton和backgroundView的操作
    [UIView animateWithDuration:0.15
                          delay:0.15
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _homeButton.transform = CGAffineTransformMakeRotation(0);
                     }
                     completion:nil];
    
    [UIView animateWithDuration:0.35f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _backgroundView.alpha = 0.0f;
                     }
                     completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (UIButton *itemButton in self.itemButtons) {
            [itemButton performSelector:@selector(removeFromSuperview)];
        }
        [self.backgroundView removeFromSuperview];
    });
    self.isBloom = NO;
}

//收起动画
- (CAAnimationGroup *)foldAnimationFromPoint:(CGPoint)fromPoint {
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.values = @[@1.0, @1.0, @0.0];
    scaleAnimation.duration = 0.35f;
    scaleAnimation.keyTimes = @[@0.0, @0.75, @1.0];
    
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@(0), @(M_PI), @(M_PI * 2)];
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.duration = 0.35f;
    
    CAKeyframeAnimation *movingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, fromPoint.x, fromPoint.y);
    CGPathAddLineToPoint(path, NULL, fromPoint.x, fromPoint.y);
    CGPathAddLineToPoint(path, NULL, self.homeButton.center.x, self.homeButton.center.y);
    movingAnimation.keyTimes = @[@(0.0f), @(0.75), @(1.0)];//先在原位置停留一会再移动
    movingAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[scaleAnimation, rotationAnimation, movingAnimation];
    animations.duration = 0.35f;
    animations.removedOnCompletion = NO;
    return animations;
}

//计算展开后各item的中心位置(半圆形的情况)
- (CGPoint)calculateSemicircleItemBloomingPointWithRadius:(CGFloat)radius angle:(CGFloat)angle {
    return CGPointMake(self.homeButton.center.x - cosf(angle) * radius,
                       self.homeButton.center.y - sinf(angle) * radius);
}

- (CGPoint)calculateRoundItemBloomingPoingWithRadius:(CGFloat)radius angle:(CGFloat)angle {
    CGPoint firstPoint = CGPointMake(self.homeButton.center.x, self.homeButton.center.y - radius);
    if (self.homeButton.center.x == 0 && self.homeButton.center.y == 0) {//当self.homeButton的中心点处于原点（0,0）时
        return CGPointMake(firstPoint.x*cosf(angle) - firstPoint.y*sinf(angle),
                           firstPoint.x*sinf(angle) + firstPoint.y*cosf(angle));
    }else {//若self.homeButton的中心点不是原点，则可先将firstPoint点坐标转换为相对坐标计算，计算结果再加上self.homeButton中心点的坐标
        return CGPointMake((firstPoint.x - self.homeButton.center.x)*cosf(angle)-(firstPoint.y-self.homeButton.center.y)*sinf(angle) + self.homeButton.center.x, (firstPoint.x-self.homeButton.center.x)*sinf(angle) + (firstPoint.y-self.homeButton.center.y)*cosf(angle) + self.homeButton.center.y);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.homeButton.selected = !self.homeButton.selected;
    [self foldItems];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
