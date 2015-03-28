//
//  ViewController.m
//  瀑布流
//
//  Created by 杨小兵 on 15/3/27.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "ViewController.h"

#import "XXBWaterFlowView.h"
#import "XXBShopCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "XXBShop.h"

@interface ViewController ()<XXBWaterFlowViewDelegate,XXBWaterFlowViewDataSource>
@property (nonatomic, strong) NSMutableArray *shops;
@property (nonatomic, weak) XXBWaterFlowView *waterflowView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 0.初始化数据
    NSArray *newShops = [XXBShop objectArrayWithFilename:@"2.plist"];
    [self.shops addObjectsFromArray:newShops];
    
    // 1.瀑布流控件
    XXBWaterFlowView *waterflowView = [[XXBWaterFlowView alloc] init];
    waterflowView.backgroundColor = [UIColor redColor];
    // 跟随着父控件的尺寸而自动伸缩
    waterflowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    waterflowView.frame = self.view.bounds;
    waterflowView.dataSource = self;
    waterflowView.delegate = self;
    [self.view addSubview:waterflowView];
    self.waterflowView = waterflowView;
    
    // 2.继承刷新控件
    //    [waterflowView addFooterWithCallback:^{
    //        NSLog(@"进入上拉加载状态");
    //    }];
    
    //    [waterflowView addHeaderWithCallback:^{
    //        NSLog(@"进入下拉加载状态");
    //    }];
    
    [waterflowView addHeaderWithTarget:self action:@selector(loadNewShops)];
    [waterflowView addFooterWithTarget:self action:@selector(loadMoreShops)];
}
- (void)loadNewShops
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 加载1.plist
        NSArray *newShops = [XXBShop objectArrayWithFilename:@"1.plist"];
        [self.shops insertObjects:newShops atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newShops.count)]];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新瀑布流控件
        [self.waterflowView reloadData];
        
        // 停止刷新
        [self.waterflowView headerEndRefreshing];
    });
}

- (void)loadMoreShops
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 加载3.plist
        NSArray *newShops = [XXBShop objectArrayWithFilename:@"3.plist"];
        [self.shops addObjectsFromArray:newShops];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 刷新瀑布流控件
        [self.waterflowView reloadData];
        
        // 停止刷新
        [self.waterflowView footerEndRefreshing];
    });
}

#pragma mark - 数据源方法
- (NSInteger)numberOfCellsInWaterFlowView:(XXBWaterFlowView *)waterFlowView
{
    return self.shops.count;
}

- (XXBWaterFlowViewCell *)waterFlowView:(XXBWaterFlowView *)waterFlowView cellAtIndex:(NSUInteger)index
{
    XXBShopCell *cell = [XXBShopCell cellWithWaterFlowView:waterFlowView];
    
    cell.shop = self.shops[index];
    NSLog(@"%@ %p",cell.identifier,cell);
    return cell;
}

- (NSUInteger)numberOfColumnsInWaterFlowView:(XXBWaterFlowView *)waterFlowView
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
    {
        // 竖屏
        return 3;
    }
    else
    {
        return 5;
    }
}

#pragma mark - 代理方法
- (CGFloat)waterFlowView:(XXBWaterFlowView *)waterFlowView heightAtIndex:(NSUInteger)index
{
    XXBShop *shop = self.shops[index];
    // 根据cell的宽度 和 图片的宽高比 算出 cell的高度
    return waterFlowView.cellWidth * shop.h / shop.w;
}
- (void)waterFlowView:(XXBWaterFlowView *)waterFlowView didSelectAtIndex:(NSUInteger)index
{
    NSLog(@"%@",@(index));
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //    NSLog(@"屏幕旋转完毕");
    [self.waterflowView reloadData];
}
- (NSMutableArray *)shops
{
    if (_shops == nil) {
        self.shops = [NSMutableArray array];
    }
    return _shops;
}
@end
