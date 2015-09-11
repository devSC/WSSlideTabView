//
//  WSAnimationTabView.h
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSAnimationItemProtocol.h"

@protocol WSAnimationTabViewDelegate;

@interface WSAnimationTabView : UIView

@property (nonatomic, strong) UIFont *animationLabelFont; //Default is system size 12

@property (nonatomic, strong) UIColor *normalTitleColor; //Default red color

@property (nonatomic, strong) UIColor *selectTitleColor; //Default white color

@property (nonatomic, strong) UIColor *scrollViewBackgroundColor; //Default white

@property (nonatomic, strong) UIColor *indicatorBackgroundColor; //Default red

@property (nonatomic, weak) id<WSAnimationTabViewDelegate> delegate;

- (void)setTabModelArray: (NSArray *)array;

@end

@protocol WSAnimationTabViewDelegate <NSObject>

- (void)animationTabViewDidSelectedItem: (id<WSAnimationItemProtocol>)item;

@end
