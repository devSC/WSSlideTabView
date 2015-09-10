//
//  WSAnimationIndicatorView.m
//  WSSlideTabView-Demo
//
//  Created by Wilson-Yuan on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "WSAnimationIndicatorView.h"
#import "UIView+Utils.h"

@interface WSAnimationIndicatorView ()

@property (nonatomic, strong) UIView *cornerView;

@end

static CGFloat WSAnimationEdgeWidth = 10;
static CGFloat WSAnimationEdgeHeight = 20;

@implementation WSAnimationIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cornerBackGroundViewColor = [UIColor redColor];
        [self addSubview:self.cornerView];
        
    }
    return self;
}


- (UIView *)cornerView
{
    if (!_cornerView) {
        CGFloat cornerViewHeight = self.height - WSAnimationEdgeHeight;
        
        _cornerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width - WSAnimationEdgeWidth , cornerViewHeight)];
        _cornerView.center = self.center;
        _cornerView.backgroundColor = self.cornerBackGroundViewColor;
        _cornerView.layer.cornerRadius = cornerViewHeight / 2;
    }
    return _cornerView;
}

@end
