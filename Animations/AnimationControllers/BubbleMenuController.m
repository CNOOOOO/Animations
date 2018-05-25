//
//  BubbleMenuController.m
//  Animations
//
//  Created by Mac1 on 2018/5/15.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "BubbleMenuController.h"
#import "BubbleMenu.h"

@interface BubbleMenuController ()

@property (nonatomic, strong) NSArray *buttonTitles;//按钮标题
@property (nonatomic, strong) BubbleMenu *bubbleMenu;//气泡菜单
@property (nonatomic, strong) NSMutableArray *chooseButtons;//方向选择按钮

@end

@implementation BubbleMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"气泡菜单";
    self.buttonTitles = @[@"上",@"左",@"下",@"右"];
    [self addBubbleMenu];
    [self addChooseDirectionButtons];
}

- (void)addBubbleMenu {
    [self.bubbleMenu removeFromSuperview];
    UIImageView *homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chooser-button"]];
    homeImageView.frame = CGRectMake(0, 0, 40, 40);
    self.bubbleMenu = [[BubbleMenu alloc] initWithFrame:CGRectMake(VIEW_WIDTH * 0.5 - 20, VIEW_HEIGHT * 0.5 - 80, 40, 40) expansionDirection:DirectionTop];
    self.bubbleMenu.homeButtonView = homeImageView;
    [self.bubbleMenu addButtons:[self createButtons]];
    [self.view addSubview:self.bubbleMenu];
}

- (void)addChooseDirectionButtons {
    self.chooseButtons = [NSMutableArray array];
    UIButton *preButton;
    for (int i = 0; i < self.buttonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1000 + i;
        [button setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
        [button setTitle:self.buttonTitles[i] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor colorWithWhite:0 alpha:0.1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.layer.borderColor = [UIColor blackColor].CGColor;
        button.layer.borderWidth = 0.5;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseButtons addObject:button];
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
            [self.bubbleMenu collapseButtons];
            self.bubbleMenu.direction = DirectionTop;
            break;
        case 1001:
            [self.bubbleMenu collapseButtons];
            self.bubbleMenu.direction = DirectionLeft;
            break;
        case 1002:
            [self.bubbleMenu collapseButtons];
            self.bubbleMenu.direction = DirectionBottom;
            break;
        case 1003:
            [self.bubbleMenu collapseButtons];
            self.bubbleMenu.direction = DirectionRight;
            break;
        default:
            break;
    }
    for (UIButton *button in self.chooseButtons) {
        if (button.tag == sender.tag) {
            button.selected = YES;
        }else {
            button.selected = NO;
        }
    }
}

- (NSArray *)createButtons {
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    int i = 0;
    for (NSString *title in @[@"A", @"B", @"C"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
        button.clipsToBounds = YES;
        button.layer.cornerRadius = button.frame.size.height / 2.f;
        button.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.5f];
        button.tag = i++;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];
    }
    return [buttons copy];
}

- (void)buttonClick:(UIButton *)button {
    NSLog(@"button:%ld被点击",(long)button.tag);
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
