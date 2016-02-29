//
//  YesterdayIncomeTableViewCell.h
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/12.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YesterdayIncomeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *profitLabel;

@property (strong, nonatomic) IBOutlet UILabel *amountTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *profitTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end
