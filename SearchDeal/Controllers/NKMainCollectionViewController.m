//
//  NKMainCollectionViewController.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKMainCollectionViewController.h"
//#import "UIBarButtonItem+NKBarItem.h"
//#import "NKNavLeftView.h"
//#import "NKSortViewController.h"
//#import "NKRegionViewController.h"
//#import "NKCategoryViewController.h"
//#import "NKSorts.h"
//#import "NKCategory.h"
//#import "NKRegion.h"
//#import "DPAPI.h"
//#import "NKDataManager.h"
//#import "NKCollectionViewCell.h"
//#import "MJRefresh.h"
//#import "MBProgressHUD.h"
#import "NKSearchViewController.h"
#import "NKNavigationController.h"


@interface NKMainCollectionViewController () <DPRequestDelegate>
/**  分类视图*/
@property (nonatomic, strong) NKNavLeftView *categoryView;
/**  区域视图*/
@property (nonatomic, strong) NKNavLeftView *regionView;
/**  排序视图*/
@property (nonatomic, strong) NKNavLeftView *sortView;

/**  sortViewController*/
@property (nonatomic, strong) NKSortViewController *sortViewController;
/**  regionViewController*/
@property (nonatomic, strong) NKRegionViewController *regionViewController;
/**  categoryViewController*/
@property (nonatomic, strong) NKCategoryViewController *categoryViewController;

/**  主区域名字 */
@property (nonatomic, strong) NSString *selectedRegionName;
/**  子区域名字 */
@property (nonatomic, strong) NSString *selectedSubRegionName;
/**  排序值 */
@property (nonatomic, strong) NSNumber *selectedSort;
/**  主分类名字*/
@property (nonatomic, strong) NSString *selectedCategoryName;
/**  子分类名字*/
@property (nonatomic, strong) NSString *selectedSubCategoryName;

@end

@implementation NKMainCollectionViewController
#pragma mark - lazyload
- (NKCategoryViewController *)categoryViewController {
    if (!_categoryViewController) {
        _categoryViewController = [[NKCategoryViewController alloc] init];
    }
    return _categoryViewController;
}
- (NKSortViewController *)sortViewController {
    if (!_sortViewController) {
        _sortViewController = [[NKSortViewController alloc] init];
    }
    return _sortViewController;
}
- (NKRegionViewController *)regionViewController {
    if (!_regionViewController) {
        _regionViewController = [[NKRegionViewController alloc] init];
    }
    return _regionViewController;
}

#pragma mark - Main
static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setUpRightItems];
    [self setUpLeftItems];

    [self listenNotificationCenter];
}
#pragma mark - listenMethod
- (void)listenNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSortChange:) name:@"DidSortChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRegionChange:) name:@"DidRegionChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCategoryChange:) name:@"DidCategoryChange" object:nil];
}

- (void)didCategoryChange:(NSNotification *)notify {
    NKCategory *category = notify.userInfo[@"Category"];

    self.categoryView.mainLabel.text = category.name;
    self.categoryView.subLabel.text = notify.userInfo[@"SubCategory"];
    [self loadNewDeals];
}

- (void)didSortChange:(NSNotification *)notify {
    NKSorts *sort = notify.userInfo[@"sort"];

    self.sortView.mainLabel.text = @"排序";
    self.sortView.subLabel.text = sort.label;

    self.selectedSort = sort.value;
    [self loadNewDeals];
}

- (void)didRegionChange:(NSNotification *)notify {
    NKRegion *region = notify.userInfo[@"Region"];
    self.regionView.mainLabel.text = [NSString stringWithFormat:@"杭州-%@",region.name];
    self.regionView.subLabel.text = notify.userInfo[@"SubRegion"];

    self.selectedRegionName = region.name;
    self.selectedSubRegionName = notify.userInfo[@"SubRegion"];
    [self loadNewDeals];
}

#pragma mark - navigationBarItem
- (void)setUpLeftItems {
    UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];


    self.categoryView = [NKNavLeftView getNavView];
    UIBarButtonItem *category = [[UIBarButtonItem alloc] initWithCustomView:self.categoryView];
    [self.categoryView.imageButton addTarget:self action:@selector(clickCategoryItem) forControlEvents:UIControlEventTouchUpInside];


    self.regionView = [NKNavLeftView getNavView];
    self.regionView.mainLabel.text = @"城市-";
    self.regionView.subLabel.text = @"区域";
    [self.regionView.imageButton setImage:[UIImage imageNamed:@"btn_changeCity"] forState:UIControlStateNormal];
    [self.regionView.imageButton setImage:[UIImage imageNamed:@"btn_changeCity_selected"] forState:UIControlStateHighlighted];
    UIBarButtonItem *region = [[UIBarButtonItem alloc] initWithCustomView:self.regionView];
    [self.regionView.imageButton addTarget:self action:@selector(clickRegionItem) forControlEvents:UIControlEventTouchUpInside];


    self.sortView = [NKNavLeftView getNavView];
    self.sortView.mainLabel.text = @"排序";
    self.sortView.subLabel.text = @"默认排序";
    [self.sortView.imageButton setImage:[UIImage imageNamed:@"icon_sort"] forState:UIControlStateNormal];
    [self.sortView.imageButton setImage:[UIImage imageNamed:@"icon_sort_highlighted"] forState:UIControlStateHighlighted];
    UIBarButtonItem *sort = [[UIBarButtonItem alloc] initWithCustomView:self.sortView];
    [self.sortView.imageButton addTarget:self action:@selector(clickSortItem) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItems = @[logo, category, region, sort];


}

- (void)setUpRightItems {
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithImage:@"icon_map" action:@selector(clickMapItem) target:self];
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"icon_search" action:@selector(clickSearchItem) target:self];
    self.navigationItem.rightBarButtonItems = @[mapItem,searchItem];

}

#pragma mark - targetMethod
- (void)clickMapItem {
    NSLog(@"%s",__func__);
}
- (void)clickSearchItem {
    NSLog(@"%s",__func__);
    NKSearchViewController *searchVc = [[NKSearchViewController alloc] init];
    NKNavigationController *nav = [[NKNavigationController alloc] initWithRootViewController:searchVc];

    [self presentViewController:nav animated:YES completion:nil];
}
- (void)clickCategoryItem {
    self.categoryViewController.modalPresentationStyle = UIModalPresentationPopover;

    self.categoryViewController.popoverPresentationController.sourceView = self.categoryView;

    self.categoryViewController.popoverPresentationController.sourceRect = self.categoryView.bounds;

    [self presentViewController:self.categoryViewController animated:YES completion:nil];
}
- (void)clickSortItem {
    self.sortViewController.modalPresentationStyle = UIModalPresentationPopover;

    self.sortViewController.popoverPresentationController.sourceView = self.sortView;

    self.sortViewController.popoverPresentationController.sourceRect = self.sortView.bounds;
    
    [self presentViewController:self.sortViewController animated:YES completion:nil];
}
- (void)clickRegionItem {
    self.regionViewController.modalPresentationStyle = UIModalPresentationPopover;

    self.regionViewController.popoverPresentationController.sourceView = self.regionView;
    self.regionViewController.popoverPresentationController.sourceRect = self.regionView.bounds;

    [self presentViewController:self.regionViewController animated:YES completion:nil];
}

#pragma mark - superMethod
- (void)settingParams:(NSMutableDictionary *)params {
    params[@"city"] = @"杭州";

    //发送主区域名字/子区域名字
    if (self.selectedRegionName) {
        //用户选择了区域
        if (self.selectedSubRegionName) {
            //有子区域名字
            params[@"region"] = self.selectedSubRegionName;
        } else {
            //没有子区域,发送主区域的名字
            params[@"region"] = self.selectedRegionName;
        }
    }
    //区域参数设定
    if (self.selectedCategoryName) {
        //用户选择了分类
        if (self.selectedSubCategoryName) {
            //有子分类名字
            params[@"category"] = self.selectedSubCategoryName;
        } else {
            //没有子分类,发送主分类的名字
            params[@"category"] = self.selectedCategoryName;
        }
    }
    if (self.selectedSort) {
        params[@"sort"] = self.selectedSort;
    }
    if (self.selectedRegionName) {
        params[@"region"] = self.selectedSubRegionName? self.selectedSubRegionName : self.selectedRegionName;
    }
}


@end
