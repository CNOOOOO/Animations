//
//  ViewController.m
//  Animations
//
//  Created by Mac1 on 2018/5/11.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "ViewController.h"
#import "BasicAnimationsController.h"
#import "KeyFrameAnimationsController.h"
#import "GroupAnimationsController.h"
#import "TransitionAnimationsController.h"
#import "AffineTransformAnimationController.h"
#import "BubbleMenuController.h"
#import "EmitterAnimationController.h"
#import "ReplicatorAnimationsController.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource> {
    BOOL _ifShow;//是否显示案例
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;//标题数组
@property (nonatomic, strong) NSArray *caseArray;//案例数组
@property (nonatomic, strong) UIView *headerView;//头部视图
@property (nonatomic, strong) UIImageView *arrowImageView;//显示更多箭头

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"动画";
    self.view.backgroundColor = [UIColor whiteColor];
    self.titleArray = @[@"基础动画",@"关键帧动画",@"组动画",@"过渡动画",@"仿射变换"];
    self.caseArray = @[@"气泡菜单",@"粒子动画",@"复制图层"];
    [self initTableView];
}

- (void)initTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.titleArray.count;
    }else {
        if (_ifShow) {
            return self.caseArray.count;
        }else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.text = self.titleArray[indexPath.row];
    }else {
        cell.textLabel.text = self.caseArray[indexPath.row];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (UIView *)headerView {
    if (!_headerView) {
        UIView *headerView = [[UIView alloc] init];
        headerView.backgroundColor = [UIColor whiteColor];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [headerView addSubview:line];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"案例：";
        titleLabel.font = [UIFont systemFontOfSize:15];
        [headerView addSubview:titleLabel];
        [titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-fanhui"]];
        self.arrowImageView.transform = CGAffineTransformIdentity;
        self.arrowImageView.transform = CGAffineTransformMakeRotation(-(M_PI_2));
        [headerView addSubview:self.arrowImageView];
        [self.arrowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
        UIButton *showOrHideButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [showOrHideButton addTarget:self action:@selector(showOrHideCases:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:showOrHideButton];
        [showOrHideButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        _headerView = headerView;
    }
    return _headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return self.headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 45;
    }
    return 0.000000000001;
}

- (void)showOrHideCases:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        _ifShow = YES;
        self.arrowImageView.transform = CGAffineTransformIdentity;
        self.arrowImageView.transform = CGAffineTransformMakeRotation((M_PI_2));
    }else {
        _ifShow = NO;
        self.arrowImageView.transform = CGAffineTransformIdentity;
        self.arrowImageView.transform = CGAffineTransformMakeRotation(-(M_PI_2));
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            BasicAnimationsController *basicController = [[BasicAnimationsController alloc] init];
            [self.navigationController pushViewController:basicController animated:YES];
        }else if (indexPath.row == 1) {
            KeyFrameAnimationsController *keyFrameController = [[KeyFrameAnimationsController alloc] init];
            [self.navigationController pushViewController:keyFrameController animated:YES];
        }else if (indexPath.row == 2) {
            GroupAnimationsController *groupController = [[GroupAnimationsController alloc] init];
            [self.navigationController pushViewController:groupController animated:YES];
        }else if (indexPath.row == 3) {
            TransitionAnimationsController *transitionController = [[TransitionAnimationsController alloc] init];
            [self.navigationController pushViewController:transitionController animated:YES];
        }else {
            AffineTransformAnimationController *affineTransformController = [[AffineTransformAnimationController alloc] init];
            [self.navigationController pushViewController:affineTransformController animated:YES];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            BubbleMenuController *bubbleController = [[BubbleMenuController alloc] init];
            [self.navigationController pushViewController:bubbleController animated:YES];
        }else if (indexPath.row == 1) {
            EmitterAnimationController *emitterController = [[EmitterAnimationController alloc] init];
            [self.navigationController pushViewController:emitterController animated:YES];
        }else if (indexPath.row == 2) {
            ReplicatorAnimationsController *replicatorController = [[ReplicatorAnimationsController alloc] init];
            [self.navigationController pushViewController:replicatorController animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
