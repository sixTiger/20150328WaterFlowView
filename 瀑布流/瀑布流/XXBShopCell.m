//
//  XXBShopCell.m
//  瀑布流
//
//  Created by 杨小兵 on 15/3/27.
//  Copyright (c) 2015年 xiaoxiaobing. All rights reserved.
//

#import "XXBShopCell.h"
#import "XXBWaterFlowView.h"
#import "UIImageView+WebCache.h"
#import "XXBShop.h"

@interface XXBShopCell ()

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *priceLabel;
@end
@implementation XXBShopCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *priceLabel = [[UILabel alloc] init];
        priceLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        priceLabel.textColor = [UIColor whiteColor];
        [self addSubview:priceLabel];
        self.priceLabel = priceLabel;
    }
    return self;
}

- (void)setShop:(XXBShop *)shop
{
    _shop = shop;
    
    self.priceLabel.text = shop.price;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
    
    CGFloat priceX = 0;
    CGFloat priceH = 25;
    CGFloat priceY = self.bounds.size.height - priceH;
    CGFloat priceW = self.bounds.size.width;
    self.priceLabel.frame = CGRectMake(priceX, priceY, priceW, priceH);
}
@end
