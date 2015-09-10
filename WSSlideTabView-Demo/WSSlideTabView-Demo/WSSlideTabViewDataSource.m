//
//  WSSlideTabViewDataSource.m
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "WSSlideTabViewDataSource.h"
#import "WSSlideTabCell.h"
#import "WSSlideTabViewHeader.h"


@interface WSSlideTabViewDataSource ()

@property (nonatomic, strong) NSArray *modelArray;

@property (nonatomic, copy) configureCellBlock configureBlock;

@end

@implementation WSSlideTabViewDataSource

+ (instancetype)sourceWithModels: (NSArray *)models
{
    WSSlideTabViewDataSource *dataSource = [[WSSlideTabViewDataSource alloc] initWithModels:models];
    return dataSource;
}


- (instancetype)initWithModels: (NSArray *)models
{
    if (self = [super init]) {
        
        self.modelArray = models;
        
    }
    return self;
}


- (void)setModels:(NSArray *)models
{
    self.modelArray = models;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WSSlideTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WSSlideTabCellReuseIdentifier forIndexPath:indexPath];
    
    NSAssert(self.configureBlock, @"这里configure必须存在");
    self.configureBlock(cell, indexPath);
    return cell;
}



- (void)cellConfigureBlock:(configureCellBlock)block
{
    if (block) {
        self.configureBlock = block;
    }
    
}
@end
