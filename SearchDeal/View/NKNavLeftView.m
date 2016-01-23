//
//  NKNavLeftView.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/21.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKNavLeftView.h"

@implementation NKNavLeftView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (NKNavLeftView *)getNavView {
    return [[NSBundle mainBundle] loadNibNamed:@"NKNavLeftView" owner:self options:nil].lastObject;
}
/**
 *  防止拉伸
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizesSubviews = NO;
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

@end
