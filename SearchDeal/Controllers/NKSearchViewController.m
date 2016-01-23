//
//  NKSearchViewController.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/23.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKSearchViewController.h"

@interface NKSearchViewController () <UISearchBarDelegate>
/**  searchbar */
@property (nonatomic, strong) UISearchBar *bar;
@end

@implementation NKSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    


    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:@"icon_back" action:@selector(clickBack) target:self];

    self.navigationItem.leftBarButtonItem = backItem;

    self.bar = [[UISearchBar alloc] init];
    self.bar.placeholder = @"请输入搜索内容~";
    self.bar.delegate = self;

    self.navigationItem.titleView = self.bar;


}

- (void)clickBack {
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark - search
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self loadNewDeals];
    [searchBar resignFirstResponder];
}

- (void)settingParams:(NSMutableDictionary *)params {
    params[@"city"] = @"杭州";
    params[@"keyword"] = self.bar.text;

}
@end
