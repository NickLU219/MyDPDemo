//
//  NKDataManager.h
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKCity.h"
#import "NKCategory.h"
#import "NKDeal.h"
#import "NKRegion.h"
#import "NKCityGroups.h"
#import "NKSorts.h"


@interface NKDataManager : NSObject

+ (NSArray *)parseDealJson:(id)result;

/**
 *  返回分类数组(NKCategory模型对象)
 */
+ (NSArray<NKCategory *> *)getAllCategory;
/**
 *  返回城市数组(NKCity模型对象)
 */
+ (NSArray<NKCity *> *)getAllCity;
/**
 *  返回指定城市的区域
 */
+ (NSArray<NKRegion *> *)getAllRegionWithCityName:(NSString *)cityName;
/**
 *  返回指定城市组
 */
+ (NSArray<NKCityGroups *> *)getAllCityGroups;
/**
 *  返回排序方式组
 */
+ (NSArray<NKSorts *> *)getAllSorts;
@end
