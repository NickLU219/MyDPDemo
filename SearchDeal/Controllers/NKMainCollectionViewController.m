//
//  NKMainCollectionViewController.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKMainCollectionViewController.h"
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


@interface NKMainCollectionViewController () <DPRequestDelegate>
/**
 *  分类视图
 */
@property (nonatomic, strong) NKNavLeftView *categoryView;
/**
 *  区域视图
 */
@property (nonatomic, strong) NKNavLeftView *regionView;
/**
 *  排序视图
 */
@property (nonatomic, strong) NKNavLeftView *sortView;
/**
 *  sortViewController
 */
@property (nonatomic, strong) NKSortViewController *sortViewController;
/**
 *  regionViewController
 */
@property (nonatomic, strong) NKRegionViewController *regionViewController;
/**
 *  categoryViewController
 */
@property (nonatomic, strong) NKCategoryViewController *categoryViewController;
/**  主区域名字 */
@property (nonatomic, strong) NSString *selectedRegionName;
/**  子区域名字 */
@property (nonatomic, strong) NSString *selectedSubRegionName;
/**  排序值 */
@property (nonatomic, strong) NSNumber *selectedSort;
//主分类名字
@property (nonatomic, strong) NSString *selectedCategoryName;
//子分类名字
@property (nonatomic, strong) NSString *selectedSubCategoryName;
/**  dealArray */
@property (nonatomic, strong) NSMutableArray<NKDeal *> *dealArray;

/**  page */
@property (nonatomic, assign) int page;
/**  latestRequest */
@property (nonatomic, strong) DPRequest *request;
@end

@implementation NKMainCollectionViewController
#pragma mark - lazyload
- (NSMutableArray<NKDeal *> *)dealArray {
    if (!_dealArray) {
        _dealArray = [NSMutableArray array];
    }
    return _dealArray;
}
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
static NSString * const reuseIdentifier = @"Cell";
#pragma mark - Main
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    

    [self setUpRightItems];
    [self setUpLeftItems];
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NKCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    [self listenNotificationCenter];

    [self setupRefreshControl];

}

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
#pragma mark - setupRefreshControl

- (void)setupRefreshControl {
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDeals)];
    [self.collectionView.mj_footer beginRefreshing];
}
#pragma mark - [self loadNewDeals]
- (void)loadMoreDeals {
    self.page++;
    [self sendRequestToServer];
}
- (void)loadNewDeals {
    self.page = 1;
    [self.dealArray removeAllObjects];
    [self sendRequestToServer];
}
- (void)sendRequestToServer {
    DPAPI *api = [DPAPI new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

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

    params[@"page"] = @(self.page);

    self.request = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];


}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@",error.userInfo);

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"网络信号似乎不太好~";
    hud.margin = 10;

    [hud hide:YES afterDelay:2];

    [self.collectionView.mj_footer endRefreshing];


}
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    if (self.request != request) {
        return;
    }

    [self.dealArray addObjectsFromArray: [NKDataManager parseDealJson:result]];
    [self.collectionView reloadData];

    [self.collectionView.mj_footer endRefreshing];
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

- (void)clickMapItem {
    NSLog(@"%s",__func__);
}
- (void)clickSearchItem {
    NSLog(@"%s",__func__);
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
#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dealArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    // Configure the cell
    NKDeal *deal = self.dealArray[indexPath.item];
    cell.deal = deal;

    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
