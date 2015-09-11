//
//  WSAnimationItemView.m
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "WSAnimationItemView.h"

@interface WSAnimationItemView ()

//@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation WSAnimationItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //set font
//        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        //set title color
//        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
    }
    return self;
}

- (void)setItemViewFont:(UIFont *)itemViewFont
{
    [self.titleLabel setFont:itemViewFont];
}

- (void)setSelectTitleColor:(UIColor *)selectTitleColor
{
    [self setTitleColor:selectTitleColor forState:UIControlStateSelected];

}

- (void)setNormalTitleColor:(UIColor *)normalTitleColor
{
    [self setTitleColor:normalTitleColor forState:UIControlStateNormal];
}

- (void)setItemTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return contentRect;
}
#pragma mark - Init


@end
