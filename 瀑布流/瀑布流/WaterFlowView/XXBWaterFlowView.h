//
//  XXBWaterFlowView.h
//  瀑布流
//
//  Created by 杨小兵 on 15/3/27.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XXBWaterFlowViewMarginTypeTop,
    XXBWaterFlowViewMarginTypeBottom,
    XXBWaterFlowViewMarginTypeLeft,
    XXBWaterFlowViewMarginTypeRight,
    XXBWaterFlowViewMarginTypeColumn, // 每一列
    XXBWaterFlowViewMarginTypeRow, // 每一行
} XXBWaterFlowViewMarginType;

@class XXBWaterFlowView,XXBWaterFlowViewCell;
/**
 *  数据源方法
 */
@protocol XXBWaterFlowViewDataSource <NSObject>
@required
/**
 *  一共有多少个数据
 */
- (NSInteger)numberOfCellsInWaterFlowView:(XXBWaterFlowView *)waterFlowView;
/**
 *  返回index位置对应的cell
 */
- (XXBWaterFlowViewCell *)waterFlowView:(XXBWaterFlowView *)waterFlowView cellAtIndex:(NSUInteger)index;
@optional
/**
 *  一共有多少列
 */
- (NSUInteger)numberOfColumnsInWaterFlowView:(XXBWaterFlowView *)waterFlowView;
@end
/**
 *  代理方法
 */
@protocol XXBWaterFlowViewDelegate <UIScrollViewDelegate>

@optional
/**
 *  第index位置cell对应的高度
 */
- (CGFloat)waterFlowView:(XXBWaterFlowView *)waterFlowView heightAtIndex:(NSUInteger)index;
/**
 *  选中第index位置的cell
 */
- (void)waterFlowView:(XXBWaterFlowView *)waterFlowView didSelectAtIndex:(NSUInteger)index;
/**
 *  返回间距
 */
- (CGFloat)waterFlowView:(XXBWaterFlowView *)waterFlowView marginForType:(XXBWaterFlowViewMarginType)type;

@end

@interface XXBWaterFlowView : UIScrollView
/**
 *  数据源
 */
@property (nonatomic, weak) id<XXBWaterFlowViewDataSource> dataSource;
/**
 *  代理
 */
@property (nonatomic, weak) id<XXBWaterFlowViewDelegate> delegate;

/**
 *  刷新数据（只要调用这个方法，会重新向数据源和代理发送请求，请求数据）
 */
- (void)reloadData;

/**
 *  cell的宽度
 */
- (CGFloat)cellWidth;

/**
 *  根据标识去缓存池查找可循环利用的cell
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
