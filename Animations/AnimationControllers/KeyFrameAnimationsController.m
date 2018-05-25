//
//  KeyFrameAnimationsController.m
//  Animations
//
//  Created by Mac1 on 2018/5/11.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "KeyFrameAnimationsController.h"

@interface KeyFrameAnimationsController ()<CAAnimationDelegate>
@property (nonatomic, strong) UIView *operateView;//操作视图
@property (nonatomic, strong) NSArray *buttonTitles;//按钮标题

@end

@implementation KeyFrameAnimationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关键帧动画";
    self.buttonTitles = @[@"关键帧",@"路径",@"抖动"];
    //添加被操作的视图
    self.operateView = [[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH * 0.5 - 50, VIEW_HEIGHT * 0.5 - 50, 100, 100)];
    self.operateView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.operateView];
    [self addOperateButtons];
}

//添加点击按钮
- (void)addOperateButtons {
    UIButton *preButton;
    for (int i = 0; i < self.buttonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1000 + i;
        [button setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor blackColor];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        if (!preButton) {
            button.frame = CGRectMake(15, 15, 60, 35);
        }else {
            CGFloat originX;
            CGFloat originY;
            if (VIEW_WIDTH - CGRectGetMaxX(preButton.frame) - 30 < 60) {
                originX = 15;
                originY = CGRectGetMaxY(preButton.frame) + 15;
            }else {
                originX = CGRectGetMaxX(preButton.frame) + 15;
                originY = preButton.frame.origin.y;
            }
            button.frame = CGRectMake(originX, originY, 60, 35);
        }
        preButton = button;
        preButton.frame = button.frame;
    }
}

//点击按钮事件
- (void)buttonClicked:(UIButton *)sender {
    if (sender.tag == 1000) {
        //关键帧动画
        CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        NSValue *value1 = [NSValue valueWithCGPoint:CGPointMake(VIEW_WIDTH * 0.5, 50)];
        NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(50, VIEW_HEIGHT * 0.5)];
        NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(VIEW_WIDTH*0.5, VIEW_HEIGHT - 50)];
        NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(VIEW_WIDTH - 50, VIEW_HEIGHT * 0.5)];
        NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(VIEW_WIDTH*0.5, VIEW_HEIGHT * 0.5)];
        keyFrameAnimation.values = [NSArray arrayWithObjects:value1,value2,value3,value4,value5, nil];
        keyFrameAnimation.duration = 2;
        /**
         kCAMediaTimingFunctionLinear 线性动画
         kCAMediaTimingFunctionEaseIn 先慢后快（慢进快出）
         kCAMediaTimingFunctionEaseOut 先块后慢（快进慢出）
         kCAMediaTimingFunctionEaseInEaseOut 先慢后快再慢
         kCAMediaTimingFunctionDefault 默认，也属于中间比较快
         */
        keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        keyFrameAnimation.delegate = self;
        [self.operateView.layer addAnimation:keyFrameAnimation forKey:@"keyFrameAnimation"];
    }else if (sender.tag == 1001) {
        //路劲动画
        CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(VIEW_WIDTH * 0.5 - 100, 100, 200, 200)];
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(50, 100, VIEW_WIDTH - 100, VIEW_HEIGHT - 150)];
        keyFrameAnimation.path = path.CGPath;
        keyFrameAnimation.duration = 2;
        [self.operateView.layer addAnimation:keyFrameAnimation forKey:@"pathAnimation"];
    }else {
        //抖动
        CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];//在这里@"transform.rotation"==@"transform.rotation.z"
        NSValue *value1 = [NSNumber numberWithFloat:-M_PI / 180 * 4];
        NSValue *value2 = [NSNumber numberWithFloat:M_PI / 180 * 4];
        NSValue *value3 = [NSNumber numberWithFloat:-M_PI / 180 * 4];
        keyFrameAnimation.values = @[value1,value2,value3];
        keyFrameAnimation.repeatCount = 10;
        [self.operateView.layer addAnimation:keyFrameAnimation forKey:@"shakeAnimation"];
    }
}

- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"动画开始");
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"动画停止");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
