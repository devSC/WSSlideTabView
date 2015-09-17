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
static NSInteger WSAnimationTabIndicatorViewTag = 99;

@implementation WSAnimationTabView
{
    CGFloat _totalWidth;
    WSAnimationItemView *_lastItemView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        [self configureView];
    }
    return self;
}

///ConfigureView
- (void)configureView
{
    
    self.animationLabelFont = [UIFont systemFontOfSize:12];
    self.selectTitleColor = [UIColor whiteColor];
    self.normalTitleColor = [UIColor redColor];
    self.scrollViewBackgroundColor = [UIColor whiteColor];
    self.indicatorBackgroundColor = [UIColor redColor];
    
    [self addSubview:self.scrollView];

}

- (void)awakeFromNib
{
    [self configureView];
}

- (void)selectItemView: (WSAnimationItemView *)item
{
    _lastItemView.selected = NO;
    
    item.selected = YES;
    
    _lastItemView = item;

}
#pragma mark - Action
- (void)itemDidTapped: (WSAnimationItemView *)item
{
    //
    [self selectItemView:item];
    
    
    
    //invoke delegate method
    if ([_delegate respondsToSelector:@selector(animationTabViewDidSelectedItem:)]) {
        [_delegate animationTabViewDidSelectedItem:self.modelArray[item.tag - WSAnimationTabViewItemTag]];
    }
    
    //Judge to scroll
    CGFloat leftEdge =  self.scrollView.centerX;
    CGFloat rightEdge = (self.scrollView.contentSize.width - self.scrollView.centerX);
    
    if (item.centerX >= leftEdge && item.centerX <= rightEdge) {
        [self.scrollView setContentOffset:CGPointMake(item.centerX - self.scrollView.centerX, 0) animated:YES];
    } else if (item.centerX > rightEdge){
        
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.scrollView.width, 0) animated:YES];
    } else if (item.centerX < leftEdge) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        _lastItemView.titleLabel.textColor = self.normalTitleColor;
        item.titleLabel.textColor = self.selectTitleColor;

        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.indicatorView setFrame:item.frame];
        } completion:^(BOOL finished) {
        }];
    } else {
        _lastItemView.titleLabel.textColor = self.normalTitleColor;
        item.titleLabel.textColor = self.selectTitleColor;

        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.indicatorView setFrame:item.frame];
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Private method
- (void)refreshView
{
    
#if DEBUG
    NSAssert(self.modelArray.count > 0, @"modelArray is nil");
#endif
    NSLog(@"subviewCount: %ld", self.scrollView.subviews.count);
    
    //change tag start number
    WSAnimationTabViewItemTag = WSAnimationTabViewItemTag + 200;

    //Remove All subviews
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        if (view.tag != WSAnimationTabIndicatorViewTag) {
            if (view.frame.origin.x < self.width) {
                if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
                    [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        view.frame = CGRectMake(self.width, 0, view.width, view.height);
                        
                    } completion:^(BOOL finished) {
                        [view removeFromSuperview];
                    }];
                    
                } else {
                    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                        
                        view.frame = CGRectMake(self.width, 0, view.width, view.height);
                    } completion:^(BOOL finished) {
                        [view removeFromSuperview];
                    }];
                }
            } else {
                [view removeFromSuperview];
            }
        } else {
            if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
                [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    view.frame = CGRectMake(self.width, 0, view.width, view.height);
                    
                } completion:^(BOOL finished) {
                }];
                
            } else {
                [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    
                    view.frame = CGRectMake(self.width, 0, view.width, view.height);
                } completion:^(BOOL finished) {
                }];
            }

        }
    }];
    
//    self.indicatorView = nil;
    
    //Remove all cache width
    [self.itemWidthArray removeAllObjects];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //calculate item width
    __block CGFloat totalWidth = 0;
    [self.modelArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        id model = self.modelArray[idx];
        
        //Check up model
        NSAssert([model conformsToProtocol:@protocol(WSAnimationItemProtocol)], @"model must confroms to WSAnimationItemProtocol");
        
        id<WSAnimationItemProtocol> itemModel = model;
        
        CGFloat itemWidth = [self itemWidthWithContentString:itemModel.titleName font:self.animationLabelFont];
        
        //get the .2 point value
        itemWidth = [[NSString stringWithFormat:@"%.0f", itemWidth] floatValue];
        
        [self.itemWidthArray addObject:@(itemWidth)];
        totalWidth += itemWidth;
    }];
    
    //reset contentSize
    [self.scrollView setContentSize:CGSizeMake(totalWidth, self.height)];
    
    if (!self.indicatorView.superview) {
        //add indicator view
        [self.scrollView addSubview:self.indicatorView];
    }
    
    
    //set default indicator view
    
    //set buttons
    [self.modelArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGFloat itemWidth = [self itemWidthAtIndex:idx];
        CGFloat xOffset = 0;
        if (idx > 0) {
            xOffset = [self xOffsetAtIndex:(idx - 1)];
        }
        
        //Item view
        WSAnimationItemView *itemView = [[WSAnimationItemView alloc] initWithFrame:CGRectMake(self.width, 0, itemWidth, self.height)];
        
        itemView.tag = WSAnimationTabViewItemTag + idx;
        
        [itemView addTarget:self action:@selector(itemDidTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        id<WSAnimationItemProtocol> itemModel = self.modelArray[idx];
        [itemView setItemTitle:itemModel.titleName];
        [itemView setItemViewFont:self.animationLabelFont];
        [itemView setNormalTitleColor:self.normalTitleColor];
        [itemView setSelectTitleColor:self.selectTitleColor];
        
        [self.scrollView addSubview:itemView];
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
            [UIView animateWithDuration:0.8 delay:0.2 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                itemView.frame = CGRectMake(xOffset, 0, itemWidth, self.height);
                
            } completion:^(BOOL finished) { }];

        } else {
            [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                
                itemView.frame = CGRectMake(xOffset, 0, itemWidth, self.height);
            } completion:^(BOOL finished) { }];
        }
        
        
        if (idx == 0) {
            if ([_delegate respondsToSelector:@selector(animationTabViewDidSelectedItem:)]) {
                [_delegate animationTabViewDidSelectedItem:itemModel];
            }
            [itemView setSelected:YES];
            _lastItemView = itemView;
            
            if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
                [UIView animateWithDuration:0.5 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [self.indicatorView setFrame:CGRectMake(0, 0, itemWidth, self.height)];
                } completion:^(BOOL finished) { }];
            } else {
                [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    [self.indicatorView setFrame:CGRectMake(0, 0, itemWidth, self.height)];
                } completion:^(BOOL finished) { }];
            }
        }
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


#pragma mark - Setter
- (void)setTabModelArray:(NSArray *)array
{
    self.modelArray = array;
    
    [self refreshView];
}

- (void)setScrollViewBackgroundColor:(UIColor *)scrollViewBackgroundColor
{
    self.scrollView.backgroundColor = scrollViewBackgroundColor;
}

#pragma mark - Getter
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (WSAnimationIndicatorView *)indicatorView
{
    if (!_indicatorView) {
#if DEBUG
        NSAssert(self.itemWidthArray.count > 0, @"the itemWidthArray count must > 0");
#endif
        _indicatorView = [[WSAnimationIndicatorView alloc] initWithFrame:CGRectMake(self.width, 0, [self itemWidthAtIndex:0] , self.height)];
        _indicatorView.tag = WSAnimationTabIndicatorViewTag;
        _indicatorView.cornerBackGroundViewColor = self.indicatorBackgroundColor;

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
