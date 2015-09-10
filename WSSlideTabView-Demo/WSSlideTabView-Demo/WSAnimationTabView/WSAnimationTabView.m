//
//  WSAnimationTabView.m
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "WSAnimationTabView.h"

#import "WSAnimationItemView.h"

#import "WSAnimationTabButton.h"

@interface WSAnimationTabView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, strong) NSArray *modelArray;

@end

static NSInteger WSAnimationTabViewItemTag = 101;

@implementation WSAnimationTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加ScrollView
        [self addSubview:self.scrollView];
        
    }
    return self;
}

- (void)itemTabButtonDidTapped: (WSAnimationItemView *)tabBtn
{

}

- (void)setTabModelArray:(NSArray *)array
{
    self.modelArray = array;
    
    [self refreshView];
}

- (void)refreshView
{
    //Remove All subviews
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        [view removeFromSuperview];
    }];
    
    
    //reset contentSize
    [self.scrollView setContentSize:CGSizeMake(_itemWidth * self.modelArray.count, self.bounds.size.height)];
    
    //set buttons
    [self.modelArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        WSAnimationItemView *itemView = [[WSAnimationItemView alloc] initWithFrame:CGRectMake(idx * self.itemWidth, 0, self.itemWidth, self.bounds.size.height)];
        itemView.tag = WSAnimationTabViewItemTag + idx;
        [itemView addTarget:self action:@selector(itemTabButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        [itemView setItemTitle:self.modelArray[idx]];
        [self.scrollView addSubview:itemView];
        NSLog(@"%@", itemView);
        
    }];
    

    //set

}


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
    }
    return _scrollView;
}


- (UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] init];
    }
    return _indicatorView;
}
@end
