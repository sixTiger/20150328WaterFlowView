//
//  XXBWaterFlowViewCell.h
//  瀑布流
//
//  Created by 杨小兵 on 15/3/27.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XXBWaterFlowView;
@interface XXBWaterFlowViewCell : UIView

@property (nonatomic, copy) NSString *identifier;

/**
 *  创建有默认标示的cell 标示是 XXBWaterViewCell
 */
+ (instancetype)cellWithWaterFlowView:(XXBWaterFlowView *)waterFlowView;
@end
