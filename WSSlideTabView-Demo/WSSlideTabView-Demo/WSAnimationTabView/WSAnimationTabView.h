//
//  WSAnimationTabView.h
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSAnimationTabView : UIView

//@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, strong) UIFont *animationLabelFont;


- (void)setTabModelArray: (NSArray *)array;

@end

@protocol WSAnimationTabViewDelegate <NSObject>

//- (void)wstabViewDidSelectedItem: ()

@end
