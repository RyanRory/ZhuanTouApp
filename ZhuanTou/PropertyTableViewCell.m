//
//  PropertyTableViewCell.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/12/24.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "PropertyTableViewCell.h"

@implementation PropertyTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.drawButton.layer setBorderWidth:1.0f];
    [self.drawButton.layer setBorderColor:ZTBLUE.CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
