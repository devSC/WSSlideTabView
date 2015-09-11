//
//  WSAnimationItemView.h
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSAnimationTabButton.h"

@interface WSAnimationItemView : WSAnimationTabButton

///Set Button font
@property (nonatomic, strong) UIFont *itemViewFont; //Default System 12 size

@property (nonatomic, strong) UIColor *normalTitleColor; //Default red color

@property (nonatomic, strong) UIColor *selectTitleColor; //Default white color

- (void)setItemTitle: (NSString *)title;

@end
