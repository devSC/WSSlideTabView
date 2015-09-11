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

#import "WSAnimationIndicatorView.h"

#import "UIView+Utils.h"

@interface WSAnimationTabView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) WSAnimationIndicatorView *indicatorView;

@property (nonatomic, strong) NSArray *modelArray;

@property (nonatomic, strong) NSMutableArray *itemWidthArray;

@end

static NSInteger WSAnimationTabViewItemTag = 101;

@implementation WSAnimationTabView
{
    CGFloat _totalWidth;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加ScrollView
        
        self.animationLabelFont = [UIFont systemFontOfSize:12];
        [self addSubview:self.scrollView];
        
    }
    return self;
}

- (void)itemDidTapped: (WSAnimationItemView *)item
{
    
    //滑动时判断是否可以制中
    CGFloat leftEdge =  self.scrollView.centerX;
    CGFloat rightEdge = (self.scrollView.contentSize.width - self.scrollView.centerX);
    
    if (item.centerX >= leftEdge && item.centerX <= rightEdge) {
        [self.scrollView setContentOffset:CGPointMake(item.centerX - self.scrollView.centerX, 0) animated:YES];
    } else if (item.centerX > rightEdge){
        
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.scrollView.width, 0) animated:YES];
    } else if (item.centerX < leftEdge) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.indicatorView setFrame:item.frame];
    } completion:^(BOOL finished) {
        
    }];

    
}

- (void)setTabModelArray:(NSArray *)array
{
    self.modelArray = array;
    
    [self refreshView];
}

- (void)refreshView
{
    
#if DEBUG
    NSAssert(self.modelArray.count > 0, @"这里数组不能为空");
#endif
    
    //Remove All subviews
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        [view removeFromSuperview];
    }];
    
    //Remove all cache width
    [self.itemWidthArray removeAllObjects];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //calculate item width
    __block CGFloat totalWidth = 0;
    [self.modelArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *itemTitle = self.modelArray[idx];
        CGFloat itemWidth = [self itemWidthWithContentString:itemTitle font:self.animationLabelFont];
        //get the .2 point value
        itemWidth = [[NSString stringWithFormat:@"%.0f", itemWidth] floatValue];
        [self.itemWidthArray addObject:@(itemWidth)];
        totalWidth += itemWidth;
    }];
    
    //reset contentSize
    [self.scrollView setContentSize:CGSizeMake(totalWidth, self.height)];
    
    //add indicator view
    [self.scrollView addSubview:self.indicatorView];
    
    //set default indicator view
    [self.indicatorView setFrame:CGRectMake(0, 0, [[self.itemWidthArray firstObject] floatValue], self.height)];
    
    //set buttons
    [self.modelArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGFloat itemWidth = [self itemWidthAtIndex:idx];
        CGFloat xOffset = 0;
        if (idx > 0) {
            xOffset = [self xOffsetAtIndex:(idx - 1)];
        }

        //Item view
        WSAnimationItemView *itemView = [[WSAnimationItemView alloc] initWithFrame:CGRectMake(xOffset, 0, itemWidth, self.height)];
//        WSAnimationItemView *itemView = [[WSAnimationItemView alloc] initWithFrame:CGRectMake(self.scrollView.contentSize.width, 0, itemWidth, self.height)];
        itemView.tag = WSAnimationTabViewItemTag + idx;
        [itemView addTarget:self action:@selector(itemDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        [itemView setItemTitle:self.modelArray[idx]];
        itemView.alpha = 0;
        
        [self.scrollView addSubview:itemView];
        [UIView animateWithDuration:0.5 animations:^{
            itemView.alpha = 1;
//            itemView.frame = CGRectMake(idx * itemWidth, 0, itemWidth, self.height);
        }];
    }];
    
}


///Reture xOffset
- (CGFloat)xOffsetAtIndex: (NSInteger)index
{
    __block CGFloat xOffset = 0;
    [self.itemWidthArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx > index) {
            *stop = YES;
        } else {
            xOffset += [obj floatValue];
        }
    }];
    return xOffset;
}
- (CGFloat)itemWidthWithContentString: (NSString *)string font: (UIFont *)font
{
    CGSize constraintSize = CGSizeMake([self valueByScreenScale:200], [self valueByScreenScale:300]);
    
    CGSize contentTextSize = CGSizeZero;
    // > iOS7
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        contentTextSize = [string boundingRectWithSize:constraintSize
                                                            options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                                         attributes:@{NSFontAttributeName: font}
                                                            context:NULL].size;
        
    } else {
        CGSize stringSize;
        if ([string respondsToSelector:@selector(sizeWithAttributes:)]){
            stringSize = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:font.fontName size:font.pointSize]}];
        } else {
#pragma clang diagnostic ignored "-Wdeprecated"
            stringSize = [string sizeWithFont:font constrainedToSize:constraintSize];
        }
        contentTextSize = stringSize;
    }
    return contentTextSize.width + 30;
}

- (CGFloat)valueByScreenScale: (CGFloat)value
{
    return ([UIScreen mainScreen].bounds.size.width / 320 * value);
}


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [UIColor orangeColor];
    }
    return _scrollView;
}

- (WSAnimationIndicatorView *)indicatorView
{
    if (!_indicatorView) {
#if DEBUG
        NSAssert(self.itemWidthArray.count > 0, @"the itemWidthArray count must > 0");
#endif
        _indicatorView = [[WSAnimationIndicatorView alloc] initWithFrame:CGRectMake(0, 0, [self itemWidthAtIndex:0] , self.height)];
    }
    return _indicatorView;
}

- (CGFloat)itemWidthAtIndex: (NSInteger)index
{
    return [self.itemWidthArray[index] floatValue];
}

- (NSMutableArray *)itemWidthArray
{
    if (!_itemWidthArray) {
        _itemWidthArray = [NSMutableArray array];
    }
    return _itemWidthArray;
}
@end
