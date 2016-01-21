//
//  VoucherTableViewCell.h
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/21.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoucherTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *ddlLabel;
@property (strong, nonatomic) IBOutlet UILabel *ruleLabel;
@property (strong, nonatomic) IBOutlet UIButton *toProductButton;

@end
