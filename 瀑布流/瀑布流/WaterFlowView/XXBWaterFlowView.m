//
//  XXBWaterFlowView.m
//  瀑布流
//
//  Created by 杨小兵 on 15/3/27.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBWaterFlowView.h"
#import "XXBWaterFlowViewCell.h"

#define XXBWaterFlowViewDefaultCellH 70
#define XXBWaterFlowViewDefaultMargin 8
#define XXBWaterFlowViewDefaultNumberOfColumns 3

@interface XXBWaterFlowView ()
/**
 *  所有cell的frame数据
 */
@property (nonatomic, strong) NSMutableArray *cellFrames;
/**
 *  正在展示的cell
 */
@property (nonatomic, strong) NSMutableDictionary *displayingCells;
/**
 *  缓存池用字典包裹一层Set
 */
@property(nonatomic , strong)NSMutableDictionary *reusableCellDict;
@end

@implementation XXBWaterFlowView

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self reloadData];
}
/**
 *  刷新数据
 */
- (void)reloadData
{
    // 清空之前的所有数据
    // 移除正在正在显示cell
    [self.displayingCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayingCells removeAllObjects];
    [self.cellFrames removeAllObjects];
    [self.reusableCellDict removeAllObjects];
    
    // cell的总数
    NSInteger numberOfCells = [self.dataSource numberOfCellsInWaterFlowView:self];
    
    // 总列数
    NSInteger numberOfColumns = [self numberOfColumns];
    
    // 间距
    CGFloat topM = [self marginForType:XXBWaterFlowViewMarginTypeTop];
    CGFloat bottomM = [self marginForType:XXBWaterFlowViewMarginTypeBottom];
    CGFloat leftM = [self marginForType:XXBWaterFlowViewMarginTypeLeft];
    CGFloat columnM = [self marginForType:XXBWaterFlowViewMarginTypeColumn];
    CGFloat rowM = [self marginForType:XXBWaterFlowViewMarginTypeRow];
    
    // cell的宽度
    CGFloat cellW = [self cellWidth];
    
    // 用一个C语言数组存放所有列的最大Y值
    CGFloat maxYOfColumns[numberOfColumns];
    for (int i = 0; i<numberOfColumns; i++)
    {
        maxYOfColumns[i] = 0.0;
    }
    memset(maxYOfColumns, 0, sizeof(maxYOfColumns));
    
    // 计算所有cell的frame
    for (int i = 0; i<numberOfCells; i++)
    {
        // cell处在第几列(最短的一列)
        NSUInteger cellColumn = 0;
        // cell所处那列的最大Y值(最短那一列的最大Y值)
        CGFloat maxYOfCellColumn = maxYOfColumns[cellColumn];
        // 求出最短的一列
        for (int j = 1; j<numberOfColumns; j++)
        {
            if (maxYOfColumns[j] < maxYOfCellColumn)
            {
                cellColumn = j;
                maxYOfCellColumn = maxYOfColumns[j];
            }
        }
        
        // 询问代理i位置的高度
        CGFloat cellH = [self heightAtIndex:i];
        
        // cell的位置
        CGFloat cellX = leftM + cellColumn * (cellW + columnM);
        CGFloat cellY = 0;
        if (maxYOfCellColumn == 0.0)
        { // 首行
            cellY = topM;
        }
        else
        {
            cellY = maxYOfCellColumn + rowM;
        }
        
        // 添加frame到数组中
        CGRect cellFrame = CGRectMake(cellX, cellY, cellW, cellH);
        [self.cellFrames addObject:[NSValue valueWithCGRect:cellFrame]];
        
        // 更新最短那一列的最大Y值
        maxYOfColumns[cellColumn] = CGRectGetMaxY(cellFrame);
    }
    
    // 设置contentSize
    CGFloat contentH = maxYOfColumns[0];
    for (int j = 1; j<numberOfColumns; j++)
    {
        if (maxYOfColumns[j] > contentH)
        {
            contentH = maxYOfColumns[j];
        }
    }
    contentH += bottomM;
    self.contentSize = CGSizeMake(0, contentH);
}

/**
 *  当UIScrollView滚动的时候也会调用这个方法
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 向数据源索要对应位置的cell
    NSUInteger numberOfCells = self.cellFrames.count;
    for (int i = 0; i<numberOfCells; i++)
    {
        // 取出i位置的frame
        CGRect cellFrame = [self.cellFrames[i] CGRectValue];
        
        // 优先从字典中取出i位置的cell
        XXBWaterFlowViewCell *cell = self.displayingCells[@(i)];
        
        // 判断i位置对应的frame在不在屏幕上（能否看见）
        if ([self isInScreen:cellFrame])
        { // 在屏幕上
            if (cell == nil) {
                cell = [self.dataSource waterFlowView:self cellAtIndex:i];
                cell.frame = cellFrame;
                [self addSubview:cell];
                
                // 存放到字典中
                self.displayingCells[@(i)] = cell;
            }
        }
        else
        {  // 不在屏幕上
            if (cell)
            {
                // 从scrollView和字典中移除
                [cell removeFromSuperview];
                [self.displayingCells removeObjectForKey:@(i)];
                if(cell.identifier)
                {
                    // 有标示的 存放进缓存池
                    NSMutableSet *cellSet = [self.reusableCellDict valueForKey:cell.identifier];
                    if (cellSet == nil)
                    {
                        cellSet = [NSMutableSet set];
                        [self.reusableCellDict setValue:cellSet forKey:cell.identifier];
                        
                    }
                    [cellSet addObject:cell];
                }
                
            }
        }
    }
}
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    __block XXBWaterFlowViewCell *reusableCell = nil;
    NSMutableSet *cellSet = [self.reusableCellDict valueForKey:identifier];
    reusableCell = [cellSet anyObject];
    
    if (reusableCell)
    { // 从缓存池中移除
        [cellSet removeObject:reusableCell];
    }
    return reusableCell;
}

#pragma mark - 私有方法
/**
 *  判断一个frame有无显示在屏幕上
 */
- (BOOL)isInScreen:(CGRect)frame
{
    return (CGRectGetMaxY(frame) > self.contentOffset.y) &&
    (CGRectGetMinY(frame) < self.contentOffset.y + self.bounds.size.height);
}

/**
 *  间距
 */
- (CGFloat)marginForType:(XXBWaterFlowViewMarginType)type
{
    if ([self.delegate respondsToSelector:@selector(waterFlowView:marginForType:)])
    {
        return [self.delegate waterFlowView:self marginForType:type];
    } else
    {
        return XXBWaterFlowViewDefaultMargin;
    }
}
/**
 *  总列数
 */
- (NSUInteger)numberOfColumns
{
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsInWaterFlowView:)])
    {
        return [self.dataSource numberOfColumnsInWaterFlowView:self];
    }
    else
    {
        return XXBWaterFlowViewDefaultNumberOfColumns;
    }
}
/**
 *  index位置对应的高度
 */

- (CGFloat)heightAtIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(waterFlowView:heightAtIndex:)])
    {
        return [self.delegate waterFlowView:self heightAtIndex:index];
    } else {
        return XXBWaterFlowViewDefaultCellH;
    }
}

#pragma mark - 事件处理
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self.delegate respondsToSelector:@selector(waterFlowView:didSelectAtIndex:)]) return;
    
    // 获得触摸点
    UITouch *touch = [touches anyObject];
    //    CGPoint point = [touch locationInView:touch.view];
    CGPoint point = [touch locationInView:self];
    
    __block NSNumber *selectIndex = nil;
    [self.displayingCells enumerateKeysAndObjectsUsingBlock:^(id key, XXBWaterFlowViewCell *cell, BOOL *stop) {
        if (CGRectContainsPoint(cell.frame, point)) {
            selectIndex = key;
            *stop = YES;
        }
    }];
    if (selectIndex)
    {
        [self.delegate waterFlowView:self didSelectAtIndex:selectIndex.unsignedIntegerValue];
    }
}
/**
 *  cell的宽度
 */
- (CGFloat)cellWidth
{
    // 总列数
    NSInteger numberOfColumns = [self numberOfColumns];
    CGFloat leftM = [self marginForType:XXBWaterFlowViewMarginTypeLeft];
    CGFloat rightM = [self marginForType:XXBWaterFlowViewMarginTypeRight];
    CGFloat columnM = [self marginForType:XXBWaterFlowViewMarginTypeColumn];
    return (self.bounds.size.width - leftM - rightM - (numberOfColumns - 1) * columnM) / numberOfColumns;
}

#pragma -懒加载
- (NSMutableArray *)cellFrames
{
    if (_cellFrames == nil) {
        self.cellFrames = [NSMutableArray array];
    }
    return _cellFrames;
}

- (NSMutableDictionary *)displayingCells
{
    if (_displayingCells == nil) {
        self.displayingCells = [NSMutableDictionary dictionary];
    }
    return _displayingCells;
}
- (NSMutableDictionary *)reusableCellDict
{
    if (_reusableCellDict == nil) {
        _reusableCellDict = [NSMutableDictionary dictionary];
    }
    return _reusableCellDict;
}
@end
