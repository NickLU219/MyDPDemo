//
//  NKTableViewCell.h
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKRegion.h"
#import "NKCategory.h"

@interface NKTableViewCell : UITableViewCell

@property (nonatomic, strong) NKRegion *region;
@property (nonatomic, strong) NKCategory *category;

+ (instancetype)cellWithTabelView:(__kindof UITableView *)tableView withImage:(NSString *)imageName;
@end
