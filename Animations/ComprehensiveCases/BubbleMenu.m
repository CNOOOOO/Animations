//
//  BubbleMenu.m
//  Animations
//
//  Created by Mac1 on 2018/5/14.
//  Copyright © 2018年 Mac1. All rights reserved.
//

/***************************************气泡按钮***************************************/

#import "BubbleMenu.h"

#define kDefaultAnimationDuration 0.3

@interface BubbleMenu ()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;//点击手势
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;//长按手势
@property (nonatomic, assign) CGRect originFrame;//视图最初的frame
@property (nonatomic, strong) NSMutableArray *buttonContainer;//存储添加的按钮

@end

@implementation BubbleMenu

- (NSMutableArray *)buttonContainer {
    if (!_buttonContainer) {
        _buttonContainer = [NSMutableArray array];
    }
    return _buttonContainer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame expansionDirection:(ExpansionDirection)direction {
    if (self = [super initWithFrame:frame]) {
        [self defaultInit];
        _direction = direction;
    }
    return self;
}

//默认设置
- (void)defaultInit {
    self.originFrame = self.frame;
    _direction = DirectionTop;
    _animationDuration = kDefaultAnimationDuration;
    _buttonSpacing = 20;
    _collapseAfterSelection = YES;
    _animatedHighlighting = YES;
    _defaultAlpha = 1.0;
    _highlightAlpha = 0.5;
    _isCollapsed = YES;
    //单击
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    self.tapGesture.cancelsTouchesInView = NO;//设置手势被识别时触摸事件是否被传送到视图,当值为YES的时候，系统会识别手势，但触摸事件会被取消；为NO的时候，手势识别之后，触摸事件将会被触发
    self.tapGesture.delegate = self;
    [self addGestureRecognizer:self.tapGesture];
    //长按
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    self.longPressGesture.cancelsTouchesInView = NO;
    self.longPressGesture.delegate = self;
    [self addGestureRecognizer:self.longPressGesture];
}

- (void)tapGesture:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint touchLocation = [tap locationOfTouch:0 inView:self];
        if (_collapseAfterSelection && _isCollapsed == NO && CGRectContainsPoint(self.homeButtonView.frame, touchLocation) == false) {
            [self collapseButtons];
        }
    }
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateEnded) {
        CGPoint touchLocation = [longPress locationOfTouch:0 inView:self];
        if (_collapseAfterSelection && _isCollapsed == NO && CGRectContainsPoint(self.homeButtonView.frame, touchLocation) == false) {
            [self collapseButtons];
        }
    }
}

- (void)setDirection:(enum ExpansionDirection)direction {
    _direction = direction;
}

- (void)setAnimationDuration:(float)animationDuration {
    _animationDuration = animationDuration;
}

- (void)setButtonSpacing:(float)buttonSpacing {
    _buttonSpacing = buttonSpacing;
}

- (void)setCollapseAfterSelection:(BOOL)collapseAfterSelection {
    _collapseAfterSelection = collapseAfterSelection;
}

- (void)setAnimatedHighlighting:(BOOL)animatedHighlighting {
    _animatedHighlighting = animatedHighlighting;
}

- (void)setDefaultAlpha:(float)defaultAlpha {
    _defaultAlpha = defaultAlpha;
}

- (void)setHighlightAlpha:(float)highlightAlpha {
    _highlightAlpha = highlightAlpha;
}

- (void)setHomeButtonView:(UIView *)homeButtonView {
    if (_homeButtonView != homeButtonView) {
        _homeButtonView = homeButtonView;
    }
    if (![_homeButtonView isDescendantOfView:self]) {
        if ([homeButtonView isKindOfClass:[UIButton class]]) {
            [(UIButton *)_homeButtonView addTarget:self action:@selector(homeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:_homeButtonView];
    }
}

- (void)homeButtonClicked:(UIButton *)button {
    if (_isCollapsed) {
        [self expandButtons];
    }else {
        [self collapseButtons];
    }
}

- (NSArray *)allButtons {
    return [self.buttonContainer copy];
}

- (void)addButtons:(NSArray *)buttons {
    if (buttons.count == 0) {
        return;
    }
    for (UIButton *button in buttons) {
        [self addButton:button];
    }
    if (self.homeButtonView) {
        [self bringSubviewToFront:self.homeButtonView];
    }
}

- (void)addButton:(UIButton *)button {
    if (!button) {
        return;
    }
    if (![self.buttonContainer containsObject:button]) {
        [self.buttonContainer addObject:button];
        [self addSubview:button];
        button.hidden = YES;
    }
}

//展开
- (void)expandButtons {
    if ([self.delegate respondsToSelector:@selector(bubbleMenuWillExpand:)]) {
        [self.delegate bubbleMenuWillExpand:self];
    }
    [self prepareForButtonExpansion];
    self.userInteractionEnabled = NO;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:self.animationDuration];
    [CATransaction setCompletionBlock:^{
        for (UIButton *button in self.buttonContainer) {
            button.transform = CGAffineTransformIdentity;
        }
        if ([self.delegate respondsToSelector:@selector(bubbleMenuDidExpand:)]) {
            [self.delegate bubbleMenuDidExpand:self];
        }
        self.userInteractionEnabled = YES;
    }];
    
    NSArray *buttonContainer = self.buttonContainer;
    //如果需要上、左方向时，按钮排序和现在相反，开启
//    if (self.direction == DirectionTop || self.direction == DirectionLeft) {
//        buttonContainer = [self reverseOrderFromArray:self.buttonContainer];
//    }
    for (int i = 0; i < buttonContainer.count; i++) {
        int index = (int)buttonContainer.count - (i + 1);
        UIButton *button = [buttonContainer objectAtIndex:index];
        button.hidden = NO;
        //位移
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        CGPoint originPosition = CGPointZero;
        CGPoint finalPosition = CGPointZero;
        switch (self.direction) {
            case DirectionTop:
                originPosition = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height - self.homeButtonView.frame.size.height);
                finalPosition = CGPointMake(self.frame.size.width / 2.0,
                                            self.frame.size.height - self.homeButtonView.frame.size.height - self.buttonSpacing - button.frame.size.height / 2.0
                                            - ((button.frame.size.height + self.buttonSpacing) * index));
                break;
            case DirectionLeft:
                originPosition = CGPointMake(self.frame.size.width - self.homeButtonView.frame.size.width, self.frame.size.height / 2.0);
                finalPosition = CGPointMake(self.frame.size.width - self.homeButtonView.frame.size.width - button.frame.size.width / 2.0 - self.buttonSpacing
                                            - ((button.frame.size.width + self.buttonSpacing) * index),
                                            self.frame.size.height / 2.0);
                break;
            case DirectionBottom:
                originPosition = CGPointMake(self.frame.size.width / 2.0, self.homeButtonView.frame.size.height);
                finalPosition = CGPointMake(self.frame.size.width / 2.0,
                                            self.homeButtonView.frame.size.height + self.buttonSpacing + button.frame.size.height / 2.0
                                            + ((button.frame.size.height + self.buttonSpacing) * index));
                break;
            case DirectionRight:
                originPosition = CGPointMake(self.homeButtonView.frame.size.width, self.frame.size.height / 2.0);
                finalPosition = CGPointMake(self.homeButtonView.frame.size.width + self.buttonSpacing + button.frame.size.width / 2.0
                                            + ((button.frame.size.width + self.buttonSpacing) * index),
                                            self.frame.size.height / 2.0);
                break;
            default:
                break;
        }
        positionAnimation.duration = self.animationDuration;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:originPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:finalPosition];
        positionAnimation.beginTime = CACurrentMediaTime() + (self.animationDuration / (float)buttonContainer.count * (float)i);
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;
        [button.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        button.layer.position = finalPosition;
        //缩放
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = self.animationDuration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:0.1];
        scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.beginTime = CACurrentMediaTime() + (self.animationDuration / (float)buttonContainer.count * (float)i);
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        [button.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        button.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }
    [CATransaction commit];
    _isCollapsed = NO;
}

//展开时重新计算自身的frame
- (void)prepareForButtonExpansion {
    float width = [self combinedButtonsWidth];
    float height = [self combinedButtonsHeight];
    switch (self.direction) {
        case DirectionTop:
            {
                self.homeButtonView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
                CGRect frame = self.frame;
                frame.origin.y -= height;
                frame.size.height += height;
                self.frame = frame;
            }
            break;
        case DirectionLeft:
            {
                self.homeButtonView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                CGRect frame = self.frame;
                frame.origin.x -= width;
                frame.size.width += width;
                self.frame = frame;
            }
            break;
        case DirectionBottom:
            {
                self.homeButtonView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
                CGRect frame = self.frame;
                frame.size.height += height;
                self.frame = frame;
            }
            break;
        case DirectionRight:
            {
                self.homeButtonView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
                CGRect frame = self.frame;
                frame.size.width += width;
                self.frame = frame;
            }
            break;
        default:
            break;
    }
}

//计算所有按钮宽度和间距之和
- (float)combinedButtonsWidth {
    float width = 0;
    for (UIButton *button in self.buttonContainer) {
        width += button.frame.size.width + self.buttonSpacing;
    }
    return width;
}

//计算所有按钮高度和间距之和
- (float)combinedButtonsHeight {
    float height = 0;
    for (UIButton *button in self.buttonContainer) {
        height += button.frame.size.height + self.buttonSpacing;
    }
    return height;
}

//倒序
- (NSArray *)reverseOrderFromArray:(NSArray *)array {
    NSMutableArray *reverseArray = [NSMutableArray array];
    for (int i = (int)array.count - 1; i >= 0; i--) {
        [reverseArray addObject:[array objectAtIndex:i]];
    }
    return reverseArray;
}

//收起
- (void)collapseButtons {
    if ([self.delegate respondsToSelector:@selector(bubbleMenuWillCollapse:)]) {
        [self.delegate bubbleMenuWillCollapse:self];
    }
    self.userInteractionEnabled = NO;
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:self.animationDuration];
    [CATransaction setCompletionBlock:^{
        [self finishCollapse];
        for (UIButton *button in self.buttonContainer) {
            button.transform = CGAffineTransformIdentity;
            button.hidden = YES;
        }
        if ([self.delegate respondsToSelector:@selector(bubbleMenuDidCollapse:)]) {
            [self.delegate bubbleMenuDidCollapse:self];
        }
        self.userInteractionEnabled = YES;
    }];
    
    int index = 0;
    for (int i = (int)self.buttonContainer.count - 1; i >= 0; i--) {
        //如果需要上、左方向时，按钮排序和现在相反，开启
//        UIButton *button = self.buttonContainer[i];
//        if (self.direction == DirectionBottom || self.direction == DirectionRight) {
//            button = self.buttonContainer[index];
//        }
        UIButton *button = self.buttonContainer[index];
        //缩放
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = self.animationDuration;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.f];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.01f];
        scaleAnimation.beginTime = CACurrentMediaTime() + (self.animationDuration/(float)self.buttonContainer.count * (float)index);
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        [button.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        button.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        //位移
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        CGPoint originPosition = button.layer.position;
        CGPoint finalPosition = CGPointZero;
        switch (self.direction) {
            case DirectionTop:
                finalPosition = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height - self.homeButtonView.frame.size.height);
                break;
            case DirectionLeft:
                finalPosition = CGPointMake(self.frame.size.width - self.homeButtonView.frame.size.width, self.frame.size.height/2.0);
                break;
            case DirectionBottom:
                finalPosition = CGPointMake(self.frame.size.width/2.0, self.homeButtonView.frame.size.height);
                break;
            case DirectionRight:
                finalPosition = CGPointMake(self.homeButtonView.frame.size.width, self.frame.size.height/2.0);
                break;
            default:
                break;
        }
        positionAnimation.duration = self.animationDuration;
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:originPosition];
        positionAnimation.toValue = [NSValue valueWithCGPoint:finalPosition];
        positionAnimation.beginTime = CACurrentMediaTime() + (_animationDuration/(float)_buttonContainer.count * (float)index);
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;
        [button.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        button.layer.position = originPosition;
        index++;
    }
    [CATransaction commit];
    _isCollapsed = YES;
}

//收起后改变视图的frame为初始值
- (void)finishCollapse {
    self.frame = self.originFrame;
}

//视图过渡动画
- (void)animateWithBlock:(void (^)(void))animationBlock {
    [UIView transitionWithView:self
                      duration:kDefaultAnimationDuration
                       options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                    animations:animationBlock
                    completion:NULL];
}

//设置homeButtonView点击时高亮
- (void)setTouchHighlighted:(BOOL)highlighted {
    if ([self.homeButtonView isKindOfClass:[UIButton class]]) {
        return;
    }
    float alphaValue = highlighted ? _highlightAlpha : _defaultAlpha;
    if (self.homeButtonView.alpha == alphaValue) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    if (_animatedHighlighting) {
        [weakSelf animateWithBlock:^{
            if (weakSelf.homeButtonView != nil) {
                weakSelf.homeButtonView.alpha = alphaValue;
            }
        }];
    } else {
        if (self.homeButtonView != nil) {
            self.homeButtonView.alpha = alphaValue;
        }
    }
}

- (UIView *)subviewForPoint:(CGPoint)point {
    for (UIView *subview in self.subviews) {
        if (CGRectContainsPoint(subview.frame, point)) {
            return subview;
        }
    }
    return self;
}

#pragma mark Touch Handling Methods
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    if (CGRectContainsPoint(self.homeButtonView.frame, [touch locationInView:self])) {
        [self setTouchHighlighted:YES];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    [self setTouchHighlighted:NO];
    if (CGRectContainsPoint(self.homeButtonView.frame, [touch locationInView:self])) {
        if (_isCollapsed) {
            [self expandButtons];
        } else {
            [self collapseButtons];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self setTouchHighlighted:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    [self setTouchHighlighted:CGRectContainsPoint(self.homeButtonView.frame, [touch locationInView:self])];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        if (_isCollapsed) {
            return self;
        } else {
            return [self subviewForPoint:point];
        }
    }
    return hitView;
}

#pragma mark UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchLocation = [touch locationInView:self];
    if ([self subviewForPoint:touchLocation] != self && _collapseAfterSelection) {
        return YES;
    }
    return NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
