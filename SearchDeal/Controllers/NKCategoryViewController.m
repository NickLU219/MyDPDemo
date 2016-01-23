//
//  NKCategoryViewController.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKCategoryViewController.h"
#import "NKDataManager.h"
#import "NKCategory.h"
#import "NKTableViewCell.h"

@interface NKCategoryViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;

/**
 *  所有分类的数据
 */
@property (nonatomic, strong) NSArray<NKCategory *> *categoryArray;
@end

@implementation NKCategoryViewController
#pragma mark - lazyload
- (NSArray<NKCategory *> *)categoryArray {
    if (!_categoryArray) {
        _categoryArray = [NKDataManager getAllCategory];
    }
    return _categoryArray;
}
#pragma mark - Main
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.mainTableView.tableFooterView = [UIView new];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.subTableView.tableFooterView = [UIView new];
    self.subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - UITableViewDatasource
-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView == self.mainTableView ? self.categoryArray.count : self.categoryArray[self.mainTableView.indexPathForSelectedRow.row].subcategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        NKTableViewCell *cell = [NKTableViewCell cellWithTabelView:tableView withImage:@"bg_dropdown_leftpart"];
        cell.category = self.categoryArray[indexPath.row];



        return cell;
    } else {
        NKTableViewCell *cell = [NKTableViewCell cellWithTabelView:tableView withImage:@"bg_dropdown_rightpart"];
        cell.textLabel.text = self.categoryArray[self.mainTableView.indexPathForSelectedRow.row].subcategories[indexPath.row];


        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        [self.subTableView reloadData];
        NKCategory *category = self.categoryArray[indexPath.row];
        if (category.subcategories.count == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DidCategoryChange" object:self userInfo:@{@"Category":category}];
            [self dismissViewControllerAnimated:YES completion:nil];

        }

    } else {
        NSInteger selectedLeftRow = [self.mainTableView indexPathForSelectedRow].row;
        NSInteger selectedRightRow = [self.subTableView indexPathForSelectedRow].row;

        NKCategory *category = self.categoryArray[selectedLeftRow];

        NSString *subCategoryName = category.subcategories[selectedRightRow];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidCategoryChange" object:self userInfo:@{@"Category":category,@"SubCategory":subCategoryName}];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
