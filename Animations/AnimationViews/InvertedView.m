//
//  InvertedView.m
//  Animations
//
//  Created by Mac1 on 2018/5/23.
//  Copyright © 2018年 Mac1. All rights reserved.
//

#import "InvertedView.h"

@implementation InvertedView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

+ (Class)layerClass {
    return [CAReplicatorLayer class];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
