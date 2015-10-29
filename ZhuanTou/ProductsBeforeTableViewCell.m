//
//  ProductsBeforeTableViewCell.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/29.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ProductsBeforeTableViewCell.h"

@implementation ProductsBeforeTableViewCell

@synthesize bgView;

- (void)awakeFromNib {
    // Initialization code
    bgView.layer.cornerRadius = 3;
    bgView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
