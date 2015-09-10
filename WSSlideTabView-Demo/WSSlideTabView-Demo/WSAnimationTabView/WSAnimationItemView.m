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
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        //set title color
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
    }
    return self;
}


- (void)setItemTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
    
}
//- (CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    return CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//}
#pragma mark - Init


@end
