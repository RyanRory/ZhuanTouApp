//
//  WenjianIngTableViewCell.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/19.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "WenjianIngTableViewCell.h"

@implementation WenjianIngTableViewCell

@synthesize bgView, headView;

- (void)awakeFromNib {
    // Initialization code
    bgView.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
