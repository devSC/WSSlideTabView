//
//  WSSlideTabView.m
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "WSSlideTabView.h"
#import "WSSlideTabViewHeader.h"
#import "WSSlideTabCell.h"
#import "WSSlideTabViewDataSource.h"


@interface WSSlideTabView ()<UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

///背景
@property (nonatomic, strong) UICollectionView *backcollectionView;
@property (nonatomic, strong) UIScrollView *backScrollView;


@property (nonatomic, strong) UIView *indicatorView;

//dataSource
@property (nonatomic, strong) WSSlideTabViewDataSource *dataSource;

///存放model
@property (nonatomic, strong) NSArray *modelArray;
@end


@implementation WSSlideTabView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.collectionView];
        
    }
    return self;
}


- (void)awakeFromNib
{

    
}
#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}


- (void)setSlideModels:(NSArray *)slideArray
{
    self.modelArray = slideArray;
    [self.dataSource setModels:slideArray];
    
    //Refresh
    self.backScrollView.contentSize = CGSizeMake(WSSlideTabItemWidth * slideArray.count, self.bounds.size.height);
    
    [self.collectionView reloadData];
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake(WSSlideTabItemWidth + 10, self.bounds.size.height);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.dataSource = self.dataSource;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        //Register Cell
        [_collectionView registerNib:[UINib nibWithNibName:@"WSSlideTabCell" bundle:nil]
          forCellWithReuseIdentifier:WSSlideTabCellReuseIdentifier];
    }
    return _collectionView;
}


- (WSSlideTabViewDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[WSSlideTabViewDataSource alloc] init];
        __weak typeof(self) wSelf = self;
        
        [_dataSource cellConfigureBlock:^(id cell, NSIndexPath *indexPath) {
            WSSlideTabCell *tabCell = cell;
            tabCell.titleLabel.text = wSelf.modelArray[indexPath.item];
        }];
    }
    return _dataSource;
}

- (UIScrollView *)backScrollView
{
    if (!_backScrollView) {
        _backScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    }
    return _backScrollView;
}

- (UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WSSlideTabItemWidth, self.bounds.size.height)];
        _indicatorView.backgroundColor = [UIColor redColor];
        _indicatorView.layer.cornerRadius = (self.bounds.size.height - 10) / 2;
    }
    return _indicatorView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
