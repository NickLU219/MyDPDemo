//
//  NKBusiness.h
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/25.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKBusiness : NSObject
/**  商家名 */
@property (nonatomic, strong) NSString *name;
/**  <#PS#> */
@property (nonatomic, strong) NSNumber *id;
/**  city */
@property (nonatomic, strong) NSString *city;
/**  <#PS#> */
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

/**  url */
@property (nonatomic, strong) NSString *url;
/**  h5 */
@property (nonatomic, strong) NSString *h5_url;
@end
