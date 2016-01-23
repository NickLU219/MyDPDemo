//
//  UIBarButtonItem+NKBarItem.h
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (NKBarItem)
+ (instancetype)itemWithImage:(NSString *)imageName action:(SEL)action target:(id)target;


@end
