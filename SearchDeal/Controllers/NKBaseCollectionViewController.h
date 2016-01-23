//
//  NKBaseCollectionViewController.h
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/23.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBarButtonItem+NKBarItem.h"
#import "NKNavLeftView.h"
#import "NKSortViewController.h"
#import "NKRegionViewController.h"
#import "NKCategoryViewController.h"
#import "NKSorts.h"
#import "NKCategory.h"
#import "NKRegion.h"
#import "DPAPI.h"
#import "NKDataManager.h"
#import "NKCollectionViewCell.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"


@interface NKBaseCollectionViewController : UICollectionViewController <DPRequestDelegate>
- (void)loadNewDeals;

- (void)settingParams:(NSMutableDictionary *)params;
@end
