//
//  TransitionAnimationsController.m
//  Animations
//
//  Created by Mac1 on 2018/5/14.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "TransitionAnimationsController.h"

@interface TransitionAnimationsController () {
    NSInteger _index;
}

@property (nonatomic, strong) UIView *operateView;//操作视图
@property (nonatomic, strong) NSArray *buttonTitles;//按钮标题

@end

@implementation TransitionAnimationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"组动画";
    self.buttonTitles = @[@"fade",@"moveIn",@"push",@"reveal",@"cube",@"suck",@"oglFlip",@"ripple",@"Curl",@"UnCurl",@"caOpen",@"caClose"];
    //添加被操作的视图
    self.operateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT)];
    [self.view addSubview:self.operateView];
    [self addOperateButtons];
    [self changeView:YES];
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
    switch (sender.tag) {
        case 1000:
            [self fadeAnimation];
            break;
        case 1001:
            [self moveInAnimation];
            break;
        case 1002:
            [self pushAnimation];
            break;
        case 1003:
            [self revealAnimation];
            break;
        case 1004:
            [self cubeAnimation];
            break;
        case 1005:
            [self suckEffectAnimation];
            break;
        case 1006:
            [self oglFlipAnimation];
            break;
        case 1007:
            [self rippleEffectAnimation];
            break;
        case 1008:
            [self pageCurlAnimation];
            break;
        case 1009:
            [self pageUnCurlAnimation];
            break;
        case 1010:
            [self cameraIrisHollowOpenAnimation];
            break;
        case 1011:
            [self cameraIrisHollowCloseAnimation];
            break;
        default:
            break;
    }
}

//-----------------------------public api------------------------------------
/*
 type:
 kCATransitionFade;
 kCATransitionMoveIn;
 kCATransitionPush;
 kCATransitionReveal;
 */
/*
 subType:
 kCATransitionFromRight;
 kCATransitionFromLeft;
 kCATransitionFromTop;
 kCATransitionFromBottom;
 */
//逐渐消失
- (void)fadeAnimation {
    [self changeView:YES];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;//设置动画的类型
    transition.subtype = kCATransitionFromRight; //设置动画的方向
    transition.startProgress = 0.1;//设置动画起点
    transition.endProgress = 1.0;//设置动画终点
    transition.duration = 1.0;
    [self.operateView.layer addAnimation:transition forKey:@"fadeAnimation"];
}

//moveIn(移动进入)
- (void)moveInAnimation {
    [self changeView:YES];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0;
    [self.operateView.layer addAnimation:transition forKey:@"moveInAnimation"];
}

//push(推入)
- (void)pushAnimation {
    [self changeView:YES];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0;
    [self.operateView.layer addAnimation:transition forKey:@"pushAnimation"];
}

//reveal(揭示)
- (void)revealAnimation {
    [self changeView:YES];
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromRight;
    transition.duration = 1.0;
    [self.operateView.layer addAnimation:transition forKey:@"revealAnimation"];
}

//-----------------------------private api------------------------------------
/*不建议使用
 Don't be surprised if Apple rejects your app for including those effects,
 and especially don't be surprised if your app starts behaving strangely after an OS update.
 */
//立体翻滚
- (void)cubeAnimation {
    [self changeView:YES];
    CATransition *transition = [CATransition animation];
    transition.type = @"cube";//设置动画的类型
    transition.subtype = kCATransitionFromRight; //设置动画的方向
    transition.duration = 1.0f;
    [self.operateView.layer addAnimation:transition forKey:@"revealAnimation"];
}

//吸吮效果
- (void)suckEffectAnimation {
    [self changeView:YES];
    CATransition *transition = [CATransition animation];
    transition.type = @"suckEffect";//设置动画的类型
    transition.subtype = kCATransitionFromRight; //设置动画的方向
    transition.duration = 1.0f;
    [self.operateView.layer addAnimation:transition forKey:@"suckEffectAnimation"];
}

//OGL翻转
- (void)oglFlipAnimation {
    [self changeView:YES];
    CATransition *transition = [CATransition animation];
    transition.type = @"oglFlip";//设置动画的类型
    transition.subtype = kCATransitionFromRight; //设置动画的方向
    transition.duration = 1.0f;
    [self.operateView.layer addAnimation:transition forKey:@"oglFlipAnimation"];
}

//连锁反应（自己体会）
- (void)rippleEffectAnimation {
    [self changeView:YES];
    CATransition *transition = [CATransition animation];
    transition.type = @"rippleEffect";//设置动画的类型
    transition.subtype = kCATransitionFromRight; //设置动画的方向
    transition.duration = 1.0f;
    [self.operateView.layer addAnimation:transition forKey:@"rippleEffectAnimation"];
}

//卷页
- (void)pageCurlAnimation {
    [self changeView:YES];
    CATransition *transition = [CATransition animation];
    transition.type = @"pageCurl";//设置动画的类型
    transition.subtype = kCATransitionFromTop; //设置动画的方向
    transition.duration = 1.0f;
    [self.operateView.layer addAnimation:transition forKey:@"pageCurlAnimation"];
}

//页面解卷
- (void)pageUnCurlAnimation {
    [self changeView:YES];
    CATransition *transition = [CATransition animation];
    transition.type = @"pageUnCurl";//设置动画的类型
    transition.subtype = kCATransitionFromTop; //设置动画的方向
    transition.duration = 1.0f;
    [self.operateView.layer addAnimation:transition forKey:@"pageUnCurlAnimation"];
}

//开摄像机孔
- (void)cameraIrisHollowOpenAnimation {
    [self changeView:YES];
    CATransition *transition = [CATransition animation];
    transition.type = @"cameraIrisHollowOpen";//设置动画的类型
    transition.subtype = kCATransitionFromRight; //设置动画的方向
    transition.duration = 1.0f;
    [self.operateView.layer addAnimation:transition forKey:@"cameraIrisHollowOpenAnimation"];
}

//关摄像机孔
- (void)cameraIrisHollowCloseAnimation {
    [self changeView:YES];
    CATransition *transition = [CATransition animation];
    transition.type = @"cameraIrisHollowClose";//设置动画的类型
    transition.subtype = kCATransitionFromRight; //设置动画的方向
    transition.duration = 1.0f;
    [self.operateView.layer addAnimation:transition forKey:@"cameraIrisHollowCloseAnimation"];
}

- (void)changeView:(BOOL)isUp{
    if (_index>3) {
        _index = 0;
    }
    if (_index<0) {
        _index = 3;
    }
    NSArray *colors = [NSArray arrayWithObjects:[UIColor redColor],[UIColor magentaColor],[UIColor greenColor],[UIColor purpleColor], nil];
    self.operateView.backgroundColor = [colors objectAtIndex:_index];
    if (isUp) {
        _index++;
    }else{
        _index--;
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
