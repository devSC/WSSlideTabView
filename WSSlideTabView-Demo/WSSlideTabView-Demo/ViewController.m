//
//  ViewController.m
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "ViewController.h"
#import "WSSlideTabView.h"

#import "WSAnimationTabView.h"
#import "WSAnimationItemModel.h"


@interface ViewController ()<WSAnimationTabViewDelegate>

@property (weak, nonatomic) IBOutlet WSAnimationTabView *nibTabView;

@end

@implementation ViewController
{
    WSSlideTabView *slideTabView;
    WSAnimationTabView *animationTabView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *array = @[@"全部分类", @"美食园艺", @"旧物改造", @"粘土/陶艺", @"刺绣编织", @"创意DIY", @"手工皮具", @"羊毛毡", @"电子科技", @"美容护肤"];
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (NSString *str in array) {
        WSAnimationItemModel *model = [[WSAnimationItemModel alloc] init];
        model.titleName = str;
        [mArray addObject:model];
    }
    
    slideTabView = [[WSSlideTabView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 44)];
    [self.view addSubview:slideTabView];
    
    [slideTabView setSlideModels:array];
    
    animationTabView = [[WSAnimationTabView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 44)];
    [self.view addSubview:animationTabView];
//    animationTabView.delegate = self;

    
    [animationTabView setTabModelArray:mArray];
    


    
}
- (IBAction)changeItem:(id)sender {
        
    NSArray *array = @[@"全部分类", @"美食园艺", @"旧物改造", @"粘土/陶艺", @"刺绣编织", @"创意DIY", @"手工皮具", @"羊毛毡", @"电子科技", @"美容护肤"];
    
    NSMutableArray *mArray = [NSMutableArray array];
    
    for (NSString *str in array) {
        WSAnimationItemModel *model = [[WSAnimationItemModel alloc] init];
        model.titleName = str;
        [mArray addObject:model];
    }

//    [mArray removeObjectAtIndex:arc];
//    [animationTabView setTabModelArray:mArray];
    //    [animationTabView setItemWidth:67];
//    [animationTabView setTabModelArray:mArray];
    [self.nibTabView setTabModelArray:mArray];
}

- (void)animationTabViewDidSelectedItem:(id<WSAnimationItemProtocol>)item
{
    WSAnimationItemModel *model = item;
    NSLog(@"item: %@", model.titleName);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
