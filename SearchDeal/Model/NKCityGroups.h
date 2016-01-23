//
//  NKCityGroups.h
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKCity.h"

@interface NKCityGroups : NSObject
/**
 *  cities
 */
@property (nonatomic, copy) NSArray<NSString *> *cities;
/**
 *  title
 */
@property (nonatomic, copy) NSString *title;
@end
