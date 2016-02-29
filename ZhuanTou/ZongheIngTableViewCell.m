//
//  ZongheIngTableViewCell.m
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/19.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import "ZongheIngTableViewCell.h"

@implementation ZongheIngTableViewCell

@synthesize bgView, headView, quitButton;

- (void)awakeFromNib {
    // Initialization code
    quitButton.layer.borderColor = [UIColor whiteColor].CGColor;
    quitButton.layer.borderWidth = 1;
    quitButton.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
