//
//  BasicAnimationsController.m
//  Animations
//
//  Created by Mac1 on 2018/5/11.
//  Copyright © 2018年 Mac1. All rights reserved.
//
/**
 常用animation的KeyPath:
 1、tansform.scale                  缩放比例
 2、tansform.scale.x                X轴的缩放比例
 3、tansform.scale.y                Y轴的缩放比例
 4、tansform.scale.z                Z轴的缩放比例
 5、transform.rotation              默认围绕z轴
 6、tansform.rotation.x             围绕X轴旋转
 7、tansform.rotation.y             围绕Y轴旋转
 8、tansform.rotation.z             围绕Z轴旋转
 9、transform.translation           移动 参数：移动到的点 （100，100）
 10、position                       位置变化（中心点）
 11、opacity                        透明度
 12、masksToBounds                  限界遮罩
 13、cornerRadius                   圆角设置
 14、borderWidth                    边框宽度
 15、borderColor                    边框颜色
 16、backgroundColor                背景色
 17、bounds                         大小，中心点不变
 18、contents                       内容改变
 19、contentsRect                   可视内容 参数：CGRect 值是0～1之间的小数
 20、contentsRect.size.width        横向拉伸缩放(0~1)
 21、contentsRect.size.height       纵向拉伸缩放(0~1)
 22、hidden                         是否隐藏
 23、shadowColor                    阴影颜色
 24、shadowOffset                   阴影偏移量
 25、shadowOpacity                  阴影透明度
 26、shadowRadius                   阴影半径
 */

#import "BasicAnimationsController.h"

@interface BasicAnimationsController ()

@property (nonatomic, strong) UIView *operateView;//操作视图
@property (nonatomic, strong) NSArray *buttonTitles;//按钮标题

@end

@implementation BasicAnimationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"基础动画";
    self.buttonTitles = @[@"位移",@"旋转",@"缩放",@"透明度",@"背景色"];
    //添加被操作的视图
    self.operateView = [[UIView alloc] initWithFrame:CGRectMake(VIEW_WIDTH * 0.5 - 50, VIEW_HEIGHT * 0.5 - 50, 100, 100)];
    self.operateView.backgroundColor = [UIColor blackColor];
    self.operateView.layer.masksToBounds = YES;
    self.operateView.layer.cornerRadius = 50;
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
        //位移
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
        basicAnimation.fromValue = [NSValue valueWithCGPoint:self.operateView.center];
        basicAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(VIEW_WIDTH - 50, VIEW_HEIGHT - 50)];
        basicAnimation.duration = 1;
        //以下两句设置移动后停留在最终的位置
//        basicAnimation.fillMode = kCAFillModeForwards;
//        basicAnimation.removedOnCompletion = NO;
        
        /**
         kCAMediaTimingFunctionLinear 线性动画
         kCAMediaTimingFunctionEaseIn 先慢后快（慢进快出）
         kCAMediaTimingFunctionEaseOut 先块后慢（快进慢出）
         kCAMediaTimingFunctionEaseInEaseOut 先慢后快再慢
         kCAMediaTimingFunctionDefault 默认，也属于中间比较快
         */
        basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [self.operateView.layer addAnimation:basicAnimation forKey:@"positionAnimation"];
        
        //使用UIView的代码块调用
//        [UIView animateWithDuration:1 animations:^{
//            self.operateView.frame = CGRectMake(VIEW_WIDTH - 100, VIEW_HEIGHT - 100, 100, 100);
//        } completion:^(BOOL finished) {
//            self.operateView.frame = CGRectMake(VIEW_WIDTH * 0.5 - 50, VIEW_HEIGHT * 0.5 - 50, 100, 100);
//        }];
        
        //使用UIView的[begin, commit]模式
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:1];
//        self.operateView.frame = CGRectMake(VIEW_WIDTH - 100, VIEW_HEIGHT - 100, 100, 100);
//        [UIView commitAnimations];
    }else if (sender.tag == 1001) {
        //旋转(绕着x,y,z轴进行旋转)
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        basicAnimation.toValue = [NSNumber numberWithFloat:M_PI];
        basicAnimation.duration = 1;
//        basicAnimation.repeatCount = 10;
//        basicAnimation.repeatDuration = 10;
        [self.operateView.layer addAnimation:basicAnimation forKey:@"rotateAnimation"];
        
//        //valueWithCATransform3D作用与layer
//        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
//        basicAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 1, 0)];//绕着（x,y,z）旋转
//        basicAnimation.duration = 1;
//        basicAnimation.repeatCount = MAXFLOAT;
//        [self.operateView.layer addAnimation:basicAnimation forKey:@"rotateAnimation"];
        
//        //CGAffineTransform作用与View
//        self.operateView.transform = CGAffineTransformMakeRotation(0);
//        [UIView animateWithDuration:1 animations:^{
//            self.operateView.transform = CGAffineTransformMakeRotation(M_PI);
//        } completion:^(BOOL finished) {
//
//        }];
    }else if (sender.tag == 1002) {
        //缩放
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        basicAnimation.toValue = [NSNumber numberWithFloat:2.0];
        basicAnimation.duration = 1;
        [self.operateView.layer addAnimation:basicAnimation forKey:@"scaleAnimation"];
        
//        //x,y,z轴的缩放
//        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
//        basicAnimation.toValue = [NSNumber numberWithFloat:2.0f];
//        basicAnimation.duration = 1;
//        [self.operateView.layer addAnimation:basicAnimation forKey:@"scaleAnimation"];
    }else if (sender.tag == 1003) {
        //透明度
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        basicAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        basicAnimation.toValue = [NSNumber numberWithFloat:0.1];
        basicAnimation.duration = 2;
        [self.operateView.layer addAnimation:basicAnimation forKey:@"opacityAnimation"];
    }else {
        //背景色
        CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        basicAnimation.toValue =(id) [UIColor redColor].CGColor;
        basicAnimation.duration = 1.0f;
        [self.operateView.layer addAnimation:basicAnimation forKey:@"backgroundAnimation"];
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
