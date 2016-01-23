//
//  NKRegion.h
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKRegion : NSObject
/**
 *  name
 */
@property (nonatomic, copy) NSString *name;
/**
 *  subregions
 */
@property (nonatomic, copy) NSArray<NSString *> *subregions;


@end
