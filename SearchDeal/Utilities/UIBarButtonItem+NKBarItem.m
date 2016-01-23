//
//  UIBarButtonItem+NKBarItem.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "UIBarButtonItem+NKBarItem.h"

@implementation UIBarButtonItem (NKBarItem)
+ (instancetype)itemWithImage:(NSString *)imageName action:(SEL)action target:(id)target {
    UIButton *btn = [UIButton new];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_highlighted",imageName]] forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//    btn.frame = CGRectMake(0, 0, 80, 40);
    [btn sizeToFit];

    return  [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
