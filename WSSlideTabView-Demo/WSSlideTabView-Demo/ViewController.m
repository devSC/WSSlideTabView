//
//  ViewController.m
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "ViewController.h"
#import "WSSlideTabView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *array = @[@"全部分类", @"美食园艺", @"旧物改造", @"全部分类", @"美食园艺", @"旧物改造", @"全部分类", @"美食园艺", @"旧物改造", @"全部分类", @"美食园艺", @"旧物改造"];
    WSSlideTabView *slideTabView = [[WSSlideTabView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 40)];
    [self.view addSubview:slideTabView];
    
    [slideTabView setSlideModels:array];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
