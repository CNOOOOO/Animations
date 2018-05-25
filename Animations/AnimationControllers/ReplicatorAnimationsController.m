//
//  ReplicatorAnimationsController.m
//  Animations
//
//  Created by Mac1 on 2018/5/21.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "ReplicatorAnimationsController.h"
#import "ReplicatorSecondController.h"

@interface ReplicatorAnimationsController ()

@property (nonatomic, strong) CAReplicatorLayer *waveLayer;
@property (nonatomic, strong) CAReplicatorLayer *radarLayer;
@property (nonatomic, strong) CAReplicatorLayer *triangleLayer;
@property (nonatomic, strong) CAReplicatorLayer *roundLayer;
@property (nonatomic, strong) CAReplicatorLayer *gridLayer;
@property (nonatomic, strong) CAReplicatorLayer *heartLayer;
@property (nonatomic, strong) CAReplicatorLayer *music1Layer;
@property (nonatomic, strong) CAReplicatorLayer *music2Layer;
@property (nonatomic, strong) CAReplicatorLayer *music3Layer;

@end

@implementation ReplicatorAnimationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"复制图层动画";
    //波浪圆
    [self addWaveReplicatorLayer];
    //雷达图
    [self addRadarReplicatorLayer];
    //三角形
    [self addTriangleReplicatorLayer];
    //转圈
    [self addRoundReplicatorLayer];
    //网格
    [self addGridReplicatorLayer];
    //心形
    [self addHeartReplicatorLayer];
    //音乐震荡（这里有关于CAReplicatorLayer各参数的注解）
    [self addMusicReplicatorLayer];
    
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"下一页" style:UIBarButtonItemStyleDone target:self action:@selector(showNextPage)];
    [nextItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"Helvetica-Bold" size:15.0], NSFontAttributeName,
                                         [UIColor blackColor], NSForegroundColorAttributeName,
                                         nil]
                               forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = nextItem;
}

- (void)showNextPage {
    ReplicatorSecondController *secondController = [[ReplicatorSecondController alloc] init];
    [self.navigationController pushViewController:secondController animated:YES];
}

- (void)addRadarReplicatorLayer {
    self.radarLayer = [CAReplicatorLayer layer];
    self.radarLayer.frame = CGRectMake(15, 50, 100, 100);
    self.radarLayer.instanceDelay = 0.6;
    self.radarLayer.instanceCount = 5;
    [self.view.layer addSublayer:self.radarLayer];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, 100, 100);
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)].CGPath;
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    shapeLayer.opacity = 0.0;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @(0.7);
    alphaAnimation.toValue = @(0.0);
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[alphaAnimation,scaleAnimation];
    animationGroup.duration = 3.0;
    animationGroup.autoreverses = NO;
    animationGroup.repeatCount = HUGE;
    animationGroup.removedOnCompletion = NO;
    [shapeLayer addAnimation:animationGroup forKey:@"animationGroup"];
    
    [self.radarLayer addSublayer:shapeLayer];
}

- (void)addTriangleReplicatorLayer {
    self.triangleLayer = [CAReplicatorLayer layer];
    self.triangleLayer.frame = CGRectMake(SCREEN_WIDTH-115, 50, 25, 25);
    self.triangleLayer.instanceCount = 3;
    self.triangleLayer.instanceDelay = 0;
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D = CATransform3DTranslate(transform3D, 75, 0.0, 0.0);
    transform3D = CATransform3DRotate(transform3D, 120.0*M_PI/180.0, 0.0, 0.0, 1.0);
    self.triangleLayer.instanceTransform = transform3D;
    [self.view.layer addSublayer:self.triangleLayer];
    
    CAShapeLayer *shapreLayer = [CAShapeLayer layer];
    shapreLayer.frame =CGRectMake(0, 0, 25, 25);
    shapreLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 25, 25)].CGPath;
    shapreLayer.strokeColor = [UIColor redColor].CGColor;
    shapreLayer.fillColor = [UIColor redColor].CGColor;
    shapreLayer.lineWidth = 1;
    //也可以添加自己的素材
//    shapreLayer.contents = (__bridge id)[UIImage imageNamed:@"emojy"].CGImage;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CATransform3D fromValue = CATransform3DRotate(CATransform3DIdentity, 0.0, 0.0, 0.0, 0.0);
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:fromValue];
    CATransform3D toValue = CATransform3DTranslate(CATransform3DIdentity, 75, 0.0, 0.0);
    toValue = CATransform3DRotate(toValue,120.0*M_PI/180.0, 0.0, 0.0, 1.0);
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:toValue];
    scaleAnimation.autoreverses = NO;
    scaleAnimation.repeatCount = HUGE;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.duration = 0.8;
    scaleAnimation.removedOnCompletion = NO;
    [shapreLayer addAnimation:scaleAnimation forKey:@"rotateAnimation"];
    
    [self.triangleLayer addSublayer:shapreLayer];
}

- (void)addRoundReplicatorLayer {
    self.roundLayer = [CAReplicatorLayer layer];
    self.roundLayer.frame = CGRectMake(35, 210, 60, 60);
    self.roundLayer.instanceCount = 12;
    self.roundLayer.instanceDelay = 1.2/12;
    self.roundLayer.instanceTransform = CATransform3DMakeRotation((2 * M_PI) / 12, 0, 0, 1);
    [self.view.layer addSublayer:self.roundLayer];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 14, 14);
    layer.cornerRadius = 7;
    layer.masksToBounds = YES;
    layer.autoreverses = YES;
    layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    layer.backgroundColor = [UIColor redColor].CGColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1.2;
    animation.repeatCount = MAXFLOAT;
    animation.fromValue = @(1);
    animation.toValue = @(0.01);
    animation.removedOnCompletion = NO;
    [layer addAnimation:animation forKey:nil];
    
    [self.roundLayer addSublayer:layer];
}

- (void)addGridReplicatorLayer {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, 20, 20);
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 20, 20)].CGPath;
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0.0)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @(1.0);
    alphaAnimation.toValue = @(0.0);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[scaleAnimation, alphaAnimation];
    animationGroup.duration = 1.0;
    animationGroup.autoreverses = YES;
    animationGroup.repeatCount = HUGE;
    animationGroup.removedOnCompletion = NO;
    [shapeLayer addAnimation:animationGroup forKey:@"groupAnimation"];
    
    CAReplicatorLayer *replicatorLayerX = [CAReplicatorLayer layer];
    replicatorLayerX.frame = CGRectMake(0, 0, 100, 100);
    replicatorLayerX.instanceDelay = 0.3;
    replicatorLayerX.instanceCount = 3;
    replicatorLayerX.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, 25, 0, 0);
    [replicatorLayerX addSublayer:shapeLayer];
    
    CAReplicatorLayer *replicatorLayerY = [CAReplicatorLayer layer];
    replicatorLayerY.frame = CGRectMake(SCREEN_WIDTH-115, 200, 100, 100);
    replicatorLayerY.instanceDelay = 0.3;
    replicatorLayerY.instanceCount = 3;
    replicatorLayerY.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 25, 0);
    [replicatorLayerY addSublayer:replicatorLayerX];
    [self.view.layer addSublayer:replicatorLayerY];
}

- (void)addWaveReplicatorLayer {
    self.waveLayer = [CAReplicatorLayer layer];
    self.waveLayer.frame = CGRectMake(SCREEN_WIDTH*0.5-37.5, 10, 75, 25);
    self.waveLayer.instanceDelay = 0.2;
    self.waveLayer.instanceCount = 3;
    self.waveLayer.instanceTransform = CATransform3DMakeTranslation(20,0,0);
    [self.view.layer addSublayer:self.waveLayer];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(10, 5, 15, 15);
    shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 15, 15)].CGPath;
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 0.0)];
    animation.autoreverses = YES;
    animation.repeatCount = HUGE;
    animation.duration = 0.6;
    animation.removedOnCompletion = NO;
    [shapeLayer addAnimation:animation forKey:@"scaleAnimation"];
    [self.waveLayer addSublayer:shapeLayer];
}

- (void)addHeartReplicatorLayer {
    self.heartLayer = [CAReplicatorLayer layer];
    self.heartLayer.frame = CGRectMake(SCREEN_WIDTH*0.5-80, VIEW_HEIGHT-NAVI_HEIGHT-245, 160, 160);
    self.heartLayer.instanceCount = 40;
    self.heartLayer.instanceColor = [UIColor redColor].CGColor;
    self.heartLayer.instanceDelay = 5/40.0;
    [self.view.layer addSublayer:self.heartLayer];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(75, 35, 10, 10);
//    layer.backgroundColor = [UIColor redColor].CGColor;
//    layer.masksToBounds = YES;
//    layer.cornerRadius = 5;
//    layer.borderColor = [UIColor whiteColor].CGColor;
//    layer.borderWidth = 0.5;
    layer.contents = (__bridge id)[UIImage imageNamed:@"heart"].CGImage;
    layer.shouldRasterize = YES;
    layer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.heartLayer addSublayer:layer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    UIBezierPath *bezierPath = [UIBezierPath new];
    [bezierPath moveToPoint:(CGPointMake(80, 40))];
    //曲线
    [bezierPath addCurveToPoint:CGPointMake(155, 50) controlPoint1:CGPointMake(85, 5) controlPoint2:CGPointMake(155, 5)];
    [bezierPath addQuadCurveToPoint:CGPointMake(80, 155) controlPoint:CGPointMake(145, 100)];
    [bezierPath addQuadCurveToPoint:CGPointMake(5, 50) controlPoint:CGPointMake(15, 100)];
    [bezierPath addCurveToPoint:CGPointMake(80, 40) controlPoint1:CGPointMake(5, 5) controlPoint2:CGPointMake(75, 5)];
    [bezierPath closePath];
    //缩放
//    CGAffineTransform T = CGAffineTransformMakeScale(0.5, 0.5);
//    animation.path = CGPathCreateCopyByTransformingPath(bezierPath.CGPath, &T);
    animation.path = bezierPath.CGPath;
    animation.repeatCount = INFINITY;
    animation.duration = 5;
    animation.removedOnCompletion = NO;
    [layer addAnimation:animation forKey:nil];
}

- (void)addMusicReplicatorLayer {
    /***********第一种**************/
    //可以将自己的子图层复制指定的次数,并且复制体会保持被复制图层的各种基础属性以及动画
    _music1Layer = [CAReplicatorLayer layer];
    _music1Layer.frame = CGRectMake(SCREEN_WIDTH-80, SCREEN_HEIGHT-NAVI_HEIGHT-65, 65, 50);
//    _music1Layer.position = CGPointMake(SCREEN_WIDTH-47.5, SCREEN_HEIGHT-NAVI_HEIGHT-40);
    //拷贝图层的次数,包括其所有的子图层,默认值是1,也就是没有任何子图层被复制
    _music1Layer.instanceCount = 5;
    //复制图层被创建时和上一个复制图层的位移(位移的锚点时CAReplicatorlayer的中心点)
    _music1Layer.instanceTransform = CATransform3DMakeTranslation(10, 0, 0);
    //在短时间内的复制延时,一般用在动画上(支持动画的延时)
    _music1Layer.instanceDelay = 0.1;
    //如果设置为YES,图层将保持于CATransformLayer类似的性质和相同的限制
    _music1Layer.preservesDepth = NO;
    //设置多个复制图层的颜色,默认为白色
    _music1Layer.instanceColor = [UIColor whiteColor].CGColor;
    //layer背景色
    _music1Layer.backgroundColor = [UIColor redColor].CGColor;
    //设置每个复制图层相对上一个复制图层的RGB偏移量
//    _music1Layer.instanceRedOffset = -0.1;
//    _music1Layer.instanceGreenOffset = -0.1;
//    _music1Layer.instanceBlueOffset = -0.1;
    //设置每个复制图层相对于上一个复制图层透明度偏移量
//    _music1Layer.instanceAlphaOffset = -0.2;
    _music1Layer.masksToBounds = YES;
    [self.view.layer addSublayer:_music1Layer];
    
    CALayer *layer1 = [CALayer layer];
    layer1.frame = CGRectMake(10, 20, 5, 40);
    layer1.backgroundColor = [UIColor whiteColor].CGColor;
    [_music1Layer addSublayer:layer1];
    
    CABasicAnimation *musicAnimation1 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    musicAnimation1.duration = 0.35;
    musicAnimation1.fromValue = @(layer1.frame.size.height);
    //    musicAnimation1.toValue = @(layer1.frame.size.height - 20);
    musicAnimation1.byValue = @(20);
    musicAnimation1.autoreverses = YES;
    musicAnimation1.repeatCount = MAXFLOAT;
    musicAnimation1.removedOnCompletion = NO;
    [layer1 addAnimation:musicAnimation1 forKey:@"musicAnimation1"];
    
    /*************第二种*****************/
    _music2Layer = [CAReplicatorLayer layer];
    _music2Layer.frame = CGRectMake(SCREEN_WIDTH*0.5-32.5, SCREEN_HEIGHT-NAVI_HEIGHT-65, 65, 50);
    _music2Layer.instanceCount = 5;
    _music2Layer.instanceTransform = CATransform3DMakeTranslation(10, 0, 0);
    _music2Layer.instanceDelay = 0.1;
    _music2Layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:_music2Layer];
    
    CALayer *layer2 = [CALayer layer];
    layer2.frame = CGRectMake(10, 10, 5, 20);
    layer2.backgroundColor = [UIColor whiteColor].CGColor;
    [_music2Layer addSublayer:layer2];
    
    CABasicAnimation *musicAnimation2 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    musicAnimation2.duration = 0.35;
    musicAnimation2.fromValue = @(layer2.frame.size.height);
    musicAnimation2.byValue = @(10);
    musicAnimation2.autoreverses = YES;
    musicAnimation2.repeatCount = MAXFLOAT;
    musicAnimation2.removedOnCompletion = NO;
    [layer2 addAnimation:musicAnimation2 forKey:@"musicAnimation2"];
    
    /*************第三种*****************/
    CGFloat width = 65;
    CGFloat height = 50;
    CGFloat margin = 8.0;//间隔
    CGFloat eachWidth = (width - 2 * margin - 20) / 3;//每一个的宽度
    CGFloat spacing = margin + eachWidth;//两个复制图层偏移量
    _music3Layer = [CAReplicatorLayer layer];
    _music3Layer.frame = CGRectMake(15, SCREEN_HEIGHT-NAVI_HEIGHT-65, width, height);
    _music3Layer.instanceCount = 3;
    _music3Layer.instanceTransform = CATransform3DMakeTranslation(spacing, 0, 0);
    _music3Layer.instanceDelay = 0.1;
    _music3Layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:_music3Layer];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(10, (height - eachWidth)/2, eachWidth, eachWidth);
    shapeLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, eachWidth, eachWidth)].CGPath;
    shapeLayer.fillColor = [UIColor whiteColor].CGColor;
    [_music3Layer addSublayer:shapeLayer];
    
    CABasicAnimation *musicAnimation3 = [CABasicAnimation animationWithKeyPath:@"transform"];
    musicAnimation3.duration = 0.6;
    musicAnimation3.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, 0, 0, 1, 0)];
    musicAnimation3.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, M_PI, 0, 1, 0)];
    musicAnimation3.repeatCount = MAXFLOAT;
    musicAnimation3.removedOnCompletion = NO;
    [shapeLayer addAnimation:musicAnimation3 forKey:@"musicAnimation3"];
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
