//
//  ReplicatorSecondController.m
//  Animations
//
//  Created by Mac1 on 2018/5/23.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "ReplicatorSecondController.h"
#import "InvertedView.h"
#import "BloomingButton.h"

@interface ReplicatorSecondController () <BloomingButtonDelegate>

@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation ReplicatorSecondController

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"复制图层动画";
    [super viewDidLoad];
    //添加倒影
    [self addInvertedView];
    //添加展开按钮
    BloomingButton *bloom = [[BloomingButton alloc] initWithFrame:self.view.frame];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.center = CGPointMake(SCREEN_WIDTH*0.5, 400);
    [button setImage:[UIImage imageNamed:@"chooser-button"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"chooser-button"] forState:UIControlStateSelected];
    bloom.homeButton = button;
    bloom.bloomRadius = 100;
//    bloom.isRoundDistribution = YES;
    for (int i=0; i<5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 40, 40);
        [button setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"heart"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"chooser-moment-button"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"chooser-moment-button"] forState:UIControlStateSelected];
        [self.buttons addObject:button];
    }
    bloom.itemButtons = self.buttons;
    bloom.delegate = self;
    [self.view addSubview:bloom];
}

- (void)selectedItemWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            NSLog(@"select item %d",(int)index);
            break;
        case 1:
            NSLog(@"select item %d",(int)index);
            break;
        case 2:
            NSLog(@"select item %d",(int)index);
            break;
        case 3:
            NSLog(@"select item %d",(int)index);
            break;
        case 4:
            NSLog(@"select item %d",(int)index);
            break;
        default:
            break;
    }
}

- (void)addInvertedView {
    //方式一
    InvertedView *invertedView = [[InvertedView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.5-100, 30, 200, 100)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, invertedView.frame.size.width, invertedView.frame.size.height)];
    imageView.image = [UIImage imageNamed:@"invert"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;

    CAReplicatorLayer *layer = (CAReplicatorLayer *)invertedView.layer;
    layer.instanceCount = 2;
    CATransform3D transform = CATransform3DMakeTranslation(0, 100, 0);
    layer.instanceTransform = CATransform3DRotate(transform, M_PI, 1, 0, 0);
    layer.instanceRedOffset = -0.2;//红色偏移量
    layer.instanceBlueOffset = -0.2;//蓝色
    layer.instanceGreenOffset = -0.2;//绿色
    layer.instanceAlphaOffset = -0.4;//透明度偏移量
    [invertedView addSubview:imageView];
    [self.view addSubview:invertedView];
    [self.view.layer addSublayer:layer];
    
    //方式二
//    CAReplicatorLayer *layer = [CAReplicatorLayer layer];
//    layer.frame = CGRectMake(100, 100, 200, 100);
//    layer.instanceCount = 2;
//    layer.instanceDelay = 0;
//    CATransform3D transform = CATransform3DMakeTranslation(0, 100, 0);
//    layer.instanceTransform = CATransform3DRotate(transform, M_PI, 1, 0, 0);
//    layer.instanceRedOffset = -0.2;//红色偏移量
//    layer.instanceBlueOffset = -0.2;//蓝色
//    layer.instanceGreenOffset = -0.2;//绿色
//    layer.instanceAlphaOffset = -0.4;//透明度偏移量
//    [self.view.layer addSublayer:layer];
//
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.anchorPoint = CGPointMake(0.5, 1);
//    shapeLayer.frame = CGRectMake(0, 0, 200, 100);
//    shapeLayer.contents = (__bridge id)[UIImage imageNamed:@"invert"].CGImage;
//    [layer addSublayer:shapeLayer];
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
