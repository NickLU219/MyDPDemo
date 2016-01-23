//
//  NKDeal.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKDeal.h"

@implementation NKDeal
//MJExtention
//重写方法(将字典中的关键字description和模型类中的desc进行绑定)
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //key:字典中的key等于description
    if ([key isEqualToString:@"description"]) {
        //value就是description这个可以对应的value
        self.desc = value;
    }
}

@end
