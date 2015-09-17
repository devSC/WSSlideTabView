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

#import "UIView+Animation.h"

@interface WSAnimationTabView ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) WSAnimationIndicatorView *indicatorView;

@property (nonatomic, strong) NSMutableArray *modelArray;

@property (nonatomic, strong) NSMutableArray *itemWidthArray;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic) NSUInteger selectItemIdx;
@end

static NSInteger WSAnimationTabViewItemTag = 101;
static NSInteger WSAnimationTabIndicatorViewTag = 99;
static CGFloat const WSAnimationTabViewSpringDamping = 0.8;
static CGFloat const WSAnimationTabViewSpringVelocity = 0.8;
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
    [self selectItemAtIndex:(item.tag - WSAnimationTabViewItemTag)];
    
    //Judge to scroll
    CGFloat leftEdge =  self.scrollView.centerX;
    CGFloat rightEdge = (self.scrollView.contentSize.width - self.scrollView.centerX);
    
    if (self.scrollView.contentSize.width > self.scrollView.width) {
        if (item.centerX >= leftEdge && item.centerX <= rightEdge) {
            [self.scrollView setContentOffset:CGPointMake(item.centerX - self.scrollView.centerX, 0) animated:YES];
        } else if (item.centerX > rightEdge){
            
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width - self.scrollView.width, 0) animated:YES];
        } else if (item.centerX < leftEdge) {
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
    
    _lastItemView.titleLabel.textColor = self.normalTitleColor;
    item.titleLabel.textColor = self.selectTitleColor;
    
    [UIView wsAnimateWithDuration:0.5 delay:0 usingSpringWithDamping:WSAnimationTabViewSpringDamping initialSpringVelocity:WSAnimationTabViewSpringVelocity options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.indicatorView setFrame:item.frame];
//        self.maskView.frame = item.frame;
        
    } completion:^(BOOL finished) {
        
    }];
}
- (void)deleteSelectItem:(id<WSAnimationItemProtocol>)item
{
    //找到index
    NSUInteger itemIndex = [self.modelArray indexOfObject:item];
    
    //找到tag
    NSUInteger buttonTag = WSAnimationTabViewItemTag + itemIndex;
    //找到这个button
    WSAnimationTabButton *itemBtn = (WSAnimationTabButton *)[self viewWithTag:buttonTag];
    
    //删除这个
    [self.modelArray removeObjectAtIndex:itemIndex];
    [self.itemWidthArray removeObjectAtIndex:itemIndex];
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        itemBtn.alpha = 0;
        
        //调整contentSize
        [self.scrollView setContentSize:CGSizeMake([self scrollViewContentWidth], self.height)];
        
        
    } completion:^(BOOL finished) {
        [itemBtn removeFromSuperview];
        
        //调整tag
        __block NSUInteger index = 0;
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            UIView *view = obj;
            if (view.tag != WSAnimationTabIndicatorViewTag) {
                
                WSAnimationTabButton *tabBtn = obj;
                tabBtn.tag = WSAnimationTabViewItemTag + index;
                index ++;
                
            }
        }];
        
        //其他的向前放
        NSInteger selecteIndex = itemIndex;
        if (itemIndex > (self.modelArray.count - 1)) {
            selecteIndex = self.modelArray.count - 1;
            
            [self adjustItemViewPostionWithIndex:selecteIndex selectedIndex:selecteIndex];
        } else {
            //遍历之后的btn
            for (NSInteger i = itemIndex; i < self.modelArray.count; i ++) {
                [self adjustItemViewPostionWithIndex:i selectedIndex:selecteIndex];
            }
        }
        //选择
        [self selectItemAtIndex:selecteIndex];
    }];
    
    
    
    
}
- (void)adjustItemViewPostionWithIndex: (NSUInteger)index selectedIndex: (NSUInteger)selectIndex
{
    //向前放.
    //找到tag
    NSUInteger buttonTag = WSAnimationTabViewItemTag + index;
    //找到这个button
    WSAnimationTabButton *lastItemBtn = (WSAnimationTabButton *)[self viewWithTag:buttonTag];
    CGFloat xOffset = [self xOffsetAtIndex:(index - 1)];
    CGRect lastRect = lastItemBtn.frame;
    lastRect.origin.x = xOffset;
    [UIView wsAnimateWithDuration:0.5
                            delay:0
           usingSpringWithDamping:WSAnimationTabViewSpringDamping
            initialSpringVelocity:WSAnimationTabViewSpringVelocity
                          options:UIViewAnimationOptionCurveEaseOut
                       animations:^{
                           
                           lastItemBtn.frame = lastRect;
                           
                       } completion:^(BOOL finished) {}];
    
    if (index == selectIndex) {
        
        [UIView wsAnimateWithDuration:0.5
                                delay:0
               usingSpringWithDamping:WSAnimationTabViewSpringDamping
                initialSpringVelocity:WSAnimationTabViewSpringVelocity
                              options:UIViewAnimationOptionCurveEaseOut
                           animations:^{
                               
                               [self.indicatorView setFrame:lastItemBtn.frame];
                               
                           } completion:^(BOOL finished) {
                               
                           }];
    }
    
}



- (void)deleteItem:(id<WSAnimationItemProtocol>)item
{
    //找到index
    NSUInteger itemIndex = [self.modelArray indexOfObject:item];
    
    //找到tag
    NSUInteger buttonTag = WSAnimationTabViewItemTag + itemIndex;
    //找到这个button
    WSAnimationTabButton *itemBtn = (WSAnimationTabButton *)[self viewWithTag:buttonTag];
    
    //    CGFloat itemBtnWidth = [self.itemWidthArray[itemIndex] floatValue];
    
    //删除这个
    [self.modelArray removeObjectAtIndex:itemIndex];
    [self.itemWidthArray removeObjectAtIndex:itemIndex];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        itemBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [itemBtn removeFromSuperview];
        
        //        NSLog(@"contentSize: %@ ", NSStringFromCGSize(self.scrollView.contentSize));
        //调整contentSize
        [self.scrollView setContentSize:CGSizeMake([self scrollViewContentWidth], self.height)];
        //        NSLog(@"new: contentSize: %@ ", NSStringFromCGSize(self.scrollView.contentSize));
        
        //调整tag
        
        __block NSUInteger index = 0;
        [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIView *view = obj;
            if (view.tag != WSAnimationTabIndicatorViewTag) {
                WSAnimationTabButton *tabBtn = obj;
                
                //                NSLog(@"oldtag: %ld",tabBtn.tag);
                tabBtn.tag = WSAnimationTabViewItemTag + index;
                
                //                NSLog(@"newtag: %ld \n\n\n",tabBtn.tag);
                index ++;
            }
        }];
        //其他的向前放
        
        //遍历之后的btn
        for (NSInteger i = itemIndex; i < self.modelArray.count; i ++) {
            //向前放.
            //找到tag
            NSUInteger buttonTag = WSAnimationTabViewItemTag + i;
            //找到这个button
            WSAnimationTabButton *lastItemBtn = (WSAnimationTabButton *)[self viewWithTag:buttonTag];
            CGFloat xOffset = [self xOffsetAtIndex:(i - 1)];
            CGRect lastRect = lastItemBtn.frame;
            lastRect.origin.x = xOffset;
            
            [UIView wsAnimateWithDuration:0.5 delay:0 usingSpringWithDamping:WSAnimationTabViewSpringDamping initialSpringVelocity:WSAnimationTabViewSpringVelocity options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                lastItemBtn.frame = lastRect;
                
            } completion:^(BOOL finished) { }];
            
        }
        
        
    }];
    
    
}
#pragma mark - Private method
- (void)refreshView
{
    
#if DEBUG
    NSAssert(self.modelArray.count > 0, @"modelArray is nil");
#endif
    
    //change tag start number
    WSAnimationTabViewItemTag = WSAnimationTabViewItemTag + 200;
    
    //Remove All subviews
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *view = obj;
        if (view.tag != WSAnimationTabIndicatorViewTag) {
            if (view.frame.origin.x < self.width) {
                [UIView wsAnimateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    view.frame = CGRectMake(self.width, 0, view.width, view.height);
                    
                } completion:^(BOOL finished) {
                    [view removeFromSuperview];
                    
                }];
            } else {
                [view removeFromSuperview];
            }
        } else {
            [UIView wsAnimateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
                view.frame = CGRectMake(self.width, 0, view.width, view.height);
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
    
    //    self.indicatorView = nil;
    
    //Remove all cache width
    [self.itemWidthArray removeAllObjects];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //reset contentSize
    [self.scrollView setContentSize:CGSizeMake([self scrollViewContentWidth], self.height)];
    
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
        
        [UIView wsAnimateWithDuration:0.8 delay:0.2 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            itemView.frame = CGRectMake(xOffset, 0, itemWidth, self.height);
            
        } completion:^(BOOL finished) {
            
        }];
        
        if (idx == 0) {
            
            [self selectItemAtIndex:0];
            
            self.indicatorView.alpha = 0;
            [UIView wsAnimateWithDuration:0.5 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.indicatorView setFrame:CGRectMake(0, 0, itemWidth, self.height)];
                
//                [self.maskView setFrame:CGRectMake(0, 0, itemWidth, self.height)];

                self.indicatorView.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }
    }];
    
    
    
}

- (void)selectItemAtIndex: (NSUInteger)index
{
    if (self.modelArray.count == 0) {
        CGRect indicatorViewFrame = self.indicatorView.frame;
        indicatorViewFrame.origin.x = self.width;
        
        [UIView wsAnimateWithDuration:0.5 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.indicatorView setFrame:indicatorViewFrame];
            self.indicatorView.alpha = 0;
        } completion:^(BOOL finished) {
            if ([_delegate respondsToSelector:@selector(animationTabViewDidDeleteAllItem)]) {
                [_delegate animationTabViewDidDeleteAllItem];
            }
        }];
    } else {
        //得到view
        NSUInteger buttonTag = WSAnimationTabViewItemTag + index;
        id <WSAnimationItemProtocol> itemModel = [self.modelArray objectAtIndex:index];
        
        if ([_delegate respondsToSelector:@selector(animationTabViewDidSelectedItem:)]) {
            [_delegate animationTabViewDidSelectedItem:itemModel];
        }
        if ([_delegate respondsToSelector:@selector(animationTabViewDidSelectedItemAtIndex:)]) {
            [_delegate animationTabViewDidSelectedItemAtIndex:index];
        }
        
        WSAnimationItemView *itemView = (WSAnimationItemView *)[self.scrollView viewWithTag:buttonTag];
        _lastItemView.selected = NO;
        
        itemView.selected = YES;
        
        _lastItemView = itemView;
        
        self.selectItemIdx = index;
    }
}


///Reture xOffset
- (CGFloat)xOffsetAtIndex: (NSInteger)index
{
    if (index < 0) {
        return 0;
    }
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


- (CGFloat)scrollViewContentWidth
{
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
    return totalWidth;
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


- (CGFloat)itemWidthAtIndex: (NSInteger)index
{
    return [self.itemWidthArray[index] floatValue];
}


#pragma mark - Setter
- (void)setTabModelArray:(NSArray *)array
{
    self.modelArray = [array mutableCopy];
    
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
//        _scrollView.layer.mask = self.maskView.layer;
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

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor yellowColor];
    }
    return _maskView;
}


- (NSMutableArray *)itemWidthArray
{
    if (!_itemWidthArray) {
        _itemWidthArray = [NSMutableArray array];
    }
    return _itemWidthArray;
}
@end
