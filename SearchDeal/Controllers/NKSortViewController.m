//
//  NKSortViewController.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKSortViewController.h"
#import "NKSorts.h"
#import "NKDataManager.h"

@interface NKSortViewController ()
@property (nonatomic, strong) NSArray<NKSorts *> *sortArray;
@end

@implementation NKSortViewController
#pragma mark - Lazyload
- (NSArray<NKSorts *> *)sortArray {
    if (!_sortArray) {
        _sortArray = [NKDataManager getAllSorts];
    }
    return _sortArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];


    /** 边距 */
    CGFloat inset = 15;
    /** buttonW/H */
    CGFloat buttonW = 100;
    CGFloat buttonH = 30;
    CGRect frame = CGRectMake(0, 0, buttonW, buttonH);

    for (int i = 0; i < self.sortArray.count; i++) {
        NKSorts *sort = self.sortArray[i];
        UIButton *btn = [UIButton new];
        btn.tag = i;
        btn.frame = CGRectOffset(frame, inset, i * (inset + buttonH) + inset);

        [btn setTitle:sort.label forState:UIControlStateNormal];

        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:btn];

    }

    self.preferredContentSize = CGSizeMake(buttonW + 2 * inset, (inset + buttonH) * self.sortArray.count + inset);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.popoverPresentationController.backgroundColor = [UIColor whiteColor];
}

- (void)clickButton:(UIButton *)button {
    NKSorts *sort = self.sortArray[button.tag];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSortChange" object:self userInfo:@{@"sort": sort}];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
