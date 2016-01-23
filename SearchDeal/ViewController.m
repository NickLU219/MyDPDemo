//
//  ViewController.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/20.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "ViewController.h"
#import "DPAPI.h"
#import "NKDataManager.h"


@interface ViewController () <DPRequestDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSArray *array = [NKDataManager getAllCity];

    // Do any additional setup after loading the view, typically from a nib.
    DPAPI *api = [[DPAPI alloc] init];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"city"] = @"杭州";

    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//success
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    //default 20 messages
    NSLog(@"%@",result);
    NSLog(@"%@",[NSThread currentThread]);
}
//failure
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    //
    NSLog(@"%@",error.userInfo);
}
@end
