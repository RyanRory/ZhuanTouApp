//
//  WenjianEndedTableViewCell.h
//  ZhuanTou
//
//  Created by 赵润声 on 15/10/19.
//  Copyright © 2015年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WenjianEndedTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet HeadView *bgView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel *standingTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *profitTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *standingNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *profitNumLabel;


@end
