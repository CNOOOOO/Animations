//
//  EmitterAnimationController.m
//  Animations
//
//  Created by Mac1 on 2018/5/18.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "EmitterAnimationController.h"
#import "HaloLabel.h"

@interface EmitterAnimationController ()

@property (nonatomic, strong) CAEmitterLayer *cherryLayer;
@property (nonatomic, strong) CAEmitterCell *cherryCell;
@property (nonatomic, strong) CAEmitterLayer *snowLayer;
@property (nonatomic, strong) CAEmitterCell *snowCell;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIButton *cherryBtn;
@property (nonatomic, strong) UIButton *snowBtn;
@property (nonatomic, strong) CAEmitterCell *likeCell;
@property (nonatomic, strong) CAEmitterLayer *likeLayer;
@property (nonatomic, strong) UIButton *likeBtn;

@end

@implementation EmitterAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"粒子动画";
    //渐变背景色
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.view.frame;
    [self.view.layer addSublayer:self.gradientLayer];
    UIColor *lightColor = [UIColor colorWithRed:255.0 / 255.0 green:150.0 / 226.0 blue:190.0 / 255.0 alpha:1.0];
    
    UIColor *whiteColor = [UIColor colorWithRed:255.0 / 255.0 green:250.0 / 255.0 blue:250.0 / 255.0 alpha:1.0];
    //可以设置多个colors,
    self.gradientLayer.colors = @[(__bridge id)lightColor.CGColor,(__bridge id)whiteColor.CGColor];
    //45度变色(由lightColor－>white)
    self.gradientLayer.startPoint = CGPointMake(0, 0);
    self.gradientLayer.endPoint = CGPointMake(1, 1);
    self.gradientLayer.locations = @[@0.33,@0.66];
    //樱桃
    self.cherryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cherryBtn.frame = CGRectMake(SCREEN_WIDTH/2-30, SCREEN_HEIGHT - NAVI_HEIGHT - 190, 60, 40);
    self.cherryBtn.backgroundColor = [UIColor whiteColor];
    [self.cherryBtn setTitle:@"🍒" forState:UIControlStateNormal];
    [self.cherryBtn setTitle:@"停止" forState:UIControlStateSelected];
    [self.cherryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cherryBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    self.cherryBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.cherryBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.cherryBtn.layer.borderWidth = 0.5;
    [self.cherryBtn addTarget:self action:@selector(cherryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cherryBtn];
    //下雪
    self.snowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snowBtn.frame = CGRectMake(SCREEN_WIDTH/2-30, SCREEN_HEIGHT - NAVI_HEIGHT - 140, 60, 40);
    self.snowBtn.backgroundColor = [UIColor whiteColor];
    [self.snowBtn setTitle:@"🌨" forState:UIControlStateNormal];
    [self.snowBtn setTitle:@"停止" forState:UIControlStateSelected];
    [self.snowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.snowBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    self.snowBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.snowBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.snowBtn.layer.borderWidth = 0.5;
    [self.snowBtn addTarget:self action:@selector(snowBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snowBtn];
    //点赞
    self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.likeBtn.frame = CGRectMake(SCREEN_WIDTH - 80, SCREEN_HEIGHT - NAVI_HEIGHT - 80, 30, 30);
    [self.likeBtn setImage:[UIImage imageNamed:@"Like"] forState:UIControlStateNormal];
    [self.likeBtn setImage:[UIImage imageNamed:@"Like-Blue"] forState:UIControlStateSelected];
    [self.likeBtn addTarget:self action:@selector(likeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.likeBtn];
    
    [self setUpLayer];
    
    //动态光晕扫过文字
    HaloLabel *haloView = [[HaloLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
    haloView.font = [UIFont boldSystemFontOfSize:100];
    haloView.text = @"L o v e";
    haloView.textColor = [UIColor whiteColor];
    haloView.haloColor = [UIColor redColor];
    haloView.direction = DirectionTopLeftToBottomRight;
    haloView.center = self.view.center;
    [self.view addSubview:haloView];
    for (int i = 0; i < 8; i++) {
        int64_t delayInSeconds = 3 * i;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            haloView.direction = i;
            [haloView performAnimation];
        });
    }
}

- (void)setUpLayer {
    self.cherryLayer = [CAEmitterLayer layer];
    //粒子产生系数，默认为1,想关掉就设置为0，不会有粒子产生
    self.cherryLayer.birthRate = 1;
    //发射源的位置
    self.cherryLayer.emitterPosition = CGPointMake(SCREEN_WIDTH/2, -10);
    //发射源的大小
    self.cherryLayer.emitterSize = CGSizeMake(SCREEN_WIDTH, 0);
    /**发射源的形状:
     kCAEmitterLayerPoint//点
     kCAEmitterLayerLine//线
     kCAEmitterLayerRectangle//矩形
     kCAEmitterLayerCuboid//立方体
     kCAEmitterLayerCircle//圆形
     kCAEmitterLayerSphere//球形
     */
    self.cherryLayer.emitterShape = kCAEmitterLayerLine;
    /**发射源的模式:
     kCAEmitterLayerPoints//从发射器中
     kCAEmitterLayerOutline//边缘
     kCAEmitterLayerSurface//表面
     kCAEmitterLayerVolume//中点
     */
    self.cherryLayer.emitterMode = kCAEmitterLayerOutline;
    /**渲染模式:
     kCAEmitterLayerUnordered//粒子是无序出现的，多个发射源将混合
     kCAEmitterLayerOldestFirst//生命久的粒子会被渲染在最上层
     kCAEmitterLayerOldestLast//年轻的粒子会被渲染在最上层
     kCAEmitterLayerBackToFront//粒子的渲染按照Z轴的前后顺序进行
     kCAEmitterLayerAdditive//进行粒子混合
     */
    self.cherryLayer.renderMode = kCAEmitterLayerOldestFirst;
    self.cherryLayer.masksToBounds = NO;
    [self.view.layer addSublayer:self.cherryLayer];
    [self setUpCherryCell];
    
    self.snowLayer = [CAEmitterLayer layer];
    self.snowLayer.birthRate = 1;
    self.snowLayer.emitterPosition = CGPointMake(SCREEN_WIDTH/2, -10);
    self.snowLayer.emitterSize = CGSizeMake(SCREEN_WIDTH, 0);
    self.snowLayer.emitterShape = kCAEmitterLayerSphere;
    self.snowLayer.emitterMode = kCAEmitterLayerOutline;
    self.snowLayer.renderMode = kCAEmitterLayerOldestFirst;
    self.snowLayer.masksToBounds = NO;
    [self.view.layer addSublayer:self.snowLayer];
    [self setUpSnowCell];
    
    //点赞
    self.likeLayer = [CAEmitterLayer layer];
    self.likeLayer.birthRate = 1;
    self.likeLayer.emitterPosition = self.likeBtn.center;
    self.likeLayer.emitterSize = CGSizeMake(27, 0);
    self.likeLayer.emitterShape = kCAEmitterLayerCircle;
    self.likeLayer.emitterMode = kCAEmitterLayerOutline;
    self.likeLayer.renderMode = kCAEmitterLayerOldestFirst;
    self.likeLayer.masksToBounds = NO;
    [self.view.layer addSublayer:self.likeLayer];
    [self setUpLikeCell];
}

- (void)setUpCherryCell {
    self.cherryCell = [CAEmitterCell emitterCell];
    //粒子名称
    self.cherryCell.name = @"cherry";
    //粒子的初始发射方向
    //    self.cherryCell.emissionLatitude = M_PI;
    self.cherryCell.emissionLongitude = M_PI;
    //每秒粒子产生个数的乘数因子，会和layer的birthRate相乘，然后确定每秒产生的粒子个数
    self.cherryCell.birthRate = 0;
    //粒子存活时长
    self.cherryCell.lifetime = 30;
    //粒子生命周期范围如这里设置为10，表示20~40
    self.cherryCell.lifetimeRange = 10;
    //粒子透明度变化，设置为－0.4，就是每过一秒透明度就减少0.4，这样就有消失的效果,一般设置为负数。
    self.cherryCell.alphaSpeed = 0;
    //粒子透明度变化范围
    self.cherryCell.alphaRange = 0;
    //粒子速度
    self.cherryCell.velocity = 20;
    //粒子速度范围
    self.cherryCell.velocityRange = 10;
    //粒子Y方向的加速度
    self.cherryCell.yAcceleration = 50;
    //周围发射的角度，如果为M_PI*2 就可以从360度任意位置发射
    self.cherryCell.emissionRange = 5;
    //粒子旋转角度
    //    self.cherryCell.spin = M_PI_2;
    //粒子旋转范围
    //    self.cherryCell.spinRange = M_PI / 3;
    //展示的图片
    self.cherryCell.contents = (id)[UIImage imageNamed:@"cherry"].CGImage;
    //粒子内容颜色
    //    self.cherryCell.color = [UIColor redColor].CGColor;
    self.cherryCell.redSpeed = 0.5;
    self.cherryCell.greenSpeed = 0.5;
    self.cherryCell.blueSpeed = 0.5;
    //设置了颜色变化范围后每次产生的粒子的颜色都是随机的
    self.cherryCell.redRange = 0.7;
    self.cherryCell.blueRange = 0.7;
    self.cherryCell.greenRange = 0.7;
    //缩放比例(将原始大小缩放多少)
    self.cherryCell.scale = 0.5;
    //缩放比例速度(在已缩放的基础上每秒缩放多少)
    self.cherryCell.scaleSpeed = 0.1;
    //缩放比例范围
    self.cherryCell.scaleRange = 0.02;
    self.cherryLayer.emitterCells = [NSArray arrayWithObjects:self.cherryCell, nil];
}

- (void)setUpSnowCell {
    self.snowCell = [CAEmitterCell emitterCell];
    //粒子名称
    self.snowCell.name = @"snow";
    //粒子的初始发射方向
    //    self.snowCell.emissionLatitude = M_PI;
    self.snowCell.emissionLongitude = M_PI;
    //每秒粒子产生个数的乘数因子，会和layer的birthRate相乘，然后确定每秒产生的粒子个数
    self.snowCell.birthRate = 0;
    //粒子存活时长
    self.snowCell.lifetime = 30;
    //粒子生命周期范围如这里设置为10，表示20~40
    self.snowCell.lifetimeRange = 10;
    //粒子透明度变化，设置为－0.4，就是每过一秒透明度就减少0.4，这样就有消失的效果,一般设置为负数。
    self.snowCell.alphaSpeed = -0.1;
    //粒子透明度变化范围
    self.snowCell.alphaRange = 0.2;
    //粒子速度
    self.snowCell.velocity = 20;
    //粒子速度范围
    self.snowCell.velocityRange = 10;
    //粒子Y方向的加速度
    self.snowCell.yAcceleration = 30;
    //周围发射的角度，如果为M_PI*2 就可以从360度任意位置发射
//    self.snowCell.emissionRange = 5;
    //粒子旋转角度
    //    self.snowCell.spin = M_PI_2;
    //粒子旋转范围
    //    self.snowCell.spinRange = M_PI / 3;
    //展示的图片
    self.snowCell.contents = (id)[UIImage imageWithColor:[UIColor whiteColor]].CGImage;
    //粒子内容颜色
    //    self.snowCell.color = [UIColor redColor].CGColor;
    self.snowCell.redSpeed = 0.5;
    self.snowCell.greenSpeed = 0.5;
    self.snowCell.blueSpeed = 0.5;
    //设置了颜色变化范围后每次产生的粒子的颜色都是随机的
    self.snowCell.redRange = 0.7;
    self.snowCell.blueRange = 0.7;
    self.snowCell.greenRange = 0.7;
    //缩放比例(将原始大小缩放多少)
    self.snowCell.scale = 2;
    //缩放比例速度(在已缩放的基础上每秒缩放多少)
    self.snowCell.scaleSpeed = -0.1;
    //缩放比例范围
    self.snowCell.scaleRange = 0.02;
    self.snowLayer.emitterCells = [NSArray arrayWithObjects:self.snowCell, nil];
}

- (void)setUpLikeCell {
    self.likeCell = [CAEmitterCell emitterCell];
    //粒子名称
    self.likeCell.name = @"like";
    //粒子的初始发射方向
//    self.likeCell.emissionLongitude = M_PI;
    //每秒粒子产生个数的乘数因子，会和layer的birthRate相乘，然后确定每秒产生的粒子个数
    self.likeCell.birthRate = 0;
    //粒子存活时长
    self.likeCell.lifetime = 0.7;
    //粒子生命周期范围如这里设置为10，表示20~40
    self.likeCell.lifetimeRange = 0.3;
    //粒子透明度变化，设置为－0.4，就是每过一秒透明度就减少0.4，这样就有消失的效果,一般设置为负数。
    self.likeCell.alphaSpeed = -0.2;
    //粒子透明度变化范围
    self.likeCell.alphaRange = 0.1;
    //粒子速度
    self.likeCell.velocity = 30;
    //粒子速度范围
    self.likeCell.velocityRange = 10;
    self.likeCell.scale = 0.05;
    self.likeCell.scaleRange = 0.02;
    //展示的图片
    self.likeCell.contents = (id)[UIImage imageNamed:@"Sparkle"].CGImage;
    self.likeLayer.emitterCells = [NSArray arrayWithObjects:self.likeCell, nil];
}

- (void)cherryBtnClicked:(UIButton *)button {
    self.snowBtn.selected = NO;
    button.selected = !button.selected;
    if (button.selected) {
        UIColor *lightColor = [UIColor colorWithRed:255.0 / 255.0 green:150.0 / 226.0 blue:190.0 / 255.0 alpha:1.0];
        UIColor *whiteColor = [UIColor colorWithRed:255.0 / 255.0 green:250.0 / 255.0 blue:250.0 / 255.0 alpha:1.0];
        //可以设置多个colors,
        self.gradientLayer.colors = @[(__bridge id)lightColor.CGColor,(__bridge id)whiteColor.CGColor];
        [self.snowLayer removeFromSuperlayer];
        [self.view.layer addSublayer:self.cherryLayer];
        [self.cherryLayer setValue:@4 forKeyPath:@"emitterCells.cherry.birthRate"];
    }else {
        [self.cherryLayer setValue:@0 forKeyPath:@"emitterCells.cherry.birthRate"];
    }
}

- (void)snowBtnClicked:(UIButton *)button {
    self.cherryBtn.selected = NO;
    button.selected = !button.selected;
    if (button.selected) {
        UIColor *lightColor = [UIColor colorWithRed:40.0 / 255.0 green:150.0 / 255.0 blue:200.0 / 255.0 alpha:1.0];
        UIColor *whiteColor = [UIColor colorWithRed:255.0 / 255.0 green:250.0 / 255.0 blue:250.0 / 255.0 alpha:1.0];
        //可以设置多个colors,
        self.gradientLayer.colors = @[(__bridge id)lightColor.CGColor,(__bridge id)whiteColor.CGColor];
        [self.cherryLayer removeFromSuperlayer];
        [self.view.layer addSublayer:self.snowLayer];
        [self.snowLayer setValue:@1000 forKeyPath:@"emitterCells.snow.birthRate"];
    }else {
        [self.snowLayer setValue:@0 forKeyPath:@"emitterCells.snow.birthRate"];
    }
}

- (void)likeBtnClicked:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        CFTimeInterval currentTime = CACurrentMediaTime();
        CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
        NSValue *value1 = [NSNumber numberWithFloat:-M_PI / 16];
        NSValue *value2 = [NSNumber numberWithFloat:M_PI / 16];
        NSValue *value3 = [NSNumber numberWithFloat:0];
        keyFrameAnimation.values = @[value1,value2,value3];
        
        CABasicAnimation *basicAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        basicAnimation1.fromValue = [NSNumber numberWithFloat:1.0];
        basicAnimation1.toValue = [NSNumber numberWithFloat:1.4];
        
        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
        groupAnimation.animations = [NSArray arrayWithObjects:keyFrameAnimation,basicAnimation1, nil];
        groupAnimation.duration = 1;
        groupAnimation.fillMode = kCAFillModeForwards;
        groupAnimation.removedOnCompletion = NO;
        groupAnimation.beginTime = currentTime;
        [self.likeBtn.layer addAnimation:groupAnimation forKey:@"groupAnimation"];
        
        CABasicAnimation *basicAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        basicAnimation2.fromValue = [NSNumber numberWithFloat:1.4];
        basicAnimation2.toValue = [NSNumber numberWithFloat:1.0];
        basicAnimation2.duration = 0.5;
        basicAnimation2.fillMode = kCAFillModeForwards;
        basicAnimation2.removedOnCompletion = NO;
        basicAnimation2.beginTime = currentTime + 1.0;
        [self.likeBtn.layer addAnimation:basicAnimation2 forKey:@"scaleAnimation"];
        
        //另一种方式
//        self.likeBtn.transform = CGAffineTransformIdentity;
//        [UIView animateKeyframesWithDuration:1.5 delay:0 options:0 animations: ^{
//            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:2 / 3.0 animations: ^{
//                typeof(self) strongSelf = weakSelf;
//                CGAffineTransform transform1 = CGAffineTransformMakeRotation(-M_PI / 16);
//                CGAffineTransform transform2 = CGAffineTransformRotate(transform1, 0);
//                strongSelf.likeBtn.transform = CGAffineTransformScale(transform2, 1.4, 1.4);
//            }];
//            [UIView addKeyframeWithRelativeStartTime:2/3.0 relativeDuration:1/3.0 animations: ^{
//                typeof(self) strongSelf = weakSelf;
//                strongSelf.likeBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
//            }];
//        } completion:nil];
        
        self.likeLayer.beginTime = CACurrentMediaTime();
        [self.likeLayer setValue:@600 forKeyPath:@"emitterCells.like.birthRate"];
        [self performSelector:@selector(stop) withObject:nil afterDelay:0.1];
    }else {
        [self.likeLayer setValue:@0 forKeyPath:@"emitterCells.like.birthRate"];
    }
}

- (void)stop {
    [self.likeLayer setValue:@0 forKeyPath:@"emitterCells.like.birthRate"];
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
