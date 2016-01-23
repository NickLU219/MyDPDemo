//
//  NKCollectionViewCell.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/23.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKCollectionViewCell.h"
#import "UIImageView+WebCache.h"


@interface NKCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;
@property (weak, nonatomic) IBOutlet UILabel *dealTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
@implementation NKCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDeal:(NKDeal *)deal {
    _deal = deal;
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dealcell"]];

    self.dealTitleLabel.text = deal.title;
    self.dealDetailLabel.text = deal.desc;
    self.currentPriceLabel.text = [NSString stringWithFormat:@"¥ %@",deal.current_price];
    self.listPriceLabel.text = [NSString stringWithFormat:@"¥ %@",deal.list_price];
    self.countLabel.text = [NSString stringWithFormat:@"已售: %d",deal.purchase_count];
    [self.dealImageView sd_setImageWithURL:[NSURL URLWithString:deal.s_image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
}
@end
