//
//  NKCollectionViewCell.h
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/23.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NKDeal.h"

@interface NKCollectionViewCell : UICollectionViewCell
/**  deal */
@property (nonatomic, strong) NKDeal *deal;
@end
