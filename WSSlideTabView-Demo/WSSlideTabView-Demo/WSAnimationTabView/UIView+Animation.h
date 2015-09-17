//
//  UIView+Animation.h
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/17.
//  Copyright © 2015年 wilson-yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

+ (void)wsAnimateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;


@end
