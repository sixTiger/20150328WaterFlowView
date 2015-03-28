//
//  MJFoundation.m
//  MJExtensionExample
//
//  Created by MJ Lee on 14/7/16.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "MJFoundation.h"
#import "MJConst.h"

static NSArray *_foundationClasses;

@implementation MJFoundation

+ (void)initialize
{
    _foundationClasses = @[@"NSObject", @"NSNumber",@"NSArray", @"NSURL", @"NSMutableURL",@"NSMutableArray",@"NSData",@"NSMutableData",@"NSDate",@"NSDictionary",@"NSMutableDictionary",@"NSString",@"NSMutableString",@"NSException"];
}

+ (BOOL)isClassFromFoundation:(Class)c
{
    MJAssertParamNotNil2(c, NO);
    /**
     *  判断数组中是否有 c  那个类
     */
    return [_foundationClasses containsObject:NSStringFromClass(c)];
}
@end
