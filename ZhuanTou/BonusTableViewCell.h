//
//  BonusTableViewCell.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/25.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BonusTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *ddlLabel;
@property (strong, nonatomic) IBOutlet UILabel *ruleLabel;

@end
