//
//  NKDataManager.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKDataManager.h"

@implementation NKDataManager
+ (NSArray *)parseDealJson:(id)result {
    NSArray *dealsArray = result[@"deals"];

    return [[self alloc] convertDictionaryToModel:[NKDeal class] withArray:dealsArray];
}

static NSArray<NKCategory *> *_categoryArray = nil;
+ (NSArray<NKCategory *> *)getAllCategory {
    if (!_categoryArray) {
        _categoryArray = [[self alloc] getAllPlistData:@"categories.plist" withClass:[NKCategory class]];
    }
    return _categoryArray;
}
static NSArray<NKCity *> *_cityArray = nil;
+ (NSArray<NKCity *> *)getAllCity {
    if (!_cityArray) {
        _cityArray = [[self alloc] getAllPlistData:@"cities.plist" withClass:[NKCity class]];
    }
    return _cityArray;
}

static NSArray<NKRegion *> *_regionArray = nil;
+ (NSArray<NKRegion *> *)getAllRegionWithCityName:(NSString *)cityName {
    NSArray<NKCity *> *array = [self getAllCity];
    for (NKCity *city in array) {
        if ([city.name isEqualToString: cityName]) {
            _regionArray = [[self alloc] convertDictionaryToModel:[NKRegion class] withArray:city.regions];
        }
    }
    return _regionArray;
}

static NSArray<NKCityGroups *> *_cityGroupsArray = nil;
+ (NSArray<NKCityGroups *> *)getAllCityGroups {
    if (!_cityGroupsArray) {
        _cityGroupsArray = [[self alloc] getAllPlistData:@"cityGroups.plist" withClass:[NKCityGroups class]];
    }
    return _cityGroupsArray;
}

static NSArray<NKSorts *> *_sortsArray = nil;
+ (NSArray<NKSorts *> *)getAllSorts {
    if (!_sortsArray) {
        _sortsArray = [[self alloc] getAllPlistData:@"sorts.plist" withClass:[NKSorts class]];
    }
    return _sortsArray;
}

static NSArray<NKBusiness *> *_businessArray = nil;
+ (NSArray<NKBusiness *> *)getAllBusiness:(NKDeal *)deal {
    if (!_businessArray) {
        _businessArray = [[self alloc] convertDictionaryToModel:[NKBusiness class] withArray:deal.businesses];
    }
    return _businessArray;
}

+ (NKCategory *)getAllCategory:(NKDeal *)deal {
    NSArray<NKCategory *> *categories = [self getAllCategory];
    
    for (NSString *categoryStr in deal.categories) {
        for (NKCategory *category in categories) {
            if ([category.name isEqualToString:categoryStr]) {
                return category;
            }
            if ([category.subcategories containsObject:categoryStr]) {
                return category;
            }
        }
    }
    return nil;
}
#pragma mark - close method
- (NSArray *)getAllPlistData:(NSString *)plistName withClass:(Class)modelClass {
    //获取plist文件的路径
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:nil];
    //获取plist文件的数据NSArray
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];

    return [self convertDictionaryToModel:[modelClass class] withArray:array];
}

//传参Class模型类和要转换的数组; 返回的已经转换好得数组
- (NSArray *)convertDictionaryToModel:(Class)modelClass withArray:(NSArray *)array {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        id newInstance = [modelClass new];
        [newInstance setValuesForKeysWithDictionary:dic];
        [mutableArray addObject:newInstance];
    }
    return [mutableArray copy];
}


@end
