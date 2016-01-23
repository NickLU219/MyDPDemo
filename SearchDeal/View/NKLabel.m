//
//  NKLabel.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/23.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKLabel.h"

@implementation NKLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextMoveToPoint(context, 0, rect.size.height / 2);

    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), rect.size.height / 2);

    CGContextStrokePath(context);

}


@end
