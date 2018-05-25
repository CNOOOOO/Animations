//
//  GroupAnimationsController.m
//  Animations
//
//  Created by Mac1 on 2018/5/14.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "GroupAnimationsController.h"

@interface GroupAnimationsController ()

@property (nonatomic, strong) UIView *operateView;//操作视图
@property (nonatomic, strong) NSArray *buttonTitles;//按钮标题

@end

@implementation GroupAnimationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"组动画";
    self.buttonTitles = @[@"同时",@"连续"];
    //添加被操作的视图
    self.operateView = [[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH * 0.5 - 25, VIEW_HEIGHT * 0.5 - 25, 50, 50)];
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
        //同时执行
        CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        NSValue *value1 = [NSValue valueWithCGPoint:self.operateView.center];
        NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(25, self.operateView.center.y)];
        NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(25, VIEW_HEIGHT - 25)];
        NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(VIEW_WIDTH - 25, VIEW_HEIGHT - 25)];
        NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(VIEW_WIDTH - 25, self.operateView.center.y)];
        NSValue *value6 = [NSValue valueWithCGPoint:self.operateView.center];
        keyframeAnimation.values = [NSArray arrayWithObjects:value1,value2,value3,value4,value5,value6, nil];

        CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        basicAnimation1.fromValue = [NSNumber numberWithFloat:1.0];
        basicAnimation1.toValue = [NSNumber numberWithFloat:2.0];

        CABasicAnimation *basicAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        basicAnimation2.toValue = [NSNumber numberWithFloat:M_PI * 4];

        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.animations = [NSArray arrayWithObjects:keyframeAnimation,basicAnimation1,basicAnimation2, nil];
        groupAnimation.duration = 3;
        [self.operateView.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
        
        //不把三个动画封装成group，把他们都直接添加到layer上，也有组合动画的效果
//        CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//        NSValue *value1 = [NSValue valueWithCGPoint:self.operateView.center];
//        NSValue *value2 = [NSValue valueWithCGPoint:CGPointMake(25, self.operateView.center.y)];
//        NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(25, VIEW_HEIGHT - 25)];
//        NSValue *value4 = [NSValue valueWithCGPoint:CGPointMake(VIEW_WIDTH - 25, VIEW_HEIGHT - 25)];
//        NSValue *value5 = [NSValue valueWithCGPoint:CGPointMake(VIEW_WIDTH - 25, self.operateView.center.y)];
//        NSValue *value6 = [NSValue valueWithCGPoint:self.operateView.center];
//        keyframeAnimation.values = [NSArray arrayWithObjects:value1,value2,value3,value4,value5,value6, nil];
//        keyframeAnimation.duration = 3;
//        [self.operateView.layer addAnimation:keyframeAnimation forKey:@"keyframeAnimation"];
//
//        CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        basicAnimation1.fromValue = [NSNumber numberWithFloat:1.0];
//        basicAnimation1.toValue = [NSNumber numberWithFloat:2.0];
//        basicAnimation1.duration = 3;
//        [self.operateView.layer addAnimation:basicAnimation1 forKey:@"scaleAnimation"];
//
//        CABasicAnimation *basicAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//        basicAnimation2.toValue = [NSNumber numberWithFloat:M_PI * 4];
//        basicAnimation2.duration = 3;
//        [self.operateView.layer addAnimation:basicAnimation2 forKey:@"rotationAnimation"];
    }else {
        //依次连续执行,主要通过animation的beginTime来控制
        CFTimeInterval currentTime = CACurrentMediaTime();
        //位移
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        positionAnimation.fromValue = [NSValue valueWithCGPoint:self.operateView.center];
        positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.operateView.center.x, VIEW_HEIGHT - 50)];
        positionAnimation.beginTime = currentTime;
        positionAnimation.duration = 1;
        positionAnimation.fillMode = kCAFillModeForwards;
        positionAnimation.removedOnCompletion = NO;
        [self.operateView.layer addAnimation:positionAnimation forKey:@"positionAnimation"];
        
        //缩放
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:2.0];
        scaleAnimation.beginTime = currentTime + 1.0;
        scaleAnimation.duration = 1;
        scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.removedOnCompletion = NO;
        [self.operateView.layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
        
        //旋转
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotateAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        rotateAnimation.beginTime = currentTime + 2.0;
        rotateAnimation.duration = 1;
        rotateAnimation.fillMode = kCAFillModeForwards;
        rotateAnimation.removedOnCompletion = NO;
        [self.operateView.layer addAnimation:rotateAnimation forKey:@"rotationAnimation"];
    }
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
