//
//  NKRegionViewController.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKRegionViewController.h"
#import "NKDataManager.h"
#import "NKRegion.h"
#import "NKTableViewCell.h"
#import "NKNKCityGroupViewController.h"


@interface NKRegionViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;

/**
 *  所有区域的数据
 */
@property (nonatomic, strong) NSArray<NKRegion *> *regionArray;
@end

@implementation NKRegionViewController
#pragma mark - Lazyload
- (NSArray<NKRegion *> *)regionArray {
    if (!_regionArray) {
//        _regionArray = [NKDataManager getAllRegionWithCityName:@"杭州"];

    }
    return _regionArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mainTableView.tableFooterView = [UIView new];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.subTableView.tableFooterView = [UIView new];
    self.subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self listemCityNotification];
}
- (void)listemCityNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCityChange:) name:@"DidCityChange" object:nil];
}
- (void)didCityChange:(NSNotification *)notify {
    self.regionArray = [NKDataManager getAllRegionWithCityName:notify.userInfo[@"CityName"]];

    [self.mainTableView reloadData];
    [self.subTableView reloadData];
}

#pragma mark - UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView == self.mainTableView ? self.regionArray.count : self.regionArray[self.mainTableView.indexPathForSelectedRow.row].subregions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        NKTableViewCell *cell = [NKTableViewCell cellWithTabelView:tableView withImage:@"bg_dropdown_leftpart"];
        cell.region = self.regionArray[indexPath.row];
        return cell;
    } else {
        NKTableViewCell *cell = [NKTableViewCell cellWithTabelView:tableView withImage:@"bg_dropdown_rightpart"];
        cell.textLabel.text = self.regionArray[self.mainTableView.indexPathForSelectedRow.row].subregions[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        [self.subTableView reloadData];
        NKRegion *region = self.regionArray[indexPath.row];
        if (region.subregions.count == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DidRegionChange" object:self userInfo:@{@"Region":region}];
            [self dismissViewControllerAnimated:YES completion:nil];

        }
    } else {
        NSInteger selectedLeftRow = [self.mainTableView indexPathForSelectedRow].row;
        NSInteger selectedRightRow = [self.subTableView indexPathForSelectedRow].row;

        NKRegion *region = self.regionArray[selectedLeftRow];

        NSString *subRegionName = region.subregions[selectedRightRow];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidRegionChange" object:self userInfo:@{@"Region":region,@"SubRegion":subRegionName}];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - IBAction
- (IBAction)changeCity:(UIButton *)sender {
    //
    NKNKCityGroupViewController *cityVc = [NKNKCityGroupViewController new];

    cityVc.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:cityVc animated:YES completion:nil];
}

@end
