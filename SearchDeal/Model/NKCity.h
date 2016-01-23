//
//  NKCity.h
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKRegion.h"

@interface NKCity : NSObject
/**
 *  name
 */
@property (nonatomic, copy) NSString *name;
/**
 *  pinyin
 */
@property (nonatomic, copy) NSString *pinYin;
/**
 *  pinyinHead
 */
@property (nonatomic, copy) NSString *pinYinHead;
/**
 *  regions
 */
@property (nonatomic, copy) NSArray<NKRegion *> *regions;



@end
