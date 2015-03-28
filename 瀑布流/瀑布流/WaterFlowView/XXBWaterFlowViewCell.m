//
//  XXBWaterFlowViewCell.m
//  瀑布流
//
//  Created by 杨小兵 on 15/3/27.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBWaterFlowViewCell.h"
#import "XXBWaterFlowView.h"

@implementation XXBWaterFlowViewCell
+ (instancetype)cellWithWaterFlowView:(XXBWaterFlowView *)waterFlowView
{
    static NSString *ID = @"XXBWaterViewCell";
    XXBWaterFlowViewCell *cell = [waterFlowView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[self alloc] init];
        cell.identifier = ID;
    }
    return cell;
}
@end
