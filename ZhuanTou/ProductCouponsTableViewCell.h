//
//  ProductCouponsTableViewCell.h
//  ZhuanTou
//
//  Created by 赵润声 on 16/1/22.
//  Copyright © 2016年 Shanghai Momu Financial Information Service  Shanghai Momu Financial Information Service Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductCouponsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *bonusBgView;
@property (strong, nonatomic) IBOutlet UILabel *bonusNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *bonusLimitLabel;
@property (strong, nonatomic) IBOutlet UILabel *bonusDDLLabel;
@property (strong, nonatomic) IBOutlet UIButton *bonusButton;
@property (strong, nonatomic) IBOutlet UIButton *bonusMoreButton;

@end
