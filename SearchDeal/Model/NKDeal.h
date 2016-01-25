//
//  NKDeal.h
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKBusiness.h"

@interface NKDeal : NSObject
//decription是NSObject一个只读属性；
@property (nonatomic, strong) NSString *title;
//订单详细描述
@property (nonatomic, strong) NSString *desc;//description --> desc
//优惠前价格 NSNumber: 保证和服务器返回的一模一样
@property (nonatomic, strong) NSNumber *list_price;
//优惠后的价格(团购价格)
@property (nonatomic, strong) NSNumber *current_price;
//购买数量
@property (nonatomic, assign) int purchase_count;
//团购订单的小图对应的url
@property (nonatomic, strong) NSString *s_image_url;

/**  business */
@property (nonatomic, strong) NSArray<NKBusiness *> *businesses;

/**  分类 */
@property (nonatomic, strong) NSArray<NSString *> *categories;
@end
