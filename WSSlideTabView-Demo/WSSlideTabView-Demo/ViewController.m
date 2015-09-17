//
//  ViewController.m
//  WSSlideTabView-Demo
//
//  Created by YSC on 15/9/10.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "ViewController.h"

#import "WSAnimationTabView.h"
#import "WSAnimationItemModel.h"


@interface ViewController ()<WSAnimationTabViewDelegate>

@property (weak, nonatomic) IBOutlet WSAnimationTabView *nibTabView;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *yellowView;

@end
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
@implementation ViewController
{
    WSAnimationTabView *animationTabView;
    NSMutableArray *mArray;
    WSAnimationItemModel *currentModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.redView.layer.mask = self.yellowView.layer;

    
    
    NSArray *array = @[@"Top", @"Entertain", @"Biz", @"Tech", @"World", @"Social", @"TIME", @"Atlanta", @"China", @"Beijing"];
//    NSArray *array = @[@"Top", @"Entertain", @"Biz"];
    
    mArray = [NSMutableArray array];
    
    for (NSString *str in array) {
        WSAnimationItemModel *model = [[WSAnimationItemModel alloc] init];
        model.titleName = str;
        [mArray addObject:model];
    }
    
    animationTabView = [[WSAnimationTabView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 44)];
    [self.view addSubview:animationTabView];
    animationTabView.delegate = self;

    
    [animationTabView setTabModelArray:mArray];
    
    
    
//    UIButton * _maskButton = [[UIButton alloc] init];
//    [_maskButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    [_maskButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:1]];
//    [self.view addSubview:_maskButton];
//    
//    UIView *rview = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 200, 200)];
//    rview.backgroundColor = [UIColor redColor];
//    [_maskButton addSubview:rview];
//    
//    //create path
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    
//    // MARK: circlePath
//    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH / 2, 300) radius:100 startAngle:0 endAngle:2*M_PI clockwise:NO]];
//    
//    // MARK: roundRectanglePath
//    //    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(20, 400, SCREEN_WIDTH - 22 * 20, 100) cornerRadius:15] bezierPathByReversingPath]];
//    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    
//    shapeLayer.path = path.CGPath;
//    
//    UIView *yelloView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 200, 200)];
//    yelloView.backgroundColor = [UIColor yellowColor];
//    
//    //
//    _maskButton.layer.mask = yelloView.layer;
//    [_maskButton.layer setMask:shapeLayer];
    
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
- (IBAction)deleteItem:(id)sender {
    
//    NSUInteger index = arc4random() % mArray.count;
    
//    WSAnimationItemModel *model = mArray[index];
    
//    [animationTabView deleteItem:currentModel];
    [animationTabView deleteSelectItem:currentModel];
    
    [mArray removeObject:currentModel];
}

- (void)animationTabViewDidSelectedItem:(id<WSAnimationItemProtocol>)item
{
    currentModel = item;
    NSLog(@"select title: %@", currentModel.titleName);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
