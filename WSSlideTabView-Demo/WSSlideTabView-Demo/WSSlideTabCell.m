//
//  WSSlideTabCell.m
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "WSSlideTabCell.h"

@implementation WSSlideTabCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.layer.cornerRadius = 30 / 2;
    self.titleLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        self.titleLabel.backgroundColor = [UIColor redColor];
        self.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        self.titleLabel.textColor = [UIColor redColor];
    }
}
@end
