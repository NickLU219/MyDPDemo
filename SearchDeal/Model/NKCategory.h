//
//  NKCategory.h
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKCategory : NSObject
@property (nonatomic, strong) NSString *highlighted_icon;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *small_highlighted_icon;
@property (nonatomic, strong) NSString *small_icon;
@property (nonatomic, strong) NSString *map_icon;
@property (nonatomic, strong) NSArray *subcategories;
@end
