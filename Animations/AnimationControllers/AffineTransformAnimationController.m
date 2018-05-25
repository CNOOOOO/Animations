//
//  AffineTransformAnimationController.m
//  Animations
//
//  Created by Mac1 on 2018/5/14.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "AffineTransformAnimationController.h"

@interface AffineTransformAnimationController ()

@property (nonatomic, strong) UIView *operateView;//操作视图
@property (nonatomic, strong) NSArray *buttonTitles;//按钮标题

@end

@implementation AffineTransformAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"仿射变化动画";
    self.buttonTitles = @[@"位移",@"旋转",@"缩放",@"组合",@"反转"];
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
        self.operateView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:1 animations:^{
            self.operateView.transform = CGAffineTransformMakeTranslation(0, 100);
        }];
    }else if (sender.tag == 1001) {
        self.operateView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:1 animations:^{
            self.operateView.transform = CGAffineTransformMakeRotation(M_PI * 3/4);
        }];
    }else if (sender.tag == 1002) {
        self.operateView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:1 animations:^{
            self.operateView.transform = CGAffineTransformMakeScale(2, 2);
        }];
    }else if (sender.tag == 1003) {
        self.operateView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:1.0f animations:^{
            CGAffineTransform transform1 = CGAffineTransformMakeRotation(M_PI);
            CGAffineTransform transform2 = CGAffineTransformScale(transform1, 0.5, 0.5);
            self.operateView.transform = CGAffineTransformTranslate(transform2, 0, 100);
        }];
    }else {
        self.operateView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:1.0f animations:^{
            //矩阵反转
            self.operateView.transform = CGAffineTransformInvert(CGAffineTransformMakeScale(0.5, 0.5));//正常情况下0.5的缩放比会使图形变小，但在这刚好相反，图形会放大
        }];
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
