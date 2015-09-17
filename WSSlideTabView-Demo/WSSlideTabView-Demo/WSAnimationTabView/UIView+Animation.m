//
//  UIView+Animation.m
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/17.
//  Copyright © 2015年 wilson-yuan. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)


+ (void)wsAnimateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        [UIView animateWithDuration:duration delay:delay usingSpringWithDamping:dampingRatio initialSpringVelocity:velocity options:options animations:animations completion:completion];
    } else {
        [UIView animateWithDuration:duration delay:delay options:options animations:animations completion:completion];
    }

}


@end
