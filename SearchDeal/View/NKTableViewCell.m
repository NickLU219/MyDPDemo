//
//  NKTableViewCell.m
//  SearchDeal
//
//  Created by 陆金龙 on 16/1/22.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "NKTableViewCell.h"

@implementation NKTableViewCell
+ (instancetype)cellWithTabelView:(__kindof UITableView *)tableView withImage:(NSString *)imageName {

    NSString *highlightedImage = [NSString stringWithFormat:@"%@_selected",[imageName substringToIndex:imageName.length - 4]];
    static NSString *identifier = @"cell";
    NKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (!cell) {
        cell = [[NKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:highlightedImage]];


    return cell;
}


- (void)setRegion:(NKRegion *)region {
    _region = region;

    self.textLabel.text = region.name;
    self.accessoryView = region.subregions.count > 0 ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]] : nil;
}

- (void)setCategory:(NKCategory *)category {
    _category = category;

    self.textLabel.text = category.name;
    self.accessoryView = category.subcategories.count > 0 ? [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]] : nil;
    self.imageView.image = [UIImage imageNamed:category.small_icon];
    self.imageView.highlightedImage = [UIImage imageNamed:category.small_highlighted_icon];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
