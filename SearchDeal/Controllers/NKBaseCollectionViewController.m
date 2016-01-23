//
//  NKBaseCollectionViewController.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/23.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKBaseCollectionViewController.h"


@interface NKBaseCollectionViewController ()
/**  dealArray */
@property (nonatomic, strong) NSMutableArray<NKDeal *> *dealArray;
/**  page */
@property (nonatomic, assign) int page;
/**  latestRequest */
@property (nonatomic, strong) DPRequest *request;
@end

@implementation NKBaseCollectionViewController
#pragma mark - lazyload
- (NSMutableArray<NKDeal *> *)dealArray {
    if (!_dealArray) {
        _dealArray = [NSMutableArray array];
    }
    return _dealArray;
}

#pragma mark - Main
- (instancetype)init {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    layout.itemSize = CGSizeMake(305, 305);

    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);

    return [self initWithCollectionViewLayout:layout];
}

static NSString * const reuseIdentifier = @"Cell";
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"NKCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
//    [self setupRefreshControl];

}
- (void)settingParams:(NSMutableDictionary *)params {

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

    [self settingParams:params];

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
@end
