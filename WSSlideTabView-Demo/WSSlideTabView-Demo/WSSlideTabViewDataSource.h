//
//  WSSlideTabViewDataSource.h
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^configureCellBlock) (id cell, NSIndexPath *indexpath);
@interface WSSlideTabViewDataSource : NSObject<UICollectionViewDataSource>
//- (instancetype)initWithModels: (NSArray *)models;
//+ (instancetype)sourceWithModels: (NSArray *)models;

- (void)setModels: (NSArray *)models;

- (void)cellConfigureBlock: (configureCellBlock)block;


@end
