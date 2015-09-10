//
//  WSAnimationItemView.m
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "WSAnimationItemView.h"

@interface WSAnimationItemView ()

@property (nonatomic, strong) WSAnimationTabButton *tabButton;

@end

@implementation WSAnimationItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        [self addSubview:self.tabButton];
//        self.backgroundColor = [UIColor blueColor];

    }
    return self;
}


- (void)setItemTitle:(NSString *)title
{
    [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    
}

#pragma mark - Init


@end
